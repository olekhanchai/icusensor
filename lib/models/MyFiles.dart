import 'package:fl_chart/fl_chart.dart';
import 'package:icusensor/constants.dart';
import 'package:flutter/material.dart';

class SensorData {
  SensorData(this.time, this.data);
  final double time;
  final double data;
}

class SensorStateChanged {
  SensorStateChanged(this.id, this.state, this.dir);
  final int id;
  final int state;
  final int dir;
}

class CloudSensorInfo {
  CloudSensorInfo({
    required this.displayOnly,
    required this.state,
    required this.value,
    required this.valuemin,
    required this.valuemax,
    required this.target,
    required this.targetmin,
    required this.targetmax,
    required this.timer,
    required this.limitdir,
    required this.digit,
    required this.elaps,
    required this.ison,
    required this.gain,
    required this.offset,
    required this.hysteresis,
    required this.inv,
    this.svgSrc,
    this.title,
    this.unit,
    this.color,
    this.data,
  });
  bool displayOnly;
  double value;
  int state, target, timer, limitdir;
  int elaps;
  bool ison;
  double gain;
  double offset;
  double hysteresis;
  bool inv;
  final int valuemin, valuemax, targetmin, targetmax;
  final int digit;
  final String? svgSrc, title, unit;
  final Color? color;
  List<FlSpot>? data;
}

class SensorExtChanged {
  SensorExtChanged(this.temperature, this.humidity, this.bettery);
  final double temperature;
  final double humidity;
  final double bettery;
}

// class CloudSensorInfoExternal {
//   CloudSensorInfoExternal({
//     required this.state,
//     required this.value1,
//     required this.value1min,
//     required this.value1max,
//     required this.value2,
//     required this.value2min,
//     required this.value2max,
//     required this.value3,
//     required this.value3min,
//     required this.value3max,
//     this.value1title,
//     this.value1unit,
//     this.value2title,
//     this.value2unit,
//     this.value3title,
//     this.value3unit,
//     this.svgSrc,
//     this.color,
//     this.data1,
//   });

//   final int state;
//   double value1, value2, value3;
//   final int value1min, value1max, value2min, value2max, value3min, value3max;
//   final String? value1title,
//       value1unit,
//       value2title,
//       value2unit,
//       value3title,
//       value3unit;
//   final String? svgSrc;
//   final Color? color;
//   List<FlSpot>? data1;
// }
