import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eye_tracker/backend/gaze_stream/gaze_stream_bloc.dart';
import 'package:flutter_eye_tracker/backend/session/session_bloc.dart';
import 'package:flutter_eye_tracker/backend/tcp_server.dart';
import 'package:flutter_eye_tracker/backend/tcp_server/tcpserver_bloc.dart';
import 'package:flutter_eye_tracker/model/json_message.dart';
import 'package:flutter_eye_tracker/model/session.dart';

class BlocProviders extends StatelessWidget {
  final Widget child;

  const BlocProviders({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GazeStreamBloc _gazeStreamBloc = GazeStreamBloc();
    TCPServer.on<GazeData>().listen((event) {
      _gazeStreamBloc.add(GazeStreamEventData(event));
    });
    TCPServerBloc _serverBloc = TCPServerBloc();
    _serverBloc.add(TCPServerEventStart());
    SessionBloc sessionBloc = SessionBloc();
    return BlocProvider(
      create: (context) => sessionBloc,
      child: BlocProvider(
        create: (context) => _serverBloc,
        child: BlocProvider(
          create: (context) => _gazeStreamBloc,
          child: child,
        ),
      ),
    );
  }
}
