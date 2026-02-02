import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sbp_app/features/profile/services/profile_services.dart';
import 'package:sbp_app/features/promise/models/promise_model.dart';
import 'package:sbp_app/features/shared/widgets/flushbar.dart';

import '../../../../core/services/app_services.dart';
import '../../../../core/services/facebook_events_service.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/utils/app_exports.dart';
import '../../../../core/utils/responsive_config.dart';
import '../../../../core/utils/text_styles.dart';
import '../../../shared/widgets/w_primary_button.dart';
import '../../services/reflection_services.dart';

class ReflectionSheet extends StatefulWidget {
  final PromiseModel promise;

  const ReflectionSheet({super.key, required this.promise});

  @override
  State<ReflectionSheet> createState() => _ReflectionSheetState();
}

class _ReflectionSheetState extends State<ReflectionSheet> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ImagePicker _picker = ImagePicker();

  final ProfileServices _profileServices = locator<ProfileServices>();
  final ReflectionServices _reflectionServices = locator<ReflectionServices>();

  File? _selectedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 50,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  Future<void> _handleSave(WidgetRef ref) async {
    if (_controller.text.trim().length < 30) {
      FlashMessage.showError(
        context,
        "Reflection must be at least 30 characters.",
      );

      return;
    }

    setState(() => _isLoading = true);

    try {
      String? uploadedImageUrl;

      if (_selectedImage != null) {
        final extension = _selectedImage!.path.split('.').last;
        final presignedData = await _profileServices.getPresignedUrl(
          folder: 'reflections',
          fileExtension: extension,
        );

        if (presignedData != null) {
          final uploadUrl = presignedData['presignedUrl'];
          final publicUrl = presignedData['publicUrl'];

          if (uploadUrl != null && publicUrl != null) {
            String contentType = extension.contains('png')
                ? 'image/png'
                : 'image/jpeg';

            final success = await _profileServices.uploadImageToSignedUrl(
              uploadUrl,
              _selectedImage!,
              contentType,
            );

            if (success) {
              uploadedImageUrl = publicUrl;
            } else {
              throw "Image upload failed";
            }
          }
        }
      }

      final success = await _reflectionServices.createReflection(
        promiseId: widget.promise.id ?? "",
        description: _controller.text.trim(),
        imageUrl: uploadedImageUrl,
        isPrivate: widget.promise.isPrivate ?? false,
      );

      if (success && mounted) {
        final fbEvents = FacebookEventsService();
        fbEvents.logEvent(
          name: 'add_reflection',
          parameters: {'timestamp': DateTime.now().toIso8601String()},
          ref: ref,
          screenName: 'Reflection',
        );
        Navigator.pop(context);
        FlashMessage.showSuccess(
          context,
          "🎉 Great job! Your reflection is saved.",
        );
      }
    } catch (e) {
      log("Error saving reflection: $e");
      if (mounted) {
        FlashMessage.showError(
          context,
          "Failed to save reflection: ${e.toString()}",
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 10.h),
            ListTile(
              leading: const Icon(Icons.photo_camera, color: Colors.black87),
              title: Text(
                'Take Photo',
                style: AppTextStyles.bodyTextStyle.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.black87),
              title: Text(
                'Choose from Gallery',
                style: AppTextStyles.bodyTextStyle.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.close, color: Colors.red),
              title: Text(
                'Cancel',
                style: AppTextStyles.bodyTextStyle.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () => Navigator.of(context).pop(),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 550.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 12.h),
          Center(
            child: Container(
              height: 5.h,
              width: 40.w,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: .3),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
          SizedBox(height: 30.h),
          Text(
            "Write a Reflection",
            textAlign: TextAlign.center,
            style: AppTextStyles.headingTextStyleBogart.copyWith(
              fontSize: 28.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            "Tell us what went right or what went wrong today.\nIt will help Keep.ai, help you even better.",
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyTextStyle.copyWith(
              fontSize: 14.sp,
              height: 1.4,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryBlackColor,
            ),
          ),
          SizedBox(height: 24.h),
          Container(
            height: 180.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: _focusNode.hasFocus
                    ? AppColors.secondaryBlueColor
                    : const Color(0xffE3E3E4),
                width: 1.5,
              ),
            ),
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: "At least 30 characters...",
                      hintStyle: AppTextStyles.bodyTextStyle.copyWith(
                        color: Colors.grey.shade400,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: AppTextStyles.bodyTextStyle,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (_selectedImage != null)
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.file(
                              _selectedImage!,
                              height: 60.h,
                              width: 60.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: -6,
                            right: -6,
                            child: GestureDetector(
                              onTap: _removeImage,
                              child: Container(
                                padding: EdgeInsets.all(2.w),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 14.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    const Spacer(),
                    GestureDetector(
                      onTap: _showImageSourceActionSheet,
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: _selectedImage != null
                              ? AppColors.secondaryBlueColor.withValues(
                                  alpha: 0.1,
                                )
                              : Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: _selectedImage != null
                              ? AppColors.secondaryBlueColor
                              : AppColors.primaryBlackColor,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            " Snap a pic! When you’ve kept enough promises\nwe'll create a really cool look book for you!",
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyTextStyle.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryBlackColor,
            ),
          ),
          const Spacer(),
          Consumer(
            builder: (context, ref, child) => PrimaryButton(
              onPressed: () => _handleSave(ref),
              text: "Save",
              isLoading: _isLoading,
            ),
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}
