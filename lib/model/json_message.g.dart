// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SetPicture _$SetPictureFromJson(Map<String, dynamic> json) {
  return SetPicture(
    filepath: json['filepath'] as String,
  );
}

Map<String, dynamic> _$SetPictureToJson(SetPicture instance) =>
    <String, dynamic>{
      'filepath': instance.filepath,
    };

ShowPoint _$ShowPointFromJson(Map<String, dynamic> json) {
  return ShowPoint(
    json['showPoint'] as bool,
  );
}

Map<String, dynamic> _$ShowPointToJson(ShowPoint instance) => <String, dynamic>{
      'showPoint': instance.showPoint,
    };

GenerateHeatMap _$GenerateHeatMapFromJson(Map<String, dynamic> json) {
  return GenerateHeatMap();
}

Map<String, dynamic> _$GenerateHeatMapToJson(GenerateHeatMap instance) =>
    <String, dynamic>{};

SkyBoxUpdate _$SkyBoxUpdateFromJson(Map<String, dynamic> json) {
  return SkyBoxUpdate(
    filepath: json['filepath'] as String,
  );
}

Map<String, dynamic> _$SkyBoxUpdateToJson(SkyBoxUpdate instance) =>
    <String, dynamic>{
      'filepath': instance.filepath,
    };

GazeData _$GazeDataFromJson(Map<String, dynamic> json) {
  return GazeData(
    x: (json['x'] as num)?.toDouble(),
    y: (json['y'] as num)?.toDouble(),
    timestamp: json['timestamp'] as int,
  );
}

Map<String, dynamic> _$GazeDataToJson(GazeData instance) => <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'timestamp': instance.timestamp,
    };

ClientConnected _$ClientConnectedFromJson(Map<String, dynamic> json) {
  return ClientConnected(
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$ClientConnectedToJson(ClientConnected instance) =>
    <String, dynamic>{
      'name': instance.name,
    };

ScreenUpdate _$ScreenUpdateFromJson(Map<String, dynamic> json) {
  return ScreenUpdate(
    fulscreen: json['fulscreen'] as bool,
  );
}

Map<String, dynamic> _$ScreenUpdateToJson(ScreenUpdate instance) =>
    <String, dynamic>{
      'fulscreen': instance.fulscreen,
    };

PictureOffset _$PictureOffsetFromJson(Map<String, dynamic> json) {
  return PictureOffset(
    (json['x'] as num)?.toDouble(),
    (json['y'] as num)?.toDouble(),
    (json['z'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$PictureOffsetToJson(PictureOffset instance) =>
    <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'z': instance.z,
    };
