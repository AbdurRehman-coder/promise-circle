class FeelModel {
  final String? option;
  final String? customValue;

  FeelModel({this.option, this.customValue});

  FeelModel copyWith({String? option, String? customValue}) {
    return FeelModel(
      option: option ?? this.option,
      customValue: customValue ?? this.customValue,
    );
  }

  factory FeelModel.fromJson(Map<String, dynamic> json) {
    return FeelModel(
      option: json['option'],
      customValue: json['customValue'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "option": option,
      "customValue": customValue,
    };
  }
}
