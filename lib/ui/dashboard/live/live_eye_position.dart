import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_eye_tracker/backend/tcp_server.dart';
import 'package:flutter_eye_tracker/model/json_message.dart';

class LiveEyePosition extends StatefulWidget {
  @override
  _LiveEyePositionState createState() => _LiveEyePositionState();
}

class _LiveEyePositionState extends State<LiveEyePosition> {
  final List<charts.Series<GazeDataSeries, int>> seriesList = [];
  final List<GazeDataSeries> data = [];

  @override
  void initState() {
    super.initState();
    TCPServer.on<GazeData>().listen((event) {
      setState(() {
        data.add(GazeDataSeries(event.x, event.y, data.length));
      });
    });
  }

  List<charts.Series<GazeDataSeries, int>> series() {
    return [
      charts.Series<GazeDataSeries, int>(
        id: 'Horizontal position',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (GazeDataSeries eyePos, _) => eyePos.index,
        measureFn: (GazeDataSeries eyePos, _) => eyePos.x,
        data: data,
      ),
      charts.Series<GazeDataSeries, int>(
        id: 'Vertical position',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (GazeDataSeries eyePos, _) => eyePos.index,
        measureFn: (GazeDataSeries eyePos, _) => eyePos.y,
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return charts.LineChart(
      series(),
      animate: true,
      behaviors: [new charts.SeriesLegend()],
    );
  }
}

class GazeDataSeries {
  final double x;
  final double y;
  final int index;

  GazeDataSeries(this.x, this.y, this.index);
}
