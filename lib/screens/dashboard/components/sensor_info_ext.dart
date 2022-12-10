// import 'dart:async';

// import 'package:icusensor/models/MyFiles.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:icusensor/models/bluetoothid.dart';
// import '../../../constants.dart';

// class SensorInfoExternal extends StatefulWidget {
//   const SensorInfoExternal(
//       {Key? key,
//         required this.deviceName,
//     required this.deviceId,
//     required this.deviceType,
//       required this.onValueChanged,
//       required this.onClick})
//       : super(key: key);

//   final ValueChanged<SensorExtChanged> onValueChanged;
//     final String deviceName;
//   final String deviceId;
//   final int deviceType;
//   final VoidCallback onClick;




//   @override
//   State<SensorInfoExternal> createState() => _SensorInfoExternalState();
// }

// class _SensorInfoExternalState extends State<SensorInfoExternal> {

//   late BluetoothDevice device ;
//   double temp = 0;
//   double humi = 0;
//   double volt = 0;
//   double battery = 0;
//   String svgSrc = "assets/icons/google_drive.svg";
//   Color color = Color(0xFF007EE5);
//   String stateText = 'Connecting';
//   double datsum = 0;
//   List<FlSpot> datas = [
//     const FlSpot(0, 0),
//     const FlSpot(1, 0),
//     const FlSpot(2, 0),
//     const FlSpot(3, 0),
//     const FlSpot(4, 0),
//     const FlSpot(5, 0),
//     const FlSpot(6, 0)
//   ];

//   FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
//   BluetoothDeviceState deviceState = BluetoothDeviceState.disconnected;
//   StreamSubscription<BluetoothDeviceState>? _stateListener;
//   StreamSubscription<List<int>>? _notofyListener;
//   List<BluetoothService> bluetoothService = [];

//   int i = 0;
//   late DeviceIdentifier idx;

//   @override
//   initState() {
//     super.initState();
//     device =BluetoothDevice.fromId(
//                                       widget.deviceId,
//                                       name: widget.deviceName,
//                                       type: BluetoothDeviceType
//                                           .values[widget.deviceType]);
//     idx =  device.id;
//     disconnect();
//     setBleConnectionState();
//     connect();
//   }

//   @override
//   void dispose() {
//     _stateListener?.cancel();
//     disconnect();
//     super.dispose();
//   }

//   setBleConnectionState() {
//     _stateListener = device.state.listen((event) {
//       if (deviceState == event) {
//         return;
//       }
//       switch (event) {
//         case BluetoothDeviceState.disconnected:
//           stateText = "disconnected";
//           break;
//         case BluetoothDeviceState.disconnecting:
//           stateText = "disconnecting";
//           break;
//         case BluetoothDeviceState.connected:
//           stateText = "connected";
//           break;
//         case BluetoothDeviceState.connecting:
//           stateText = "connecting";
//           break;
//       }
//       deviceState = event;
//     });
//   }

//   Future<bool> connect() async {
//     Future<bool>? returnValue;
//     await device
//         .connect(autoConnect: true)
//         .timeout(const Duration(milliseconds: 15000), onTimeout: () {
//       returnValue = Future.value(false);
//       debugPrint('bluetooth connect timeout failed');
//       stateText = "disconnected";
//     }).then((data) async {
//       bluetoothService.clear();
//       if (returnValue == null) {
//         debugPrint('connection successful');
//         List<BluetoothService> bleServices =
//             await device.discoverServices();
//         setState(() {
//           bluetoothService = bleServices;
//         });

//         for (BluetoothService service in bluetoothService) {
//           if (service.uuid == Guid("ebe0ccb0-7a0a-4b0c-8a1a-6ff2997da3a6")) {
//             for (BluetoothCharacteristic c in service.characteristics) {
//               if (c.uuid == Guid("ebe0ccc1-7a0a-4b0c-8a1a-6ff2997da3a6")) {
//                 if (c.properties.notify && c.descriptors.isNotEmpty) {
//                   if (!c.isNotifying) {
//                     try {
//                       await c.setNotifyValue(true);
//                       _notofyListener = c.value.listen((value) {
//                         print('Test : ${i.toString()} ${c.uuid}: $value');
//                         i++;
//                         setState(() {
//                           if (value.length > 0) {
//                             temp = (value[0] | (value[1] << 8)) * 0.01;
//                             humi = value[2].toDouble();
//                             volt = ((value[4] * 256) + value[3]) / 1000.0;
//                             battery = ((volt - 2.1) * 100.0);
//                             print("Temp: " + temp.toStringAsFixed(2));
//                             print("Humidity: " + humi.toString());
//                             print("Voltage: " + volt.toStringAsFixed(2));
//                             print("Battery Percentage: " +
//                                 battery.toStringAsFixed(2));
//                             datachange(temp, humi, battery);
//                           }
//                         });
//                       });
//                       await Future.delayed(const Duration(milliseconds: 5000));
//                     } catch (e) {
//                       print('error ${c.uuid} $e');
//                     }
//                   }
//                 }
//               }
//             }
//           }
//         }
//         returnValue = Future.value(true);
//       }
//     });

