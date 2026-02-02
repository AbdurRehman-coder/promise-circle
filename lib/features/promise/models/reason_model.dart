class ReasonModel {
  final String? reason1;
  final String? reason2;
  final String? reason3;

  ReasonModel({this.reason1, this.reason2, this.reason3});

  ReasonModel copyWith({String? reason1, String? reason2, String? reason3}) {
    return ReasonModel(
      reason1: reason1 ?? this.reason1,
      reason2: reason2 ?? this.reason2,
      reason3: reason3 ?? this.reason3,
    );
  }

  factory ReasonModel.fromJson(Map<String, dynamic> json) {
    return ReasonModel(
      reason1: json['reason1'],
      reason2: json['reason2'],
      reason3: json['reason3'],
    );
  }

  Map<String, dynamic> toJson() {
    return {"reason1": reason1, "reason2": reason2, "reason3": reason3};
  }
}
