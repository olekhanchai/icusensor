 

import 'package:icusensor/models/MyFiles.dart';
import 'package:flutter/material.dart';
 
class SensorInfoExternal1 extends StatefulWidget {
  const SensorInfoExternal1(
      {Key? key,
       required this.deviceName,
    required this.deviceId,
    required this.deviceType,
      required this.onValueChanged,
      required this.onClick})
      : super(key: key);

  final ValueChanged<SensorExtChanged> onValueChanged;
   final String deviceName;
  final String deviceId;
  final int deviceType;
  final VoidCallback onClick;
 
  @override
  State<SensorInfoExternal1> createState() => _SensorInfoExternal1State();
}

class _SensorInfoExternal1State extends State<SensorInfoExternal1> {
 
 
   
  @override
  Widget build(BuildContext context) {
   return Text("");
  }
}

 