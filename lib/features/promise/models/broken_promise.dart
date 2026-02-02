class BrokenPromiseModel {
  final String? reason1;
  final String? reason2;
  final String? reason3;

  BrokenPromiseModel({this.reason1, this.reason2, this.reason3});

  BrokenPromiseModel copyWith({String? reason1, String? reason2, String? reason3}) {
    return  BrokenPromiseModel(
      reason1: reason1 ?? this.reason1,
      reason2: reason2 ?? this.reason2,
      reason3: reason3 ?? this.reason3,
    );
  }

  factory BrokenPromiseModel.fromJson(Map<String, dynamic> json) {
    return  BrokenPromiseModel(
      reason1: json['promise1'],
      reason2: json['promise2'],
      reason3: json['promise3'],
    );
  }

  Map<String, dynamic> toJson() {
    return {"promise1": reason1, "promise2": reason2, "promise3": reason3};
  }
}
