import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:icusensor/constants.dart';

class Mymodules extends StatelessWidget {
  Mymodules(
      {Key? key,
      required this.states,
      required this.names,
      required this.timers,
      required this.elaps,
      required this.currentModule,
      required this.onStatesChanged,
      required this.onTimerChanged,
      required this.onModuleChanged})
      : super(key: key);

  final List<bool> states;
  final List<String> names;
  final List<int> timers;
  final List<int> elaps;
  final int currentModule;
  final ValueChanged<List<bool>> onStatesChanged;
  final ValueChanged<List<int>> onTimerChanged;
  final ValueChanged<int> onModuleChanged;

  List<String> mterStr = [
    "1 Min",
    "5 Min",
    "10 Min",
    "15 Min",
    "20 Min",
    "25 Min",
    "30 Min",
    "40 Min",
    "50 Min",
    "1 Hour",
    "2 Hour",
    "4 Hour",
    "8 Hour",
    "16 Hour",
    "24 Hour",
    "48 Hour",
  ];

  String msToTime(int s) {
    int ms = s % 1000;
    s = (s - ms) ~/ 1000;
    int secs = s % 60;
    s = (s - secs) ~/ 60;
    int mins = (s % 60);
    int hrs = (s - mins) ~/ 60;
    return '${hrs.toString().padLeft(2, '0')} : ${mins.toString().padLeft(2, '0')} : ${secs ~/ 10}${secs % 10 > 5 ? '5' : '0'}';
  }

  void changemodule(int id) {
    onModuleChanged(id);
  }

  void changeState(int id, bool state) {
    states[id] = state;
    onStatesChanged(states);
  }

  void changeTimer(int id, int timer) {
    timer = min(timer, mterStr.length - 1);
    timer = max(0, timer);
    timers[id] = timer;
    onTimerChanged(timers);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 272,
        padding: const EdgeInsets.all(defaultPadding * 0.5),
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(defaultPadding * 0.1),
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: defaultPadding * 0.5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${names[currentModule]} : TIME LEFT",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        msToTime(elaps[currentModule]),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 30,
                        width: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size.zero, // Set this
                            padding: EdgeInsets.zero, // and this
                          ),
                          child: const Text('-'),
                          onPressed: () {
                            changeTimer(
                                currentModule, timers[currentModule] - 1);
                          },
                        ),
                      ),
                      const SizedBox(width: defaultPadding * 0.1),
                      SizedBox(
                          height: 30,
                          width: 50,
                          child: Text(
                            mterStr[timers[currentModule]],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                      const SizedBox(width: defaultPadding * 0.1),
                      SizedBox(
                        height: 30,
                        width: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size.zero, // Set this
                            padding: EdgeInsets.zero, // and this
                          ),
                          child: const Text('+'),
                          onPressed: () {
                            changeTimer(
                                currentModule, timers[currentModule] + 1);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: defaultPadding * 0.5),
                ],
              ),
            ),

            GestureDetector(
                onTap: () {
                  changemodule(0);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      names[0],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    FlutterSwitch(
                      width: 65.0,
                      height: 30.0,
                      valueFontSize: 15.0,
                      toggleSize: 15.0,
                      value: states[0],
                      borderRadius: 30.0,
                      padding: 5.0,
                      showOnOff: true,
                      onToggle: (val) {
                        changeState(0, val);
                        changemodule(0);
                      },
                    ),
                  ],
                )),
            GestureDetector(
                onTap: () {
                  changemodule(1);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      names[1],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    FlutterSwitch(
                      width: 65.0,
                      height: 30.0,
                      valueFontSize: 15.0,
                      toggleSize: 15.0,
                      value: states[1],
                      borderRadius: 30.0,
                      padding: 5.0,
                      showOnOff: true,
                      onToggle: (val) {
                        changeState(1, val);
                        changemodule(1);
                      },
                    ),
                  ],
                )),
            GestureDetector(
                onTap: () {
                  changemodule(2);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      names[2],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    FlutterSwitch(
                      width: 65.0,
                      height: 30.0,
                      valueFontSize: 15.0,
                      toggleSize: 15.0,
                      value: states[2],
                      borderRadius: 30.0,
                      padding: 5.0,
                      showOnOff: true,
                      onToggle: (val) {
                        changeState(2, val);
                        changemodule(2);
                      },
                    ),
                  ],
                )),
            GestureDetector(
                onTap: () {
                  changemodule(3);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      names[3],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    FlutterSwitch(
                      width: 65.0,
                      height: 30.0,
                      valueFontSize: 15.0,
                      toggleSize: 15.0,
                      value: states[3],
                      borderRadius: 30.0,
                      padding: 5.0,
                      showOnOff: true,
                      onToggle: (val) {
                        changeState(3, val);
                        changemodule(3);
                      },
                    ),
                  ],
                )),

            // const SizedBox(height: defaultPadding * 0.01),
          ],
        ));
  }
}
