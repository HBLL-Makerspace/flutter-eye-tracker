import 'package:flutter_eye_tracker/model/json_message.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'run.g.dart';

class RunBuilder {
  String name;
  String uid;
  DateTime startDate = DateTime.now();
  DateTime endDate;
  List<GazeData> _gazeData = [];

  void start() {
    startDate = DateTime.now();
  }

  void stop() {
    endDate = DateTime.now();
  }

  void addGazeData(GazeData gazeData) {
    _gazeData.add(gazeData);
  }

  void clearGazeData() {
    _gazeData.clear();
  }

  Run createRun() {
    return Run(
        name: name,
        uid: uid ?? Uuid().v4,
        startDate: startDate,
        endDate: endDate ?? DateTime.now(),
        gazeData: _gazeData);
  }
}

@JsonSerializable()
class Run {
  final String name;
  final String uid;
  final DateTime startDate;
  final DateTime endDate;
  final List<GazeData> gazeData;

  Run({this.name, this.uid, this.startDate, this.endDate, this.gazeData});

  factory Run.fromJson(Map<String, dynamic> json) => _$RunFromJson(json);

  Map<String, dynamic> toJson() => _$RunToJson(this);
}
