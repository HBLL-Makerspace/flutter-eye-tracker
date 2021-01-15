// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../dashboard/live/live.dart';

class Routes {
  static const String livePage = '/';
  static const String runsPage = '/runs';
  static const String calibrationPage = '/calibration';
  static const all = <String>{
    livePage,
    runsPage,
    calibrationPage,
  };
}

class DashboardRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.livePage, page: LivePage),
    RouteDef(Routes.runsPage, page: RunsPage),
    RouteDef(Routes.calibrationPage, page: CalibrationPage),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    LivePage: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => LivePage(),
        settings: data,
      );
    },
    RunsPage: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => RunsPage(),
        settings: data,
      );
    },
    CalibrationPage: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => CalibrationPage(),
        settings: data,
      );
    },
  };
}
