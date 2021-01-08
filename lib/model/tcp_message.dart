import 'package:json_annotation/json_annotation.dart';

part 'tcp_message.g.dart';

@JsonSerializable()
class TCPMessage {
  final String message;
  final String type;

  TCPMessage({this.message, this.type});

  factory TCPMessage.fromJson(Map<String, dynamic> json) =>
      _$TCPMessageFromJson(json);

  Map<String, dynamic> toJson() => _$TCPMessageToJson(this);
}
