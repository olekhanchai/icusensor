import 'dart:typed_data';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:icusensor/models/flspotdata.dart';
import 'package:flutter/material.dart';
import 'package:icusensor/screens/dashboard/components/activeIcon.dart';
import 'package:icusensor/widget/appbar_widget.dart';
import 'package:icusensor/widget/button_widget.dart';
import 'package:icusensor/screens/dashboard/components/activeIcon.dart';
import '../../constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';

class SensorsDiagram extends StatefulWidget {
  const SensorsDiagram({
    Key? key,
    required this.tempState,
    required this.tempVal,
    required this.tempUnit,
    required this.tempMode,
    required this.tempFan,
    required this.tempEv,
    required this.tempCd,
    required this.tempCp,
    required this.tempHt,
    required this.o2State,
    required this.o2Val,
    required this.o2Fan,
    required this.co2State,
    required this.co2Val,
    required this.huState,
    required this.huVal,
    required this.huFan,
    required this.reState,
    required this.reVal,
    required this.onScreenChanged,
  }) : super(key: key);

  final bool tempState;
  final double tempVal;
  final bool tempUnit;
  final bool tempMode;
  final int tempFan;
  final double tempEv;
  final double tempCd;
  final double tempCp;
  final double tempHt;
  final int o2State;
  final double o2Val;
  final int o2Fan;
  final int co2State;
  final double co2Val;
  final int huState;
  final double huVal;
  final int huFan;
  final int reState;
  final double reVal;

  final ValueChanged<int> onScreenChanged;

  @override
  State<SensorsDiagram> createState() => _SensorsDiagramState();
}

class _SensorsDiagramState extends State<SensorsDiagram> {
  late Timer _timer;
  bool state = false;

