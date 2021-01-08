part of 'tcpserver_bloc.dart';

@immutable
abstract class TCPServerEvent {}

class TCPServerEventStart extends TCPServerEvent {}

class TCPServerEventClientConnected extends TCPServerEvent {}

class TCPServerEventReceivedMessage extends TCPServerEvent {}

class TCPServerEventSendMessage extends TCPServerEvent {
  final JsonMessage message;

  TCPServerEventSendMessage(this.message);
}

class TCPServerEventStop extends TCPServerEvent {}
