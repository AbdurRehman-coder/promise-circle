// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sbp_app/core/services/app_services.dart';
// import 'package:sbp_app/features/promise/models/promises_response.dart';
// import 'package:sbp_app/features/promise/services/promise_services.dart';

// import '../models/promise_model.dart';

// class PromisesState {
//   final bool isLoading;
//   final String? error;
//   final List<PromiseModel> promises;
//   final PromiseModel? selectedPromise;

//   PromisesState({
//     this.isLoading = false,
//     this.error,
//     this.promises = const [],
//     this.selectedPromise,
//   });

//   PromisesState copyWith({
//     bool? isLoading,
//     String? error,
//     List<PromiseModel>? promises,
//     PromiseModel? selectedPromise,
//   }) {
//     return PromisesState(
//       isLoading: isLoading ?? this.isLoading,
//       error: error ?? this.error,
//       promises: promises ?? this.promises,
//       selectedPromise: selectedPromise,
//     );
//   }
// }

// class PromisesProvider extends StateNotifier<PromisesState> {
//   final PromiseServices promiseServices = locator.get<PromiseServices>();

//   PromisesProvider() : super(PromisesState());

//   Future<void> getPromises() async {
//     try {
//       state = state.copyWith(isLoading: true);
//       PromisesResponse? response = await promiseServices.getAllPromises();
      
//       if (response != null) {
//         state = state.copyWith(isLoading: false, promises: response.data!.reversed.toList());
//       } else {
//         state = state.copyWith(isLoading: false, error: 'Something went wrong');
//       }
//     } catch (e) {
//       state = state.copyWith(isLoading: false, error: e.toString());
//     }
//   }

//   void selectPromise(PromiseModel? promise) {
//     state = state.copyWith(selectedPromise: promise);
//   }
// }

// final promisesProvider = StateNotifierProvider<PromisesProvider, PromisesState>(
//   (ref) {
//     return PromisesProvider();
//   },
// );
