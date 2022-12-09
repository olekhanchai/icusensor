import 'package:icusensor/models/MyFiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
//import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import '../../../constants.dart';
import 'activeIcon.dart';

class SensorInfoCard extends StatefulWidget {
  const SensorInfoCard({
    Key? key,
    required this.id,
    required this.info,
    required this.onStatesChanged,
  }) : super(key: key);

  final int id;
  final CloudSensorInfo info;
  final ValueChanged<SensorStateChanged> onStatesChanged;

  @override
  State<SensorInfoCard> createState() => _SensorInfoCardState();
}

class _SensorInfoCardState extends State<SensorInfoCard> {
  int page = 0;
  int startcount = 0;
  bool tVisible = false;
  List<String> modesStr = ["OFF", "ON", "AUTO", "TIMER"];
  //const uint16_t timers_min[] = { 1,5,10,15,20,25,30,40,50,60,120,240,480,720,1440,2880};
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

  int valuetoPercent(int v, min, max) {
    return (((v - min) / (max - min)) * 100).toInt();
  }

  List<Widget> icons = [
    const Icon(Icons.cancel, size: 20),
    const Icon(Icons.done, size: 20),
    const Icon(Icons.auto_awesome_mosaic, size: 20),
    const Icon(Icons.timer, size: 20),
  ];

  void selectmode(int index) {
    setState(() => {tVisible = (index >= 2)});
  }

  bool timechange = false;
  void _changeData() {
    // if (startcount > 30) {
    //   startcount = 0;
    //   setState(() => {page = 0});
    // } else {
    //   startcount++;
    // }

    timechange = !timechange;
  }

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _changeData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          startcount = 0;
        },
        child: Container(
          //height: ratio master,
          padding: const EdgeInsets.all(defaultPadding * 0.5),
          decoration: const BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(defaultPadding * 0.5),
                    height: 40,
                    width: 35,
                    decoration: BoxDecoration(
                      color: widget.info.color!.withOpacity(0.1),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: SvgPicture.asset(
                      widget.info.svgSrc!,
                      color: widget.info.color,
                    ),
                  ),
                  ActivateIcon(
                    width: 15,
                    height: 15,
                    enable: widget.info.ison,
                    enablecolor: Colors.green,
                    disablecolor: Colors.grey,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: defaultPadding * 0.1),
                    width: 40,
                    child: Text(
                      modesStr[widget.info.state],
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 40,
                    margin:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    child: Stack(children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() => page = page == 0 ? 1 : 0);
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                widget.info.color!.withOpacity(0.1)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
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
                            setState(() => page = page == 0 ? 1 : 0);
                          })
                    ]),
                  )
                ],
              ),
              if (page == 0)
                Column(
                  children: [
                    (widget.info.state == 2)
                        ? Text(
                            "${widget.info.target.toString()} ${widget.info.unit}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : (widget.info.state == 3)
                            ? Text(
                                msToTime(widget.info.elaps),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            : const Text(" "),
                    const SizedBox(height: defaultPadding * 0.1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${(widget.info.digit == 1) ? widget.info.value : widget.info.value.toInt()} ",
                          style: const TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          widget.info.unit!,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          //   style: Theme.of(context)
                          //       .textTheme
                          //       .caption!
                          //       .copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                    ProgressLine(
                      color: widget.info.color,
                      percentage: (widget.info.state == 2) && timechange
                          ? valuetoPercent(widget.info.target,
                              widget.info.targetmin, widget.info.targetmax)
                          : valuetoPercent(widget.info.value.toInt(),
                              widget.info.valuemin, widget.info.valuemax),
                    ),
                    const SizedBox(height: defaultPadding * 0.1),
                    Text(
                      widget.info.title!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    LineChartSample(
                      allSpots: widget.info.data,
                    ),
                    // Chartmini(
                    //   data: widget.info.data,
                    // ),
                    //  SizedBox(height: defaultPadding),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (widget.info.state == 0)
                      const Text("Output Off\n",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ))
                    else if (widget.info.state == 1)
                      const Text("Output On\n",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ))
                    else if (widget.info.state > 1)
                      Column(
                        children: [
                          (widget.info.state == 2)
                              ? Text(
                                  "${widget.info.value.toInt().toString()} ${widget.info.unit}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              : (widget.info.state == 3)
                                  ? Text(
                                      msToTime(widget.info.elaps),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  : const Text(" "),
                          const SizedBox(height: defaultPadding * 1),
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
                                    startcount = 0;
                                    widget.onStatesChanged(SensorStateChanged(
                                        widget.id, widget.info.state, -1));
                                  },
                                ),
                              ),
                              const SizedBox(width: defaultPadding * 0.1),
                              SizedBox(
                                  height: 30,
                                  width: 50,
                                  child: (widget.info.state == 2)
                                      ? Text(
                                          "${widget.info.target.toString()} ${widget.info.unit}",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            // fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      : (widget.info.state == 3)
                                          ? Text(
                                              mterStr[widget.info.timer],
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )
                                          : const Text(" ")),
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
                                    startcount = 0;
                                    widget.onStatesChanged(SensorStateChanged(
                                        widget.id, widget.info.state, 1));
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: defaultPadding * 0.5),
                          ProgressLine(
                            color: widget.info.color,
                            percentage: (widget.info.state > 2)
                                ? (((widget.info.timer + 1) / 16) * 100).toInt()
                                : valuetoPercent(
                                    widget.info.target,
                                    widget.info.targetmin,
                                    widget.info.targetmax),
                          )
                        ],
                      ),
                    const SizedBox(height: defaultPadding * 0.5),
                    ToggleButtons(
                      constraints:
                          const BoxConstraints(minHeight: 50.0, minWidth: 32),
                      isSelected: [
                        widget.info.state == 0,
                        widget.info.state == 1,
                        widget.info.state == 2,
                        widget.info.state == 3
                      ],
                      onPressed: (int index) {
                        startcount = 0;
                        selectmode(index);
                        widget.onStatesChanged(
                            SensorStateChanged(widget.id, index, 0));
                      },
                      children: icons,
                    ),
                  ],
                ),
            ],
          ),
        ));
  }
}

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    this.color = primaryColor,
    required this.percentage,
  }) : super(key: key);

  final Color? color;
  final int? percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color!.withOpacity(0.1),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage! / 100),
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}

