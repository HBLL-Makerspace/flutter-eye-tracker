// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'run.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Run _$RunFromJson(Map<String, dynamic> json) {
  return Run(
    name: json['name'] as String,
    uid: json['uid'] as String,
    startDate: json['startDate'] == null
        ? null
        : DateTime.parse(json['startDate'] as String),
    endDate: json['endDate'] == null
        ? null
        : DateTime.parse(json['endDate'] as String),
    gazeData: (json['gazeData'] as List)
        ?.map((e) =>
            e == null ? null : GazeData.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$RunToJson(Run instance) => <String, dynamic>{
      'name': instance.name,
      'uid': instance.uid,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'gazeData': instance.gazeData,
    };
