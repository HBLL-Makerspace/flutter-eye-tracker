import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eye_tracker/backend/viewer/viewer_bloc.dart';
import 'package:flutter_eye_tracker/model/session.dart';
import 'package:flutter_eye_tracker/ui/theme.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Viewer extends StatelessWidget {
  final Session session;

  const Viewer({Key key, this.session}) : super(key: key);

  Widget _launchButton(BuildContext context) {
    return Center(
      child: RaisedButton.icon(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 32),
          onPressed: () {
            context.read<ViewerBloc>().add(ViewerEventLaunch(session));
          },
          color: Theming.royal,
          textColor: Colors.white,
          shape: StadiumBorder(),
          icon: Icon(Icons.launch),
          label: Text("Launch")),
    );
  }

  Widget _loading() {
    return Center(
      child: SpinKitDoubleBounce(
        color: Theming.navy,
        size: 50.0,
      ),
    );
  }

  Widget _connected(BuildContext context) {
    return Center(
      child: RaisedButton.icon(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 32),
          onPressed: () {
            context.read<ViewerBloc>().add(ViewerEventClose());
          },
          color: Colors.red[400],
          textColor: Colors.white,
          shape: StadiumBorder(),
          icon: Icon(Icons.stop),
          label: Text("Close Viewer")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewerBloc, ViewerState>(
      builder: (context, state) {
        switch (state.runtimeType) {
          case ViewerStateConnected:
            return _connected(context);
          case ViewerStateLaunching:
            return _loading();
          default:
            return _launchButton(context);
        }
      },
    );
  }
}
