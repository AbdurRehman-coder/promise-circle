import 'promise_model.dart';

class PromisesResponse {
  final String? message;
  final List<PromiseModel>? data;

  PromisesResponse({this.message, this.data});

  factory PromisesResponse.fromJson(Map<String, dynamic> json) {
    return PromisesResponse(
      message: json["message"],
      data: json["data"] != null
          ? (json["data"].cast<Map<String, dynamic>>())
                .map((e) => PromiseModel.fromJson(e))
                .cast<PromiseModel>()
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    if (message != null) "message": message,
    if (data != null) "data": data!.map((e) => e.toJson()).toList(),
  };

  PromisesResponse copyWith({String? message, List<PromiseModel>? data}) {
    return PromisesResponse(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}
