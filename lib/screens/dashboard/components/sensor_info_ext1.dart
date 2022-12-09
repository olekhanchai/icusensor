 

import 'package:icusensor/models/MyFiles.dart';
import 'package:flutter/material.dart';
 
class SensorInfoExternal1 extends StatefulWidget {
  const SensorInfoExternal1(
      {Key? key,
      //required this.device,
      required this.onValueChanged,
      required this.onClick})
      : super(key: key);

  final ValueChanged<SensorExtChanged> onValueChanged;
  //final BluetoothDevice device;
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

 