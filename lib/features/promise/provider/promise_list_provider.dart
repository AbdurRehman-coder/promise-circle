import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbp_app/core/services/app_services.dart';
import 'package:sbp_app/features/promise/models/promise_model.dart';
import 'package:sbp_app/features/promise/services/promise_services.dart';

class PromisesListState {
  final bool isLoading;
  final String? error;
  final List<PromiseModel> promises;

  const PromisesListState({
    this.isLoading = false,
    this.error,
    this.promises = const [],
  });
  bool get hasPromises => promises.isNotEmpty;
  int get promisesCount => promises.length;
  int get promiseCategoriesCount {
    return promises
        .expand((promise) => promise.categories ?? <String>[])
        .toSet()
        .length;
  }

  PromisesListState copyWith({
    bool? isLoading,
    String? error,
    List<PromiseModel>? promises,
  }) {
    return PromisesListState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      promises: promises ?? this.promises,
    );
  }
}

class PromisesNotifier extends Notifier<PromisesListState> {
  PromiseServices? _services;

  @override
  PromisesListState build() {
    _services = locator.get<PromiseServices>();
    Future.microtask(() => fetchPromises());
    return const PromisesListState(isLoading: true);
  }

  Future<void> fetchPromises() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _services!.getAllPromises();
      if (response != null && response.data != null) {
        // if (state.hasPromises) {
        //   ref.read(promiseStepIndexProvider.notifier).state = 2;
        // }
        state = state.copyWith(
          isLoading: false,
          promises: response.data!.reversed.toList(),
        );
      } else {
        state = state.copyWith(isLoading: false, error: "No data found");
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final promisesProvider = NotifierProvider<PromisesNotifier, PromisesListState>(
  PromisesNotifier.new,
);
