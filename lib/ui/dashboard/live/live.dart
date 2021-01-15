import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eye_tracker/backend/session/session_bloc.dart';
import 'package:flutter_eye_tracker/ui/dashboard/dashboard.dart';
import 'package:flutter_eye_tracker/ui/dashboard/live/controls.dart';
import 'package:flutter_eye_tracker/ui/dashboard/live/live_eye_position.dart';
import 'package:flutter_eye_tracker/ui/dashboard/live/live_gaze_data.dart';
import 'package:flutter_eye_tracker/ui/dashboard/live/live_heatmap.dart';
import 'package:flutter_eye_tracker/ui/dashboard/live/run_timer.dart';
import 'package:flutter_eye_tracker/ui/dashboard/live/viewer.dart';

class LivePage extends StatefulWidget {
  @override
  _LivePageState createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        if (state is SessionStateDone) {
          return DashboardPageViewer(
            page: DashboardPage(title: "Live", icon: Icons.visibility, rows: [
              DashboardRow(entries: [
                DashboardEntry(title: "Controls", child: Controls(), flex: 1),
                DashboardEntry(title: "Run Timer", child: RunTimer(), flex: 1),
                DashboardEntry(title: "Viewer", child: Viewer(), flex: 1)
              ]),
              DashboardRow(size: DashboardSize.Large, entries: [
                DashboardEntry(
                    title: "Live Gaze Data",
                    flex: 2,
                    child: LiveGazeData(
                      session: state.session,
                    )),
                DashboardEntry(
                    title: "Live Heat Map", flex: 2, child: LiveHeatMap()),
              ]),
              DashboardRow(size: DashboardSize.Medium, entries: [
                DashboardEntry(
                    title: "Eye Position Graph", child: LiveEyePosition())
              ])
            ]),
          );
        } else {
          return Center(
            child: Text("No session"),
          );
        }
      },
    );
  }
}

class RunsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Runs Page"));
  }
}

class CalibrationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Calibrations Page"));
  }
}
