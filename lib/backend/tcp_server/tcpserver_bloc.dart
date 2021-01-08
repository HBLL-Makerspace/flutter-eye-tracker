import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:unity_eye_tracker/backend/tcp_server.dart';
import 'package:unity_eye_tracker/model/json_message.dart';

part 'tcpserver_event.dart';
part 'tcpserver_state.dart';

class TCPServerBloc extends Bloc<TCPServerEvent, TCPServerState> {
  TCPServerBloc() : super(TCPServerInitial());

  @override
  Stream<TCPServerState> mapEventToState(
    TCPServerEvent event,
  ) async* {
    switch (event.runtimeType) {
      case TCPServerEventStart:
        TCPServer.start();
        break;
      case TCPServerEventSendMessage:
        final eventTyped = event as TCPServerEventSendMessage;
        TCPServer.sendMessage(eventTyped.message);
        break;
    }
  }
}
