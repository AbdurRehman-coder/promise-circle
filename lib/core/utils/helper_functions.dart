import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sbp_app/features/auth/provider/authentication_providr.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sbp_app/core/constants/assets.dart';
import 'package:sbp_app/core/constants/promise_profile_data.dart';
import 'package:sbp_app/features/shared/widgets/promise_profile_share_card.dart';
import '../../features/promise/presentation/widgets/w_share_promise_card.dart';
import '../services/facebook_events_service.dart';

class HelperFunctions {
  static Future<void> launchMyUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  static String resolveText(String? value, String fallback) {
    if (value == null || value.trim().isEmpty) {
      return fallback;
    }
    return value;
  }

  static Future<void> sharePromiseProfile(
    BuildContext context, {
    required String label,
    required String key,
    required String screenName,
    required WidgetRef ref,
  }) async {
    final appSetting = ref.read(authenticationProvider).appSetting?.data;
    final String profileShareText =
        (appSetting?.profileShareText.trim().isNotEmpty ?? false)
        ? appSetting!.profileShareText
        : "You're three kept Promises away from the life you want. "
              "Download Stop Breaking Promises app to Make and Keep One Promise for 2026 on us — for free. "
              "onelink.to/promisesapp";

    final Map<String, dynamic> profileShareDescription =
        (appSetting?.profileShareDescription != null &&
            appSetting!.profileShareDescription.isNotEmpty)
        ? appSetting.profileShareDescription
        : profileDescriptions;

    final String profileShareSubjectText =
        (appSetting?.profileShareSubjectText.trim().isNotEmpty ?? false)
        ? appSetting!.profileShareSubjectText
        : "Check out the StopBreakingPromises App!";

    final ScreenshotController screenshotController = ScreenshotController();

    final assetMap = promiseProfileAvatarMap;
    final String imageAsset = assetMap[label] ?? Assets.svgAppNameIcon;

    String commonSuffix = profileShareText;
    String textToShare;

    if (profileShareDescription.containsKey(label)) {
      textToShare = "${profileShareDescription[label]}\n$commonSuffix";
    } else {
      textToShare = commonSuffix;
    }
    textToShare = textToShare.trim();

    try {
      final Uint8List imageBytes = await screenshotController.captureFromWidget(
        PromiseProfileShareCard(
          profileName: label,
          profileKey: key.replaceAll("-", " • "),
          imagePath: imageAsset,
        ),
        delay: const Duration(milliseconds: 150),

        pixelRatio: 1.0,
        context: context,
        targetSize: const Size(1080, 1920),
      );

      final Directory tempDir = await getTemporaryDirectory();
      final String tempPath = '${tempDir.path}/promise_profile_share.png';
      final File file = File(tempPath);
      await file.writeAsBytes(imageBytes);

      await Share.shareXFiles(
        [XFile(tempPath)],
        text: textToShare,
        subject: profileShareSubjectText,
      ).then((val) {
        if (val.status == ShareResultStatus.success) {
          final fbEvents = FacebookEventsService();
          fbEvents.logEvent(
            name: 'promise_profile_share',
            parameters: {'timestamp': DateTime.now().toIso8601String()},
            ref: ref,
            screenName: screenName,
          );
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error generating or sharing image: $e');
      }
    }
  }

  static Future<void> sharePromise(
    BuildContext context, {
    required dynamic result,
    required String name,
    required String screenName,
    required WidgetRef ref,
  }) async {
    final ScreenshotController screenshotController = ScreenshotController();
    final appSetting = ref.read(authenticationProvider).appSetting?.data;
    final String profileShareText =
        (appSetting?.promiseShareText.trim().isNotEmpty ?? false)
        ? appSetting!.promiseShareText
        : "\nYou're three kept Promises away from the life you want. "
              "Download Stop Breaking Promises app to Make and Keep One Promise for 2026 on us — for free. "
              "onelink.to/promisesapp";
    final String profileShareSubjectText =
        (appSetting?.promiseShareSubjectText.trim().isNotEmpty ?? false)
        ? appSetting!.promiseShareSubjectText
        : "Check out the StopBreakingPromises App!";
    final String shareText = profileShareText.trim();

    try {
      final Uint8List imageBytes = await screenshotController.captureFromWidget(
        PromiseShareCard(result: result, name: name),
        delay: const Duration(milliseconds: 150),

        pixelRatio: 1.0,
        context: context,
        targetSize: const Size(1080, 1920),
      );

      final Directory tempDir = await getTemporaryDirectory();
      final String tempPath = '${tempDir.path}/promise_share.png';
      final File file = File(tempPath);
      await file.writeAsBytes(imageBytes);

      await Share.shareXFiles(
        [XFile(tempPath)],
        text: shareText,
        subject: profileShareSubjectText,
      ).then((val) {
        if (val.status == ShareResultStatus.success) {
          final fbEvents = FacebookEventsService();
          fbEvents.logEvent(
            name: 'promise_share',
            parameters: {'timestamp': DateTime.now().toIso8601String()},
            ref: ref,
            screenName: screenName,
          );
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error generating or sharing promise image: $e');
      }
    }
  }
}
