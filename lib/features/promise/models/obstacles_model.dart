class ObstaclesModel {
  final String? obstacle1;
  final String? obstacle2;
  final String? obstacle3;
  final String? resetStrategy;

  ObstaclesModel({
    this.obstacle1,
    this.obstacle2,
    this.obstacle3,
    this.resetStrategy,
  });

  ObstaclesModel copyWith({
    String? obstacle1,
    String? obstacle2,
    String? obstacle3,
    String? resetStrategy,
  }) {
    return ObstaclesModel(
      obstacle1: obstacle1 ?? this.obstacle1,
      obstacle2: obstacle2 ?? this.obstacle2,
      obstacle3: obstacle3 ?? this.obstacle3,
      resetStrategy: resetStrategy ?? this.resetStrategy,
    );
  }

  factory ObstaclesModel.fromJson(Map<String, dynamic> json) {
    return ObstaclesModel(
      obstacle1: json['obstacle1'],
      obstacle2: json['obstacle2'],
      obstacle3: json['obstacle3'],
      resetStrategy: json['resetStrategy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "obstacle1": obstacle1,
      "obstacle2": obstacle2,
      "obstacle3": obstacle3,
      "resetStrategy": resetStrategy,
    };
  }
}
