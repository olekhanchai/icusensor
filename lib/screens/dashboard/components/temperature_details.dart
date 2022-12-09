// ignore_for_file: avoid_unnecessary_containers

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:icusensor/screens/dashboard/components/lightcolors.dart';
import '../../../constants.dart';
import 'activeIcon.dart';
import 'chart.dart';
//import 'storage_info_card.dart';
import 'fan.dart';
import 'times.dart';

class TemperatureDetails extends StatefulWidget {
  const TemperatureDetails({
    Key? key,
    required this.isEnable,
    required this.currentTemperature,
    required this.currentMin,
    required this.currentMax,
    required this.tragetTemperature,
    required this.cuurentTime,
    required this.currentFanSpeed,
    required this.currentMode,
    required this.currentUnit,
    required this.currentIson,
    required this.currentThermals,
    required this.onEnableChanged,
    required this.onTragetTemperatureChangedMinus,
    required this.onTragetTemperatureChangedPluse,
    required this.onFanSpeedChanged,
    required this.onModeChanged,
    required this.onUnitChanged,
  }) : super(key: key);

  final bool isEnable;
  final double currentTemperature;
  final double currentMin;
  final double currentMax;
  final double tragetTemperature;
  final String cuurentTime;
  final int currentFanSpeed;
  final bool currentMode;
  final bool currentUnit;
  final bool currentIson;
  final String currentThermals;
  final ValueChanged<bool> onEnableChanged;
  final ValueChanged<double> onTragetTemperatureChangedMinus;
  final ValueChanged<double> onTragetTemperatureChangedPluse;
  final ValueChanged<int> onFanSpeedChanged;
  final ValueChanged<bool> onModeChanged;
  final ValueChanged<bool> onUnitChanged;

  @override
  State<TemperatureDetails> createState() => _TemperatureDetailsState();
}

class _TemperatureDetailsState extends State<TemperatureDetails> {
  int page = 0;

  @override
  Widget build(BuildContext context) {
    return
     Container(
      padding: const EdgeInsets.all(defaultPadding),
      height: 500,
      //width: 300,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 25,
                  child: Text(
                    "TEMPERATURE",
                    style: TextStyle(
                      //backgroundColor: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 7,
                      ),
                      ActivateIcon(
                        width: 15,
                        height: 15,
                        enable: widget.currentIson,
                        enablecolor: Colors.green,
                        disablecolor: Colors.grey,
                      ),
                    ]),
                FlutterSwitch(
                  width: 65.0,
                  height: 30.0,
                  valueFontSize: 15.0,
                  toggleSize: 15.0,
                  value: widget.isEnable,
                  borderRadius: 30.0,
                  padding: 5.0,
                  showOnOff: true,
                  onToggle: (val) {
                    widget.onEnableChanged(val);
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200,
            child: Chart(
              temperature: widget.currentTemperature,
              level: widget.tragetTemperature,
              levelmin: widget.currentMin,
              levelmax: widget.currentMax,
              unit: widget.currentUnit,
              mode: widget.currentMode,
            ),
          ),
          SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.only(left: 15),
                  child: const Text(
                    "Setting",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )),
                Container(
                  width: 30,
                  height: 50,
                  margin:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  child: Stack(children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          page = page == 0 ? 1 : 0;
                        });
                      },
                      style: ButtonStyle(
                          // backgroundColor: MaterialStateProperty.all<Color>( widget.info.color!.withOpacity(0.1)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      )),
                      child: Container(),
                    ),
                    GestureDetector(
                        child: Center(
                            child: Icon((page == 0)
                                ? Icons.more_vert
                                : Icons.add_home)),
                        onTap: () {
                          setState(() {
                            page = page == 0 ? 1 : 0;
                          });
                        })
                  ]),
                )
              ],
            ),
          ),

          if (page == 0)
            SizedBox(
                height: 75,
                child: Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 7, 230, 255),
                        elevation: 15,
                      ),
                      child: const Icon(
                        Icons.remove,
                        size: 20,
                      ),
                      onPressed: () {
                        widget.onTragetTemperatureChangedMinus(
                            widget.tragetTemperature);
                      },
                    ),
                    const SizedBox(width: defaultPadding),
                    Expanded(
                      child: Text(
                        widget.currentUnit
                            ? (widget.tragetTemperature * (9 / 5) + 32)
                                .toStringAsFixed(1)
                            : widget.tragetTemperature.toStringAsFixed(0),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color:
                              (widget.currentMode ? Colors.red : Colors.blue),
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: defaultPadding),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 7, 230, 255),
                        elevation: 15,
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 20,
                      ),
                      onPressed: () {
                        widget.onTragetTemperatureChangedPluse(
                            widget.tragetTemperature);
                      },
                    ),
                  ],
                ))
          else if (page == 1)
            SizedBox(
                height: 75,
                child: Column(
                  children: [
                    const SizedBox(height: defaultPadding * 0.5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FlutterSwitch(
                          width: 75.0,
                          height: 30.0,
                          activeText: " Heat",
                          inactiveText: " Cool",
                          activeColor: Colors.red,
                          inactiveColor: Colors.blue,
                          value: widget.currentMode,
                          borderRadius: 30.0,
                          showOnOff: true,
                          onToggle: (val) {
                            widget.onModeChanged(val);
                          },
                        ),
                        const SizedBox(width: defaultPadding),
                        FlutterSwitch(
                          width: 75.0,
                          height: 30.0,
                          activeText: "\u2109",
                          inactiveText: "\u2103",
                          activeColor: Colors.green,
                          inactiveColor: Colors.green,
                          value: widget.currentUnit,
                          borderRadius: 30.0,
                          showOnOff: true,
                          onToggle: (val) {
                            widget.onUnitChanged(val);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: defaultPadding),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            widget.currentThermals,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )),
          //SizedBox(height: defaultPadding),
          SizedBox(
              height: 25,
              child: Row(
                children: const [
                  Expanded(
                    child: Text(
                      "Fan",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              )),
          SizedBox(
              height: 50,
              child: Fansetting(
                speed: widget.currentFanSpeed,
                onSpeedChanged: widget.onFanSpeedChanged,
              )),
          SizedBox(
              height: 40,
              child: MyTime(
                timeString: widget.cuurentTime,
              )),
        ],
      ),
    );
  }
}
