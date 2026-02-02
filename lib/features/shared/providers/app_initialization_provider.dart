import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbp_app/features/auth/provider/authentication_providr.dart';

final appInitializationProvider = FutureProvider<void>((ref) async {
  final authState = ref.watch(authenticationProvider);

  if (authState.initialLoading) {
    return;
  }

  if (authState.isAuthenticated) {
    // Future.microtask(() => 
    //   ref.read(promisesProvider.notifier).fetchPromises()
    // );
  }
});