  void _changeData() {
    setState(() {
      state = !state;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _timer =
        Timer.periodic(const Duration(seconds: 1), (Timer t) => _changeData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                widget.onScreenChanged(0);
              },
            ),
          ],
        ),
        Container(
            padding: const EdgeInsets.all(defaultPadding),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Stack(
              children: <Widget>[
                Image.asset(
                  'assets/images/icudiagram.png',
                ),
                //Heater mode
                Positioned(
                  top: 12,
                  left: 240,
                  child: ActivateIcon(
                    width: 15,
                    height: 15,
                    enable: widget.tempMode & widget.tempState,
                    enablecolor: Colors.green,
                    disablecolor: Colors.grey,
                  ),
                ),
                //Cooler mode
                Positioned(
                  top: 12,
                  left: 470,
                  child: ActivateIcon(
                    width: 15,
                    height: 15,
                    enable: (!widget.tempMode & widget.tempState),
                    enablecolor: Colors.green,
                    disablecolor: Colors.grey,
                  ),
                ),
                //Temperature value
                Positioned(
                  top: 100,
                  left: 100,
                  child: Text(
                    '${widget.tempHt.toStringAsFixed(1)} °C',
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.red,
                    ),
                  ),
                ),
                //Evapulator Temp
                Positioned(
                  top: 100,
                  left: 390,
                  child: Text(
                    '${widget.tempEv.toStringAsFixed(1)} °C',
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.blue,
                    ),
                  ),
                ),
                //Compressor Temp
                Positioned(
                  top: 100,
                  left: 560,
                  child: Text(
                    '${widget.tempCp.toStringAsFixed(1)} °C',
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.orange,
                    ),
                  ),
                ),
                //Condensor Temp
                Positioned(
                  top: 100,
                  left: 730,
                  child: Text(
                    '${widget.tempCd.toStringAsFixed(1)} °C',
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.red,
                    ),
                  ),
                ),
                //Cooler Fan Speed
                Positioned(
                  top: 150,
                  left: 235,
                  child: Text(
                    '${widget.tempFan} %',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.greenAccent,
                    ),
                  ),
                ),
                //Heater Fan Speed
                const Positioned(
                  top: 150,
                  left: 590,
                  child: Text(
                    '100 %',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.greenAccent,
                    ),
                  ),
                ),
                //Temperature Chamber
                Positioned(
                  top: 330,
                  left: 120,
                  child: Text(
                    '${widget.tempVal.toStringAsFixed(1)} °C',
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.greenAccent,
                    ),
                  ),
                ),
                //Oxygen Value
                Positioned(
                  top: 330,
                  left: 295,
                  child: Text(
                    '${widget.o2Val.toStringAsFixed(1)} %',
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.greenAccent,
                    ),
                  ),
                ),
                //Cabondioxy Value
                Positioned(
                  top: 330,
                  left: 450,
                  child: Text(
                    '${widget.co2Val.toInt()} ppm',
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.greenAccent,
                    ),
                  ),
                ),
                //Humidity Value
                Positioned(
                  top: 330,
                  left: 620,
                  child: Text(
                    '${widget.huVal.toStringAsFixed(1)} %',
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.greenAccent,
                    ),
                  ),
                ),
                //Reserve Value
                Positioned(
                  top: 330,
                  left: 770,
                  child: Text(
                    '${widget.reVal.toInt()} u',
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.greenAccent,
                    ),
                  ),
                ),
                //Oxygen Fan Speed
                Positioned(
                  top: 365,
                  left: 390,
                  child: Text(
                    '${widget.o2Fan.toInt()} %',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.greenAccent,
                    ),
                  ),
                ),
                //Humidity Fan Speed
                Positioned(
                  top: 365,
                  left: 715,
                  child: Text(
                    '${widget.huFan.toInt()} %',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.greenAccent,
                    ),
                  ),
                ),
                //Temperature State
                Positioned(
                  top: 453,
                  left: 100,
                  child: ActivateIcon(
                    width: 15,
                    height: 15,
                    enable: widget.tempState,
                    enablecolor: Colors.green,
                    disablecolor: Colors.grey,
                  ),
                ),
                //Oxygen State
                Positioned(
                  top: 453,
                  left: 270,
                  child: ActivateIcon(
                    width: 15,
                    height: 15,
                    enable: widget.o2State > 0,
                    enablecolor: Colors.green,
                    disablecolor: Colors.grey,
                  ),
                ),
                //Cabondioxy state
                Positioned(
                  top: 453,
                  left: 435,
                  child: ActivateIcon(
                    width: 15,
                    height: 15,
                    enable: widget.co2State > 0,
                    enablecolor: Colors.green,
                    disablecolor: Colors.grey,
                  ),
                ),
                //Humidity State
                Positioned(
                  top: 453,
                  left: 595,
                  child: ActivateIcon(
                    width: 15,
                    height: 15,
                    enable: widget.huState > 0,
                    enablecolor: Colors.green,
                    disablecolor: Colors.grey,
                  ),
                ),
                //Reserve State
                Positioned(
                  top: 453,
                  left: 770,
                  child: ActivateIcon(
                    width: 15,
                    height: 15,
                    enable: widget.reState > 0,
                    enablecolor: Colors.green,
                    disablecolor: Colors.grey,
                  ),
                ),
                //Arrow Cool Refrigerant
                Positioned(
                  top: 80,
                  left: 430,
                  child: SizedBox(
                    height: 15,
                    width: 40,
                    child: Container(
                      color: state & widget.tempState
                          ? Colors.white
                          : Colors.transparent,
                    ),
                  ),
                ),
                //Arrow Hot Refrigerant
                Positioned(
                  top: 80,
                  left: 720,
                  child: SizedBox(
                    height: 15,
                    width: 40,
                    child: Container(
                      color: !state & widget.tempState
                          ? Colors.white
                          : Colors.transparent,
                    ),
                  ),
                ),
                //Arrow Cold Refrigurant
                Positioned(
                  top: 260,
                  left: 430,
                  child: SizedBox(
                    height: 15,
                    width: 40,
                    child: Container(
                      color: !state & widget.tempState
                          ? Colors.white
                          : Colors.transparent,
                    ),
                  ),
                ),
                //Arrow Warm Refrigurant
                Positioned(
                  top: 260,
                  left: 720,
                  child: SizedBox(
                    height: 15,
                    width: 40,
                    child: Container(
                      color: state & widget.tempState
                          ? Colors.white
                          : Colors.transparent,
                    ),
                  ),
                ),
                //Fan Temperature
                Positioned(
                  top: 151,
                  left: 210,
                  child: SizedBox(
                    height: 32,
                    width: 20,
                    child: Container(
                      color: state & widget.tempState & widget.tempState
                          ? Colors.white
                          : Colors.transparent,
                    ),
                  ),
                ),
                Positioned(
                  top: 193,
                  left: 210,
                  child: SizedBox(
                    height: 32,
                    width: 20,
                    child: Container(
                      color: state & widget.tempState & widget.tempState
                          ? Colors.white
                          : Colors.transparent,
                    ),
                  ),
                ),
                //Fan Condensor
                Positioned(
                  top: 151,
                  left: 641,
                  child: SizedBox(
                    height: 32,
                    width: 20,
                    child: Container(
                      color: state & widget.tempState
                          ? Colors.white
                          : Colors.transparent,
                    ),
                  ),
                ),
                Positioned(
                  top: 193,
                  left: 641,
                  child: SizedBox(
                    height: 32,
                    width: 20,
                    child: Container(
                      color: state & widget.tempState
                          ? Colors.white
                          : Colors.transparent,
                    ),
                  ),
                ),
                //Fan Oxygen
                Positioned(
                  top: 366,
                  left: 363,
                  child: SizedBox(
                    height: 32,
                    width: 20,
                    child: Container(
                      color: (widget.o2State > 0) & (widget.o2Fan > 0)
                          ? Colors.white
                          : Colors.transparent,
                    ),
                  ),
                ),
                Positioned(
                  top: 410,
                  left: 363,
                  child: SizedBox(
                    height: 32,
                    width: 20,
                    child: Container(
                      color: (widget.o2State > 0) & (widget.o2Fan > 0)
                          ? Colors.white
                          : Colors.transparent,
                    ),
                  ),
                ),
                //Fan Humidity
                Positioned(
                  top: 366,
                  left: 687,
                  child: SizedBox(
                    height: 32,
                    width: 20,
                    child: Container(
                      color: (widget.huState > 0) & (widget.huFan > 0)
                          ? Colors.white
                          : Colors.transparent,
                    ),
                  ),
                ),
                Positioned(
                  top: 410,
                  left: 687,
                  child: SizedBox(
                    height: 32,
                    width: 20,
                    child: Container(
                      color: (widget.huState > 0) & (widget.huFan > 0)
                          ? Colors.white
                          : Colors.transparent,
                    ),
                  ),
                ),
              ],
            ))
      ],
    );
  }
}
