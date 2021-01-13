import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter_eye_tracker/backend/tcp_server.dart';
import 'package:flutter_eye_tracker/model/json_message.dart';
import 'package:flutter_eye_tracker/model/session.dart';
import 'package:meta/meta.dart';

part 'viewer_event.dart';
part 'viewer_state.dart';

class ViewerBloc extends Bloc<ViewerEvent, ViewerState> {
  ViewerBloc() : super(ViewerInitial());
  Stream _clientConnected;
  Process _unityEyeApp;
  Session _session;

  @override
  Stream<ViewerState> mapEventToState(
    ViewerEvent event,
  ) async* {
    switch (event.runtimeType) {
      case ViewerEventLaunch:
        yield ViewerStateLaunching();
        this._session = (event as ViewerEventLaunch).session;
        _clientConnected = TCPServer.on<ClientConnected>();
        if (_clientConnected != null)
          _clientConnected.listen((event) {
            add(ViewerEventConnected());
          }, onDone: () => {_clientConnected = null});
        Directory appDocDir = Directory.current;
        _unityEyeApp = await Process.start(
            appDocDir.path + "/unity_eye/Unity Eye.exe", []);
        await _unityEyeApp.exitCode;
        yield ViewerStateClosed();
        break;
      case ViewerEventConnected:
        if (_session != null)
          TCPServer.sendMessage(SetPicture(filepath: _session.picture.path));
        yield ViewerStateConnected();
        break;
      case ViewerEventClose:
        if (_unityEyeApp != null) {
          _unityEyeApp.kill();
          _unityEyeApp = null;
        }
        yield ViewerStateClosed();
        break;
    }
  }
}
