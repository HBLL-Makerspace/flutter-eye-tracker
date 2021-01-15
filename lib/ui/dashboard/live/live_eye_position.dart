import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eye_tracker/backend/run_manager/run_manager_bloc.dart';
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
  ChartSeriesController _chartSeriesControllerX;
  ChartSeriesController _chartSeriesControllerY;

  @override
  void initState() {
    super.initState();
    if (_dataStream == null)
      _dataStream = TCPServer.on<GazeData>().listen((event) {
        if (context.read<RunManagerBloc>().state is RunManagerRunning) {
          _data.add(GazeDataSeries(event.x, event.y, _data.length + 1));
          if (_chartSeriesControllerX != null &&
              _chartSeriesControllerY != null) {
            _chartSeriesControllerX.updateDataSource(
              addedDataIndexes: <int>[_data.length - 1],
            );
            _chartSeriesControllerY.updateDataSource(
              addedDataIndexes: <int>[_data.length - 1],
            );
          }
        }
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
    return BlocListener<RunManagerBloc, RunManagerState>(
      listener: (context, state) {
        print("new state");
        setState(() {});
      },
      child: _data.isEmpty
          ? Center(
              child: Text("No Data"),
            )
          : SfCartesianChart(
              legend: Legend(isVisible: true, position: LegendPosition.top),
              primaryYAxis: NumericAxis(minimum: 0, maximum: 1),
              // zoomPanBehavior: ZoomPanBehavior(enablePinching: true),
              series: <ChartSeries<GazeDataSeries, int>>[
                FastLineSeries<GazeDataSeries, int>(
                  onRendererCreated: (controller) =>
                      {_chartSeriesControllerX = controller},
                  dataSource: _data,
                  xValueMapper: (GazeDataSeries gaze, _) => gaze.index,
                  yValueMapper: (GazeDataSeries gaze, _) => gaze.x,
                  name: 'X position',
                ),
                FastLineSeries<GazeDataSeries, int>(
                  onRendererCreated: (controller) =>
                      {_chartSeriesControllerY = controller},
                  dataSource: _data,
                  xValueMapper: (GazeDataSeries gaze, _) => gaze.index,
                  yValueMapper: (GazeDataSeries gaze, _) => gaze.y,
                  name: 'Y position',
                )
              ],
            ),
    );
  }
}

class GazeDataSeries {
  final double x;
  final double y;
  final int index;

  GazeDataSeries(this.x, this.y, this.index);
}
