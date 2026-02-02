import 'package:sbp_app/features/auth/models/user_model.dart';
import 'package:sbp_app/features/promise/models/broken_promise.dart';
import 'package:sbp_app/features/promise/models/promise_result.dart';

import 'reason_model.dart';
import 'who_model.dart';
import 'feel_model.dart';
import 'obstacles_model.dart';

class PromiseModel {
  final String? id;
  final User? user;
  final String? description;
  final ReasonModel? reasons;
  final String? breakCost;
  final List<WhoModel>? who;
  final List<FeelModel>? feel;
  final List<ReminderResult>? reminders;
  final ObstaclesModel? obstacles;
  final bool? isPrivate;
  final bool? openToJoin;
  final List<dynamic>? joinedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final BrokenPromiseModel? previousBrokenPromises;
  final List<String>? categories;
  final int? keptCount;

  PromiseModel({
    this.id,
    this.user,
    this.description,
    this.reasons,
    this.breakCost,
    this.who,
    this.feel,
    this.reminders,
    this.categories,
    this.obstacles,
    this.isPrivate,
    this.openToJoin,
    this.joinedBy,
    this.createdAt,
    this.updatedAt,
    this.previousBrokenPromises,
    this.keptCount,
  });

  PromiseModel copyWith({
    String? id,
    User? user,
    String? description,
    ReasonModel? reasons,
    String? breakCost,
    List<WhoModel>? who,
    List<FeelModel>? feel,
    List<ReminderResult>? reminders,
    ObstaclesModel? obstacles,
    bool? isPrivate,
    bool? openToJoin,
    List<dynamic>? joinedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    BrokenPromiseModel? previousBrokenPromises,
    List<String>? categories,
    int? keptCount,
  }) {
    return PromiseModel(
      id: id ?? this.id,
      user: user ?? this.user,
      description: description ?? this.description,
      reasons: reasons ?? this.reasons,
      breakCost: breakCost ?? this.breakCost,
      who: who ?? this.who,
      feel: feel ?? this.feel,
      reminders: reminders ?? this.reminders,
      obstacles: obstacles ?? this.obstacles,
      isPrivate: isPrivate ?? this.isPrivate,
      openToJoin: openToJoin ?? this.openToJoin,
      joinedBy: joinedBy ?? this.joinedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      previousBrokenPromises:
          previousBrokenPromises ?? this.previousBrokenPromises,
      categories: categories ?? this.categories,
      keptCount: keptCount ?? this.keptCount,
    );
  }

  factory PromiseModel.fromJson(Map<String, dynamic> json) {
    return PromiseModel(
      id: json['_id'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      description: json['description'],
      reasons: json['reasons'] != null
          ? ReasonModel.fromJson(json['reasons'])
          : null,
      categories: json['categories'] == null
          ? ["Category"]
          : (json['categories'] as List<dynamic>)
                .map((e) => e as String)
                .toList(),
      breakCost: json['breakCost'],
      who: json['who'] != null
          ? (json['who'] as List).map((e) => WhoModel.fromJson(e)).toList()
          : null,
      feel: json['feel'] != null
          ? (json['feel'] as List).map((e) => FeelModel.fromJson(e)).toList()
          : null,
      reminders: json['reminders'] != null
          ? (json['reminders'] as List)
                .map((e) => ReminderResult.fromJson(e))
                .toList()
          : null,
      obstacles: json['obstacles'] != null
          ? ObstaclesModel.fromJson(json['obstacles'])
          : null,
      previousBrokenPromises: json['previousBrokenPromises'] != null
          ? BrokenPromiseModel.fromJson(json['previousBrokenPromises'])
          : null,
      isPrivate: json['isPrivate'],
      openToJoin: json['openToJoin'],
      keptCount: json['keptCount'],
      joinedBy: json['joinedBy'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "user": user?.toJson(),
      "description": description,
      "reasons": reasons?.toJson(),
      "breakCost": breakCost,
      "who": who?.map((e) => e.toJson()).toList(),
      "feel": feel?.map((e) => e.toJson()).toList(),
      "reminders": reminders?.map((e) => e.toJson()).toList(),
      "obstacles": obstacles?.toJson(),
      "previousBrokenPromises": previousBrokenPromises?.toJson(),
      "isPrivate": isPrivate,
      "openToJoin": openToJoin,
      "keptCount": keptCount,
      "joinedBy": joinedBy,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
    };
  }
}
