import 'package:auto_route/auto_route_annotations.dart';
import 'package:flutter_eye_tracker/ui/dashboard/live/live.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    MaterialRoute(page: LivePage, initial: true),
    MaterialRoute(page: RunsPage, path: "/runs"),
    MaterialRoute(page: CalibrationPage, path: "/calibration"),
  ],
)
class $DashboardRouter {}
