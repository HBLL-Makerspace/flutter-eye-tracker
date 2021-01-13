import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_eye_tracker/backend/tcp_server.dart';
import 'package:flutter_eye_tracker/model/json_message.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LiveEyePosition extends StatefulWidget {
  @override
  _LiveEyePositionState createState() => _LiveEyePositionState();
}

class _LiveEyePositionState extends State<LiveEyePosition> {
  final List<GazeDataSeries> _data = [];
  StreamSubscription<GazeData> _dataStream;

  @override
  void initState() {
    super.initState();
    if (_dataStream == null)
      _dataStream = TCPServer.on<GazeData>().listen((event) {
        setState(() {
          _data.add(GazeDataSeries(event.x, event.y, _data.length + 1));
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    if (_dataStream != null) {
      _dataStream.cancel();
      _dataStream = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      legend: Legend(isVisible: true, position: LegendPosition.top),
      // zoomPanBehavior: ZoomPanBehavior(enablePinching: true),
      series: <ChartSeries<GazeDataSeries, int>>[
        FastLineSeries<GazeDataSeries, int>(
          dataSource: _data,
          xValueMapper: (GazeDataSeries gaze, _) => gaze.index,
          yValueMapper: (GazeDataSeries gaze, _) => gaze.x,
          name: 'X position',
        ),
        FastLineSeries<GazeDataSeries, int>(
          dataSource: _data,
          xValueMapper: (GazeDataSeries gaze, _) => gaze.index,
          yValueMapper: (GazeDataSeries gaze, _) => gaze.y,
          name: 'Y position',
        )
      ],
    );
  }
}

class GazeDataSeries {
  final double x;
  final double y;
  final int index;

  GazeDataSeries(this.x, this.y, this.index);
}
