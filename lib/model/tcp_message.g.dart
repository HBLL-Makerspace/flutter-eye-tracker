// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tcp_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TCPMessage _$TCPMessageFromJson(Map<String, dynamic> json) {
  return TCPMessage(
    message: json['message'] as String,
    type: json['type'] as String,
  );
}

Map<String, dynamic> _$TCPMessageToJson(TCPMessage instance) =>
    <String, dynamic>{
      'message': instance.message,
      'type': instance.type,
    };
