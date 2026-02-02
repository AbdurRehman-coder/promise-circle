import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbp_app/main.dart';
import '../../../core/services/app_services.dart';
import '../../../core/services/notification_service.dart';
import '../../shared/widgets/flushbar.dart';
import '../data/challenge_data.dart';
import '../models/seven_day_challenge_model.dart';
import '../services/challenge_services.dart';

/// Extension to provide easy access to challenge status directly from the provider state
extension ChallengeStateX on AsyncValue<SevenDayChallenge?> {
  bool get isChallengeCreated => value != null;
  bool get isChallengeCompleted => value?.isCompleted ?? false;
  int get currentDay => value?.currentDayIndex ?? 1;
  bool get isUpdatedToday {
    final dt = value?.updatedFromUser;
    if (dt == null) return false;

    final now = DateTime.now();

    if (dt.isAfter(now)) return true;

    return dt.year == now.year && dt.month == now.month && dt.day == now.day;
  }
}

final challengeProvider =
    StateNotifierProvider<ChallengeNotifier, AsyncValue<SevenDayChallenge?>>((
      ref,
    ) {
      return ChallengeNotifier(ref);
    });

class ChallengeNotifier extends StateNotifier<AsyncValue<SevenDayChallenge?>> {
  final Ref ref;
  final ChallengeServices challengeServices = locator.get<ChallengeServices>();

  ChallengeNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<SevenDayChallenge?> loadChallenge() async {
    try {
      final challenge = await challengeServices.getChallenge();
      if (mounted) {
        state = AsyncValue.data(challenge);
      }
      return challenge;
    } catch (e) {
      if (e.toString().contains("Challenge not started")) {
        if (mounted) state = const AsyncValue.data(null);
      } else {
        if (mounted) state = AsyncValue.error(e, StackTrace.current);
      }
    }
    return null;
  }

  Future<void> startChallenge() async {
    state = const AsyncValue.loading();
    try {
      final challenge = await challengeServices.createChallenge();

      updateNotifications(challenge);

      if (mounted) {
        state = AsyncValue.data(challenge);
      }
    } catch (e) {
      FlashMessage.showError(navigatorKey.currentContext!, e.toString());
      if (mounted) state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // Future<void> completeCurrentDay() async {
  //   final currentData = state.value;
  //   if (currentData == null) return;

  //   final dayIndex = currentData.currentDayIndex;
  //   if (dayIndex > 7) return;

  //   final keys = [
  //     'dayOne',
  //     'dayTwo',
  //     'dayThree',
  //     'dayFour',
  //     'dayFive',
  //     'daySix',
  //     'daySeven',
  //   ];
  //   final keyToUpdate = keys[dayIndex - 1];

  //   try {
  //     final updatedChallenge = await challengeServices.updateDay(keyToUpdate);

  //     if (mounted) {
  //       state = AsyncValue.data(updatedChallenge);
  //     }

  //     updateNotifications(updatedChallenge);
  //   } catch (e) {
  //     _showErrorToast("Failed to update progress: ${e.toString()}");
  //     if (mounted) state = AsyncValue.error(e, StackTrace.current);
  //   }
  // }

  Future<void> updateNotifications(SevenDayChallenge? challenge) async {
    try {
      if (challenge == null) return;

      final nextDay = challenge.currentDayIndex;

      if (nextDay > 7) {
        await NotificationService().cancelSevenDayNotifications();
        return;
      }

      final content = challengeContentMap[nextDay];
      if (content != null) {
        NotificationService().scheduleDayContentWithFutureNudges(
          dayIndex: nextDay,
          morningBody: content.notifMorning,
          afternoonBody: content.notifAfternoon,
          eveningBody: content.notifEvening,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Notification Scheduling Error: $e");
      }
    }
  }
}