// class Chartmini extends StatelessWidget {
//   const Chartmini({
//     Key? key,
//     required this.data,
//   }) : super(key: key);

//   final List<SensorData>? data;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       //color: Colors.blue[200],
//       height: 45,
//       width: 120,
//       //  padding: EdgeInsets.zero,
//       //  margin: EdgeInsets.zero,
//       //margin: EdgeInsets.all(-15),
//       child: SfCartesianChart(
//           plotAreaBackgroundColor: Colors.transparent,
//           primaryXAxis: CategoryAxis(
//             isVisible: false,
//           ),
//           primaryYAxis: NumericAxis(isVisible: false),
//           plotAreaBorderWidth: 0,
//           series: <ChartSeries<SensorData, String>>[
//             LineSeries<SensorData, String>(
//                 dataSource: data!,
//                 xValueMapper: (SensorData sensor, _) => sensor.time.toString(),
//                 yValueMapper: (SensorData sensor, _) =>
//                     sensor.data < 100 ? sensor.data : sensor.data.toInt(),
//                 // name: 'sensor',
//                 // Enable data label
//                 dataLabelSettings: const DataLabelSettings(
//                   isVisible: true,
//                   textStyle: TextStyle(
//                     color: Colors.grey,
//                     fontSize: 10,
//                     //  fontWeight: FontWeight.w500,
//                   ),
//                 ))
//           ]),
//     );
//   }
// }

class LineChartSample extends StatelessWidget {
  const LineChartSample({
    Key? key,
    required this.allSpots,
  }) : super(key: key);