//     return returnValue ?? Future.value(false);
//   }

//   void disconnect() {
//     try {
//       device.disconnect();
//     } catch (e) {}
//   }

//   void datachange(double t, double h, double b) {
//     int maxcount = 10;
//     datsum += t;
//     i++;
//     if (i > maxcount) {
//       i = 0;
//       datas = [
//         FlSpot(0, datas[1].y),
//         FlSpot(1, datas[2].y),
//         FlSpot(2, datas[3].y),
//         FlSpot(3, datas[4].y),
//         FlSpot(4, datas[5].y),
//         FlSpot(5, datas[6].y),
//         FlSpot(6, datsum / maxcount)
//       ];
//     }
//     setState(() {
//       widget.onValueChanged(SensorExtChanged(t, h, b));
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (device.id != idx) {
//       idx = device.id;
//       _notofyListener?.cancel();
//       _stateListener?.cancel();
//       disconnect();
//       setBleConnectionState();
//       connect();
//       setState(() {
//         temp = 0;
//         humi = 0;
//         volt = 0;
//         battery = 0;
//       });
//     }
//     Icon bateryicon(double percent) {
//       IconData ic;
//       if (percent > 90) {
//         ic = Icons.battery_full;
//       } else if (percent > 80) {
//         ic = Icons.battery_6_bar_sharp;
//       } else if (percent > 70) {
//         ic = Icons.battery_5_bar_sharp;
//       } else if (percent > 60) {
//         ic = Icons.battery_4_bar_sharp;
//       } else if (percent > 50) {
//         ic = Icons.battery_3_bar_sharp;
//       } else if (percent > 40) {
//         ic = Icons.battery_2_bar_sharp;
//       } else if (percent > 30) {
//         ic = Icons.battery_1_bar_sharp;
//       } else {
//         ic = Icons.battery_0_bar_sharp;
//       }
//       return Icon(
//         ic,
//         size: 15,
//       );
//     }

//     int valuetoPercent(int v, min, max) {
//       return (((v - min) / (max - min)) * 100).toInt();
//     }

//     return GestureDetector(
//         onTap: () {},
//         child: Container(
//           //height: ratio master,
//           padding: const EdgeInsets.all(defaultPadding * 0.5),
//           decoration: BoxDecoration(
//             color: Theme.of(context).canvasColor,
//             borderRadius: const BorderRadius.all(Radius.circular(10)),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(defaultPadding * 0.5),
//                     height: 40,
//                     width: 35,
//                     decoration: BoxDecoration(
//                       color: color.withOpacity(0.1),
//                       borderRadius: const BorderRadius.all(Radius.circular(10)),
//                     ),
//                     child: SvgPicture.asset(
//                       svgSrc,
//                       color: color,
//                     ),
//                   ),
//                   Container(
//                       // padding: const EdgeInsets.only(left: defaultPadding * 0.1),
//                       width: 73,
//                       child: Column(
//                         children: [
//                           Text(
//                            device.name.length > 16
//                                 ? "${device.name.substring(0, 16)}.."
//                                 : device.name,
//                             textAlign: TextAlign.center,
//                             style:
//                                 Theme.of(context).textTheme.caption!.copyWith(
//                                       color: Theme.of(context).dividerColor,
//                                          fontSize: 8,
//                                     ),

//                           ),
//                           Text(
//                              device.id.id,
//                             textAlign: TextAlign.center,
//                             style:
//                                 Theme.of(context).textTheme.caption!.copyWith(
//                                       color: Theme.of(context).dividerColor,
//                                         fontSize: 8,
//                                     ),
//                           ),
//                           Text(
//                             stateText,
//                             textAlign: TextAlign.center,
//                             style:
//                                 Theme.of(context).textTheme.caption!.copyWith(
//                                       color: Theme.of(context).dividerColor,
//                                       fontSize: 10,
//                                     ),
//                           ),
//                         ],
//                       )),
//                   Container(
//                     width: 30,
//                     height: 40,
//                     margin:
//                         const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
//                     child: Stack(children: [
//                       ElevatedButton(
//                         onPressed: () {
//                           widget.onClick();
//                         },
//                         style: ButtonStyle(
//                             backgroundColor: MaterialStateProperty.all<Color>(
//                                 color!.withOpacity(0.1)),
//                             shape: MaterialStateProperty.all<
//                                 RoundedRectangleBorder>(
//                               RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(18.0),
//                               ),
//                             )),
//                         child: Container(),
//                       ),
//                       GestureDetector(
//                           child: const Center(child: Icon(Icons.bluetooth)),
//                           onTap: () {
//                             widget.onClick();
//                           })
//                     ]),
//                   )
//                 ],
//               ),
//               StreamBuilder<BluetoothState>(
//                   stream: FlutterBluePlus.instance.state,
//                   initialData: BluetoothState.unknown,
//                   builder: (c, snapshot) {
//                     final state = snapshot.data;
//                     if (state == BluetoothState.on) {
//                       return Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               const Icon(
//                                 Icons.sentiment_neutral_outlined,
//                                 size: 20,
//                               ),
//                               Text(
//                                 "Humidity : ${humi.toString()} %",
//                                 textAlign: TextAlign.center,
//                                 style: const TextStyle(
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                               bateryicon(battery),
//                             ],
//                           ),
//                           const SizedBox(height: defaultPadding * 0.1),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 "${temp.toStringAsFixed(2)}",
//                                 style: const TextStyle(
//                                   fontSize: 38,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                               const Text(
//                                 "° C",
//                                 style: TextStyle(
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           ProgressLine(
//                             color: color,
//                             percentage: valuetoPercent(temp.toInt(), 0, 100),
//                           ),
//                           const SizedBox(height: defaultPadding * 0.1),
//                           const Text(
//                             "Temperature",
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           LineChartSample(
//                             allSpots: datas,
//                           ),
//                           // Chartmini(
//                           //   data: widget.info.data,
//                           // ),
//                           //  SizedBox(height: defaultPadding),
//                         ],
//                       );
//                     }
//                     return BluetoothOffScreen(state: state);
//                   }),
//             ],
//           ),
//         ));
//   }
// }

// class BluetoothOffScreen extends StatelessWidget {
//   const BluetoothOffScreen({Key? key, this.state}) : super(key: key);

//   final BluetoothState? state;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: <Widget>[
//         const Icon(
//           Icons.bluetooth_disabled,
//           size: 50.0,
//           color: Colors.white54,
//         ),
//         Text(
//           'Bluetooth is \n ${state != null ? state.toString().substring(15) : 'not available'}.',
//           style: Theme.of(context)
//               .primaryTextTheme
//               .subtitle2
//               ?.copyWith(color: Colors.white),
//         ),
//         if (state == BluetoothState.off)
//           ElevatedButton(
//               child: const Text('TURN ON'),
//               onPressed: () => FlutterBluePlus.instance.turnOn()),
//       ],
//     );
//   }
// }

// class ProgressLine extends StatelessWidget {
//   const ProgressLine({
//     Key? key,
//     this.color = primaryColor,
//     required this.percentage,
//   }) : super(key: key);

//   final Color? color;
//   final int? percentage;

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           width: double.infinity,
//           height: 5,
//           decoration: BoxDecoration(
//             color: color!.withOpacity(0.1),
//             borderRadius: const BorderRadius.all(Radius.circular(10)),
//           ),
//         ),
//         LayoutBuilder(
//           builder: (context, constraints) => Container(
//             width: constraints.maxWidth * (percentage! / 100),
//             height: 5,
//             decoration: BoxDecoration(
//               color: color,
//               borderRadius: const BorderRadius.all(Radius.circular(10)),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class LineChartSample extends StatelessWidget {
//   const LineChartSample({
//     Key? key,
//     required this.allSpots,
//   }) : super(key: key);

//   final List<FlSpot>? allSpots;
//   final List<int> showIndexes = const [1, 3, 5];

//   Widget bottomTitleWidgets(double value, TitleMeta meta) {
//     const style = TextStyle(
//       fontWeight: FontWeight.bold,
//       color: Colors.blueGrey,
//       fontFamily: 'Digital',
//       fontSize: 8,
//     );
//     String text;
//     switch (value.toInt()) {
//       case 0:
//         text = '00';
//         break;
//       case 1:
//         text = '10';
//         break;
//       case 2:
//         text = '20';
//         break;
//       case 3:
//         text = '30';
//         break;
//       case 4:
//         text = '40';
//         break;
//       case 5:
//         text = '50';
//         break;
//       case 6:
//         text = '60';
//         break;
//       default:
//         return Container();
//     }

//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       child: Text(text, style: style),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     const style = TextStyle(
//       // fontWeight: FontWeight.bold,
//       color: Colors.blueGrey,
//       fontFamily: 'Digital',
//       fontSize: 5,
//     );
//     final lineBarsData = [
//       LineChartBarData(
//         showingIndicators: showIndexes,
//         spots: allSpots,
//         isCurved: true,
//         barWidth: 1,
//         shadow: const Shadow(
//           blurRadius: 8,
//           color: Colors.black,
//         ),
//         belowBarData: BarAreaData(
//           show: true,
//           gradient: LinearGradient(
//             colors: [
//               const Color(0xff12c2e9).withOpacity(0.4),
//               const Color(0xffc471ed).withOpacity(0.4),
//               const Color(0xfff64f59).withOpacity(0.4),
//             ],
//             begin: Alignment.centerLeft,
//             end: Alignment.centerRight,
//           ),
//         ),
//         dotData: FlDotData(show: false),
//         gradient: const LinearGradient(
//           colors: [
//             Color(0xff12c2e9),
//             Color(0xffc471ed),
//             Color(0xfff64f59),
//           ],
//           stops: [0.1, 0.4, 0.9],
//           begin: Alignment.centerLeft,
//           end: Alignment.centerRight,
//         ),
//       ),
//     ];

//     final tooltipsOnBar = lineBarsData[0];

//     return SizedBox(
//       width: 180,
//       height: 60,
//       child: LineChart(
//         LineChartData(
//           showingTooltipIndicators: showIndexes.map((index) {
//             return ShowingTooltipIndicators([
//               LineBarSpot(tooltipsOnBar, lineBarsData.indexOf(tooltipsOnBar),
//                   tooltipsOnBar.spots[index]),
//             ]);
//           }).toList(),
//           lineTouchData: LineTouchData(
//             enabled: false,
//             getTouchedSpotIndicator:
//                 (LineChartBarData barData, List<int> spotIndexes) {
//               return spotIndexes.map((index) {
//                 return TouchedSpotIndicatorData(
//                   FlLine(
//                     color: Colors.pink,
//                   ),
//                   FlDotData(
//                     show: true,
//                     getDotPainter: (spot, percent, barData, index) =>
//                         FlDotCirclePainter(
//                       radius: 2,
//                       color: lerpGradient(
//                         barData.gradient!.colors,
//                         barData.gradient!.stops!,
//                         percent / 100,
//                       ),
//                       strokeWidth: 1,
//                       strokeColor: Colors.black,
//                     ),
//                   ),
//                 );
//               }).toList();
//             },
//             touchTooltipData: LineTouchTooltipData(
//               tooltipMargin: 0,
//               tooltipPadding: EdgeInsets.zero,
//               tooltipBgColor: Colors.transparent,
//               tooltipRoundedRadius: 3,
//               getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
//                 return lineBarsSpot.map((lineBarSpot) {
//                   return LineTooltipItem(
//                     lineBarSpot.y < 100
//                         ? lineBarSpot.y.toStringAsFixed(1)
//                         : lineBarSpot.y.toStringAsFixed(0),
//                     const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 8,
//                     ),
//                   );
//                 }).toList();
//               },
//             ),
//           ),
//           lineBarsData: lineBarsData,
//           minY: 0,
//           titlesData: FlTitlesData(
//             leftTitles: AxisTitles(
//               axisNameWidget: const Text(' ', style: style),
//               sideTitles: SideTitles(
//                 showTitles: true,
//                 reservedSize: 0,
//               ),
//             ),
//             bottomTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: true,
//                 interval: 1,
//                 getTitlesWidget: bottomTitleWidgets,
//               ),
//             ),
//             rightTitles: AxisTitles(
//               axisNameWidget: const Text(' ', style: style),
//               sideTitles: SideTitles(
//                 showTitles: true,
//                 reservedSize: 0,
//               ),
//             ),
//             topTitles: AxisTitles(
//               axisNameWidget:
//                   const Text(' ', textAlign: TextAlign.left, style: style),
//               sideTitles: SideTitles(
//                 showTitles: false,
//                 reservedSize: 0,
//               ),
//             ),
//           ),
//           gridData: FlGridData(show: false),
//           borderData: FlBorderData(
//             show: true,
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// Lerps between a [LinearGradient] colors, based on [t]
// Color lerpGradient(List<Color> colors, List<double> stops, double t) {
//   if (colors.isEmpty) {
//     throw ArgumentError('"colors" is empty.');
//   } else if (colors.length == 1) {
//     return colors[0];
//   }

//   if (stops.length != colors.length) {
//     stops = [];

//     /// provided gradientColorStops is invalid and we calculate it here
//     colors.asMap().forEach((index, color) {
//       final percent = 1.0 / (colors.length - 1);
//       stops.add(percent * index);
//     });
//   }

//   for (var s = 0; s < stops.length - 1; s++) {
//     final leftStop = stops[s], rightStop = stops[s + 1];
//     final leftColor = colors[s], rightColor = colors[s + 1];
//     if (t <= leftStop) {
//       return leftColor;
//     } else if (t < rightStop) {
//       final sectionT = (t - leftStop) / (rightStop - leftStop);
//       return Color.lerp(leftColor, rightColor, sectionT)!;
//     }
//   }
//   return colors.last;
// }
