class WhoModel {
  final String? option;
  final String? names;

  WhoModel({this.option, this.names});

  WhoModel copyWith({String? option, String? names}) {
    return WhoModel(
      option: option ?? this.option,
      names: names ?? this.names,
    );
  }

  factory WhoModel.fromJson(Map<String, dynamic> json) {
    return WhoModel(
      option: json['option'],
      names: json['names'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "option": option,
      "names": names,
    };
  }
}