  final List<FlSpot>? allSpots;
  final List<int> showIndexes = const [1, 3, 5];
  // final List<FlSpot> allSpots = const [
  //   FlSpot(0, 1),
  //   FlSpot(1, 2),
  //   FlSpot(2, 1.5),
  //   FlSpot(3, 3),
  //   FlSpot(4, 3.5),
  //   FlSpot(5, 5),
  //   FlSpot(6, 8),
  // ];

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.blueGrey,
      fontFamily: 'Digital',
      fontSize: 8,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '00';
        break;
      case 1:
        text = '10';
        break;
      case 2:
        text = '20';
        break;
      case 3:
        text = '30';
        break;
      case 4:
        text = '40';
        break;
      case 5:
        text = '50';
        break;
      case 6:
        text = '60';
        break;
      default:
        return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      // fontWeight: FontWeight.bold,
      color: Colors.blueGrey,
      fontFamily: 'Digital',
      fontSize: 5,
    );
    final lineBarsData = [
      LineChartBarData(
        showingIndicators: showIndexes,
        spots: allSpots,
        isCurved: true,
        barWidth: 1,
        shadow: const Shadow(
          blurRadius: 8,
          color: Colors.black,
        ),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: [
              const Color(0xff12c2e9).withOpacity(0.4),
              const Color(0xffc471ed).withOpacity(0.4),
              const Color(0xfff64f59).withOpacity(0.4),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        dotData: FlDotData(show: false),
        gradient: const LinearGradient(
          colors: [
            Color(0xff12c2e9),
            Color(0xffc471ed),
            Color(0xfff64f59),
          ],
          stops: [0.1, 0.4, 0.9],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    ];

    final tooltipsOnBar = lineBarsData[0];

    return SizedBox(
      width: 180,
      height: 60,
      child: LineChart(
        LineChartData(
          showingTooltipIndicators: showIndexes.map((index) {
            return ShowingTooltipIndicators([
              LineBarSpot(tooltipsOnBar, lineBarsData.indexOf(tooltipsOnBar),
                  tooltipsOnBar.spots[index]),
            ]);
          }).toList(),
          lineTouchData: LineTouchData(
            enabled: false,
            getTouchedSpotIndicator:
                (LineChartBarData barData, List<int> spotIndexes) {
              return spotIndexes.map((index) {
                return TouchedSpotIndicatorData(
                  FlLine(
                    color: Colors.pink,
                  ),
                  FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) =>
                        FlDotCirclePainter(
                      radius: 2,
                      color: lerpGradient(
                        barData.gradient!.colors,
                        barData.gradient!.stops!,
                        percent / 100,
                      ),
                      strokeWidth: 1,
                      strokeColor: Colors.black,
                    ),
                  ),
                );
              }).toList();
            },
            touchTooltipData: LineTouchTooltipData(
              tooltipMargin: 0,
              tooltipPadding: EdgeInsets.zero,
              tooltipBgColor: Colors.transparent,
              tooltipRoundedRadius: 3,
              getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                return lineBarsSpot.map((lineBarSpot) {
                  return LineTooltipItem(
                    lineBarSpot.y < 100
                        ? lineBarSpot.y.toStringAsFixed(1)
                        : lineBarSpot.y.toStringAsFixed(0),
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 8,
                    ),
                  );
                }).toList();
              },
            ),
          ),
          lineBarsData: lineBarsData,
          minY: 0,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              axisNameWidget: const Text(' ', style: style),
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 0,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: bottomTitleWidgets,
              ),
            ),
            rightTitles: AxisTitles(
              axisNameWidget: const Text(' ', style: style),
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 0,
              ),
            ),
            topTitles: AxisTitles(
              axisNameWidget:
                  const Text(' ', textAlign: TextAlign.left, style: style),
              sideTitles: SideTitles(
                showTitles: false,
                reservedSize: 0,
              ),
            ),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(
            show: true,
          ),
        ),
      ),
    );
  }
}

/// Lerps between a [LinearGradient] colors, based on [t]
Color lerpGradient(List<Color> colors, List<double> stops, double t) {
  if (colors.isEmpty) {
    throw ArgumentError('"colors" is empty.');
  } else if (colors.length == 1) {
    return colors[0];
  }

  if (stops.length != colors.length) {
    stops = [];

    /// provided gradientColorStops is invalid and we calculate it here
    colors.asMap().forEach((index, color) {
      final percent = 1.0 / (colors.length - 1);
      stops.add(percent * index);
    });
  }

  for (var s = 0; s < stops.length - 1; s++) {
    final leftStop = stops[s], rightStop = stops[s + 1];
    final leftColor = colors[s], rightColor = colors[s + 1];
    if (t <= leftStop) {
      return leftColor;
    } else if (t < rightStop) {
      final sectionT = (t - leftStop) / (rightStop - leftStop);
      return Color.lerp(leftColor, rightColor, sectionT)!;
    }
  }
  return colors.last;
}
