import 'dart:ui';
import 'package:sbp_app/core/theming/app_colors.dart';
import '../../../../core/constants/assets.dart';

class ChallengeUtils {
  static Color getDayColor(int day) {
    switch (day) {
      case 1:
        return const Color(0xFFFFF4AE).withValues(alpha: 0.8);
      case 2:
        return const Color(0xFFA5DABA).withValues(alpha: 0.35);
      case 3:
        return const Color(0xFFE47239).withValues(alpha: 0.35);
      case 4:
        return const Color(0xFF3986E4).withValues(alpha: 0.2);
      case 5:
        return const Color(0xFF3939E4).withValues(alpha: 0.3);
      case 6:
        return const Color(0xFFE3C978).withValues(alpha: 0.3);
      case 7:
        return const Color(0xFFB999FF).withValues(alpha: 0.35);
      default:
        return AppColors.whiteColor;
    }
  }

  static String getDayIllustration(int day) {
    switch (day) {
      case 1:
        return Assets.challengeDay1;
      case 2:
        return Assets.challengeDay2;
      case 3:
        return Assets.challengeDay3;
      case 4:
        return Assets.challengeDay4;
      case 5:
        return Assets.challengeDay5;
      case 6:
        return Assets.challengeDay6;
      case 7:
        return Assets.challengeDay7;
      default:
        return Assets.challengeDay1;
    }
  }

  static String getDayKey(int day) {
    switch (day) {
      case 1:
        return "dayOne";
      case 2:
        return "dayTwo";
      case 3:
        return "dayThree";
      case 4:
        return "dayFour";
      case 5:
        return "dayFive";
      case 6:
        return "daySix";
      case 7:
        return "daySeven";
      default:
        return "dayOne";
    }
  }

  static Color getBorderColorForDay(int dayIndex) {
    switch (dayIndex) {
      case 1:
        return const Color(0xFF9A891B);
      case 2:
        return const Color(0xFF06A06F);
      case 3:
        return const Color(0xFF924F3A);
      case 4:
        return const Color(0xFF5B57AA);
      case 5:
        return const Color(0xFF8E44AD);
      default:
        return AppColors.primaryBlackColor;
    }
  }
}