import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbp_app/core/services/app_services.dart'; // for locator
import 'package:sbp_app/features/shared/widgets/flushbar.dart';
import 'package:sbp_app/main.dart';

import '../services/invite_service.dart';

class InviteState {
  final bool isLoading;
  final bool? isValid;
  final String? error;

  InviteState({this.isLoading = false, this.isValid, this.error});

  InviteState copyWith({
    bool? isLoading,
    bool? isValid,
    String? error,
    bool clearIsValid = false,
  }) {
    return InviteState(
      isLoading: isLoading ?? this.isLoading,
      isValid: clearIsValid ? null : (isValid ?? this.isValid),
      error: error ?? this.error,
    );
  }
}

class InviteNotifier extends StateNotifier<InviteState> {
  InviteNotifier() : super(InviteState());

  final InviteService _service = locator.get<InviteService>();

  Future<void> verify(String code) async {
    state = state.copyWith(isLoading: true, isValid: null);

    try {
      final result = await _service.verifyInvite(inviteCode: code);

      if (result?.valid ?? false) {
        state = state.copyWith(isValid: true, isLoading: false);
      } else {
        state = state.copyWith(isValid: false, isLoading: false);
      }
    } catch (e) {
      if (e.toString().toLowerCase().contains("invalid")) {
        state = state.copyWith(
          isLoading: false,
          isValid: false,
          error: e.toString(),
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          clearIsValid: true,
          error: e.toString(),
        );
        FlashMessage.showError(navigatorKey.currentContext!, e.toString());
      }
    }
  }
}

final inviteProvider = StateNotifierProvider<InviteNotifier, InviteState>((
  ref,
) {
  return InviteNotifier();
});

//
final inviteLoadingProvider = NotifierProvider<InviteLoadingNotifier, bool>(
  InviteLoadingNotifier.new,
);

class InviteLoadingNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setLoading(bool value) {
    state = value;
  }
}
