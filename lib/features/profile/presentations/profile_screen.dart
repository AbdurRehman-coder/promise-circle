import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Added for Clipboard
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:sbp_app/core/constants/assets.dart';
import 'package:sbp_app/core/services/notification_service.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/core/utils/text_styles.dart';

import 'package:sbp_app/features/auth/provider/authentication_providr.dart';
import 'package:sbp_app/features/main_home/provider/main_home_provider.dart';
import 'package:sbp_app/features/onboarding/presentation/screens/promise_profile_screen.dart';
import 'package:sbp_app/features/profile/presentations/support_screen.dart';
import 'package:sbp_app/features/profile/providers/profile_provider.dart';

import 'package:sbp_app/features/shared/widgets/flushbar.dart';
import 'package:sbp_app/features/shared/widgets/legal_web_view.dart';
import 'package:sbp_app/features/shared/widgets/w_app_confirmation_dialog.dart';
import 'package:sbp_app/features/shared/widgets/w_app_safe_area.dart';
import 'package:sbp_app/features/shared/widgets/w_primary_button.dart';
import 'package:sbp_app/main.dart';

import '../../auth/models/subscription_data_model.dart';
import '../../shared/widgets/elastic_drag_sheet.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _notificationsEnabled = true;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _checkNotificationStatus();
  }

  Future<void> _checkNotificationStatus() async {
    await NotificationService().init();
    final bool isGranted = await NotificationService().isPermissionGranted();
    if (mounted) {
      setState(() {
        _notificationsEnabled = isGranted;
      });
    }
  }

  Future<void> _onNotificationToggleChanged(bool value, WidgetRef ref) async {
    final currentUser = ref.read(authenticationProvider).authUser?.user;
    if (currentUser == null) return;

    _showLoadingDialog();

    try {
      final updatedSettings = currentUser.settings?.copyWith(
        notifications: value,
      );
      final updatedUser = currentUser.copyWith(settings: updatedSettings);

      await NotificationService().toggleNotifications(value);
      await ref
          .read(authenticationProvider.notifier)
          .updateBasicInfo(updatedUser);

      if (mounted) Navigator.pop(context);

      setState(() {
        _notificationsEnabled = value;
      });

      if (mounted) {
        if (value) {
          final bool isGranted = await NotificationService()
              .isPermissionGranted();
          if (!isGranted) {
            setState(() => _notificationsEnabled = false);
            FlashMessage.showError(
              navigatorKey.currentContext!,
              'Permission denied. Please enable notifications in device settings.',
            );
          } else {
            FlashMessage.showSuccess(
              navigatorKey.currentContext!,
              'Notifications enabled.',
            );
          }
        } else {
          FlashMessage.showSuccess(context, 'Notifications turned off.');
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        FlashMessage.showError(context, 'Failed to update settings.');
        setState(() => _notificationsEnabled = !_notificationsEnabled);
      }
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: AppColors.primaryBlackColor),
              SizedBox(height: 16),
              Text(
                "Updating settings...",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickAndUploadImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        if (!mounted) return;

        final newUrl = await ref
            .read(profileProvider.notifier)
            .uploadProfileImage(File(pickedFile.path));

        if (newUrl != null && mounted) {
          FlashMessage.showSuccess(
            context,
            'Profile picture updated successfully',
          );
        }
      }
    } catch (e) {
      if (mounted) FlashMessage.showError(context, 'Failed to pick image');
    }
  }

  Future<void> _handleDeleteAccount() async {
    final success = await ref
        .read(profileProvider.notifier)
        .deleteUserAccount(context);

    if (success && mounted) {
      FlashMessage.showSuccess(context, 'Profile deleted successfully');
      ref.read(authenticationProvider.notifier).logout(ref, context);
      ref.read(bottomNavIndexProvider.notifier).state = 0;
    } else if (mounted) {
      FlashMessage.showError(context, 'Failed to delete account');
    }
  }

  Future<void> _handleCancelSubscription() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AppConfirmationDialog(
        title: "Cancel Subscription?",
        description:
            "Your access will remain active until the period ends.\nAre you sure?",
        iconPath: Assets.svgPremiumIcon,
        primaryButtonText: "Yes, Cancel",
        onPrimaryPressed: () => Navigator.pop(context, true),
      ),
    );

    if (confirm != true) return;

    if (!mounted) return;
    // Navigator.pop(context);

    _showLoadingDialog();

    final success = await ref
        .read(profileProvider.notifier)
        .cancelSubscription(context);
    ref.read(authenticationProvider.notifier).getUserSubscription();

    if (!mounted) return;
    Navigator.pop(context);

    if (success) {
      FlashMessage.showSuccess(
        context,
        'Subscription scheduled for cancellation.',
      );
    } else {
      FlashMessage.showError(context, 'Failed to cancel subscription.');
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    FlashMessage.showSuccess(context, 'Copied to clipboard');
  }

  void _showSubscriptionDetails(SubscriptionData? subscription) {
    // If subscription is null or active is false, we treat it as "Free/Inactive"
    final bool isActive = subscription?.hasAccess ?? false;
    final themeColor = isActive ? const Color(0xFF6B5E96) : Colors.grey;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ElasticDragSheet(
        builder: (context, physics) => Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle Bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Header Row (Fixed)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Subscription Details",
                    style: AppTextStyles.headingTextStyleBogart.copyWith(
                      fontSize: 22,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFFE5F9E7)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isActive
                            ? const Color(0xFFBBE5BE)
                            : Colors.grey[300]!,
                      ),
                    ),
                    child: Text(
                      isActive ? "Active" : "Inactive",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isActive
                            ? const Color(0xFF2E7D32)
                            : Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Scrollable Content
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isActive || subscription == null)
                      _buildNoSubscriptionView()
                    else
                      _buildActiveSubscriptionView(subscription, themeColor),

                    const SizedBox(height: 16),
                    PrimaryButton(
                      text: "Close",
                      isOutlined: true,
                      textColor: AppColors.primaryBlackColor,
                      borderColor: Colors.grey[300]!,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoSubscriptionView() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(Icons.stars_outlined, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            "Free Plan",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlackColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "You currently do not have an active premium subscription.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveSubscriptionView(
    SubscriptionData subscription,
    Color themeColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. MAIN PLAN INFO CARD
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                themeColor.withValues(alpha: 0.1),
                themeColor.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: themeColor.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: SvgPicture.asset(
                      Assets.svgPremiumIcon,
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        themeColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subscription.planType.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: themeColor,
                        ),
                      ),
                      Text(
                        subscription.cancelAtPeriodEnd
                            ? "Ends on ${DateFormat('MMM dd').format(subscription.expiryDate)}"
                            : "Renews in ${subscription.intervalMonths} month${subscription.intervalMonths > 1 ? 's' : ''}",
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(height: 1),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Expiry Date",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  Text(
                    DateFormat('MMM dd, yyyy').format(subscription.expiryDate),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.primaryBlackColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // 2. INVITE CODE (Only if Owner and Code exists)
        if (subscription.isOwner && subscription.inviteCode != null) ...[
          const SizedBox(height: 24),
          Text(
            "Invite Code",
            style: AppTextStyles.bodyTextStyle.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _copyToClipboard(subscription.inviteCode!),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey[300]!,
                  style: BorderStyle.solid,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    subscription.inviteCode!,
                    style: const TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: AppColors.primaryBlackColor,
                    ),
                  ),
                  const Icon(Icons.copy, size: 20, color: Colors.grey),
                ],
              ),
            ),
          ),
        ],

        // 3. TEAM USAGE / PROGRESS BAR
        if (subscription.seatsTotal > 0) ...[
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Seats Usage",
                style: AppTextStyles.bodyTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                "${subscription.seatsUsed} / ${subscription.seatsTotal} Seats",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.primaryBlackColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: subscription.seatsTotal > 0
                  ? subscription.seatsUsed / subscription.seatsTotal
                  : 0,
              minHeight: 8,
              backgroundColor: Colors.grey[100],
              valueColor: AlwaysStoppedAnimation<Color>(themeColor),
            ),
          ),
        ],

        // 4. MEMBERS LIST (Only if Owner and Users exist)
        if (subscription.isOwner && subscription.users.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            "Members",
            style: AppTextStyles.bodyTextStyle.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: subscription.users.length,
              separatorBuilder: (c, i) =>
                  Divider(height: 1, thickness: 0.5, color: Colors.grey[200]),
              itemBuilder: (context, index) {
                final user = subscription.users[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[100],
                      image: user.profilePicture != null
                          ? DecorationImage(
                              image: NetworkImage(user.profilePicture!),
                            )
                          : null,
                    ),
                    child: user.profilePicture == null
                        ? Center(
                            child: Text(
                              user.name[0].toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : null,
                  ),
                  title: Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    user.email,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: user.isOwner
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            "OWNER",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : null,
                );
              },
            ),
          ),
        ],

        if (subscription.isOwner && !subscription.cancelAtPeriodEnd) ...[
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              onPressed: _handleCancelSubscription,
              isOutlined: true,
              borderColor: AppColors.errorColor,
              textColor: AppColors.errorColor,
              text: 'Cancel Subscription',
            ),
          ),
        ] else if (subscription.cancelAtPeriodEnd) ...[
          const SizedBox(height: 32),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
            ),
            child: const Text(
              "Your subscription is set to expire at the end of the current billing period.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Color(0xFFB45309)),
            ),
          ),
        ],
      ],
    );
  }

  // --- SUBSCRIPTION LOGIC END ---

  void _onEditAvatar() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AppSafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera, color: Colors.black87),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.of(context).pop();
                _pickAndUploadImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.black87),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.of(context).pop();
                _pickAndUploadImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.close, color: Colors.red),
              title: const Text('Cancel', style: TextStyle(color: Colors.red)),
              onTap: () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AppConfirmationDialog(
        title: "Are you sure?",
        description: "You are going to delete account.\nProceed?",
        iconPath: Assets.svgDUserIcon,
        primaryButtonText: "Yes, delete account",
        onPrimaryPressed: () {
          Navigator.pop(context);
          _handleDeleteAccount();
        },
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AppConfirmationDialog(
        title: "Are you sure?",
        description: "You are going to logout.\nProceed?",
        iconPath: Assets.svgDLogoutIcon,
        primaryButtonText: "Yes, log out",
        onPrimaryPressed: () {
          Navigator.pop(context);
          ref.read(authenticationProvider.notifier).logout(ref, context);
          ref.read(bottomNavIndexProvider.notifier).state = 0;
        },
      ),
    );
  }

  Widget _buildStatCard(String emoji, String count, String label) {
    return Expanded(
      child: Container(
        height: 130.h,
        decoration: BoxDecoration(
          color: const Color(0xFFEEECE8),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 32.h,
              width: 32.w,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Text(emoji, style: const TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 8),
            Text(
              count,
              style: AppTextStyles.headingTextStyleBogart.copyWith(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11.sp, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required String iconPath,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                SvgPicture.asset(
                  iconPath,
                  width: 22.w,
                  height: 22.h,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF6B5E96),
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryBlackColor,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null)
                  trailing
                else if (subtitle == null)
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey[400],
                    size: 20.sp,
                  ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(height: 1, thickness: 0.5, color: Colors.grey[300]),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(
        title,
        style: AppTextStyles.bodyTextStyle.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.primaryBlackColor,
        ),
      ),
    );
  }

  Widget _buildProfileHeader(dynamic user, bool isImageLoading) {
    return Column(
      children: [
        Center(
          child: Stack(
            children: [
              Container(
                height: 110.h,
                width: 110.w,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                  image: (user.displayPictureURL?.isNotEmpty ?? false)
                      ? DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(user.displayPictureURL!),
                        )
                      : null,
                ),
                child: (user.displayPictureURL?.isEmpty ?? true)
                    ? Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SvgPicture.asset(
                          Assets.svgBottomBarMainIcon,
                          fit: BoxFit.contain,
                        ),
                      )
                    : null,
              ),
              if (isImageLoading)
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black26,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Material(
                  elevation: 2,
                  shape: const CircleBorder(),
                  color: Colors.white,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: isImageLoading ? null : _onEditAvatar,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: SvgPicture.asset(
                        Assets.svgEditImage,
                        width: 16.w,
                        height: 16.h,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          user.name ?? 'N/A',
          style: AppTextStyles.headingTextStyleBogart.copyWith(fontSize: 24.sp),
        ),
        const SizedBox(height: 4),
        Text(
          user.email ?? 'N/A',
          style: AppTextStyles.bodyTextStyle.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryBlackColor.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildMyProfileCard(dynamic user) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          PromiseProfileScreen.routeName,
          arguments: {
            'onboarding': user.onboarding,
            'show_first_promise_button': false,
          },
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.primaryBlackColor,
                  fontFamily: 'Inter',
                ),
                children: [
                  const TextSpan(text: "My Profile: "),
                  TextSpan(
                    text: user.onboarding?.profile.label ?? "N/A",
                    style: const TextStyle(
                      color: Color(0xFF6B5E96),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(dynamic user, SubscriptionData? subscription) {
    final bool hasActiveSubscription = subscription?.hasAccess ?? false;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Profile'),
          _buildListTile(iconPath: Assets.svgUser, title: user.name ?? "N/A"),
          _buildListTile(
            iconPath: Assets.svgEmailIcon,
            title: user.email ?? "N/A",
            showDivider: true,
          ),

          _buildSectionHeader('Settings'),

          // --- SUBSCRIPTION TILE ---
          if (false)
            _buildListTile(
              iconPath: Assets.svgPremiumIcon,
              title: 'My Subscription',

              subtitle: hasActiveSubscription
                  ? subscription!.planType.toUpperCase()
                  : "Free Plan",
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: hasActiveSubscription
                      ? const Color(0xFFE5F9E7)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  hasActiveSubscription ? "ACTIVE" : "INACTIVE",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: hasActiveSubscription
                        ? const Color(0xFF2E7D32)
                        : Colors.grey[600],
                  ),
                ),
              ),
              onTap: () => _showSubscriptionDetails(subscription),
            ),

          // -------------------------
          _buildListTile(
            iconPath: Assets.svgNotificationIcon,
            title: 'Notifications',
            showDivider: true,
            onTap: () =>
                _onNotificationToggleChanged(!_notificationsEnabled, ref),
            trailing: Transform.scale(
              scale: 0.8,
              child: CupertinoSwitch(
                value: _notificationsEnabled,
                activeColor: AppColors.primaryBlackColor,
                onChanged: (val) => _onNotificationToggleChanged(val, ref),
              ),
            ),
          ),
          _buildSectionHeader('About'),
          _buildListTile(
            iconPath: Assets.svgSupportStyleIcon,
            title: 'Support',
            onTap: () {
              Navigator.pushNamed(context, SupportScreen.routePath);
            },
          ),
          _buildListTile(
            iconPath: Assets.svgPricacyPolicyIcon,
            title: 'Privacy Policy',
            showDivider: false,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => LegalWebViewPage(
                    title: "Privacy Policy",
                    url: 'https://stopbreakingpromises.com/privacy-policy',
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 30),
          PrimaryButton(
            text: 'Logout',
            isOutlined: true,
            textColor: AppColors.primaryBlackColor,
            borderColor: AppColors.primaryBlackColor.withValues(alpha: 0.2),
            onPressed: _confirmLogout,
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            text: 'Delete profile',
            backgroundColor: const Color(0xFFFFC1C1),
            borderColor: const Color(0xFFFFB2B2),
            textColor: const Color(0xFFAE0000),
            onPressed: _confirmDelete,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final authState = ref.watch(authenticationProvider);
    final user = authState.authUser?.user;

    // NOTE: Ensure your Auth/User model has a field 'subscriptionData'
    // that returns the new SubscriptionData object.
    final SubscriptionData? subscription = authState.subscriptionData;

    if (user == null) return const Center(child: CircularProgressIndicator());

    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFFF9F8F4),
          body: AppSafeArea(
            bottom: false,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _buildProfileHeader(user, profileState.isImageLoading),
                      const SizedBox(height: 24),
                      _buildMyProfileCard(user),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          _buildStatCard(
                            "🔥",
                            (user.promisesKept ?? 0).toString(),
                            'Promises\nKept',
                          ),
                          const SizedBox(width: 12),
                          _buildStatCard(
                            "🤝",
                            (user.promisesCount ?? 0).toString(),
                            'Active\nPromise${(user.promisesCount ?? 0) > 1 ? "s" : ""}',
                          ),
                          const SizedBox(width: 12),
                          _buildStatCard(
                            "📝",
                            (user.reflectionsCount ?? 0).toString(),
                            'Reflection\nLogged',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Pass the real subscription object (nullable) to the menu
                _buildMenuSection(user, subscription),
              ],
            ),
          ),
        ),
        // if (profileState.isLoading)
        //   Container(
        //     color: Colors.black26,
        //     child: const Center(
        //       child: CircularProgressIndicator(
        //         color: AppColors.secondaryBlueColor,
        //       ),
        //     ),
        //   ),
      ],
    );
  }
}
