import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eye_tracker/backend/gaze_stream/gaze_stream_bloc.dart';
import 'package:flutter_eye_tracker/backend/run_timer/run_timer_bloc.dart';
import 'package:flutter_eye_tracker/backend/session/session_bloc.dart';
import 'package:flutter_eye_tracker/backend/tcp_server.dart';
import 'package:flutter_eye_tracker/backend/tcp_server/tcpserver_bloc.dart';
import 'package:flutter_eye_tracker/backend/viewer/viewer_bloc.dart';
import 'package:flutter_eye_tracker/model/json_message.dart';

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

    return MultiBlocProvider(providers: [
      BlocProvider<SessionBloc>(
        create: (context) => sessionBloc,
      ),
      BlocProvider<TCPServerBloc>(
        create: (context) => _serverBloc,
      ),
      BlocProvider<GazeStreamBloc>(
        create: (context) => _gazeStreamBloc,
      ),
      BlocProvider<ViewerBloc>(
        create: (context) => ViewerBloc(),
      ),
      BlocProvider<RunTimerBloc>(
        create: (context) => RunTimerBloc(),
      ),
    ], child: child);
  }
}
