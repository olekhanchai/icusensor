import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:icusensor/models/flspotdata.dart';

import 'package:icusensor/widget/appbar_widget.dart';
import 'package:icusensor/widget/button_widget.dart';
import '../../constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:icusensor/events/UartValues.dart';

class SensorsChart extends StatefulWidget {
  SensorsChart({
    Key? key,
    required this.name,
    required this.unit,
    required this.currentValues,
    required this.allValues,
    required this.onScreenChanged,
  }) : super(key: key);

  List<String> name;
  List<String> unit;
  List<double> currentValues;
  FlSpotdata? allValues;

  final ValueChanged<int> onScreenChanged;
  @override
  _SensorsChartState createState() => _SensorsChartState();
}

class _SensorsChartState extends State<SensorsChart> {
  @override
  void initState() {
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
              //   color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            widget.name[0],
                            style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff12c2e9)),
                          )),
                    ),
                    Expanded(
                        flex: 4,
                        child: LineChartSample(
                          allSpots: widget.allValues?.value0,
                          title: widget.name[0],
                          yTitle: widget.unit[0],
                          showTime: false,
                          colorlist: [
                            const Color(0xfff64f59).withOpacity(0.4),
                            const Color(0xffc471ed).withOpacity(0.4),
                            const Color(0xff12c2e9).withOpacity(0.4),
                          ],
                        )),
                    Expanded(
                      flex: 1,
                      child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            '${widget.allValues?.value0[29].y.toStringAsFixed(2)}  ${widget.unit[0]}',
                            style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff12c2e9)),
                          )),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            widget.name[1],
                            style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          )),
                    ),
                    Expanded(
                        flex: 4,
                        child: LineChartSample(
                          allSpots: widget.allValues?.value1,
                          title: widget.name[1],
                          yTitle: widget.unit[1],
                          showTime: false,
                          colorlist: [
                            const Color(0xff12c2e9).withOpacity(0.4),
                            Color.fromARGB(255, 28, 110, 108).withOpacity(0.4),
                            Color.fromARGB(255, 79, 246, 207).withOpacity(0.4),
                          ],
                        )),
                    Expanded(
                      flex: 1,
                      child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            '${widget.allValues?.value1[29].y.toStringAsFixed(2)}  ${widget.unit[1]}',
                            style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          )),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            widget.name[2],
                            style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          )),
                    ),
                    Expanded(
                        flex: 4,
                        child: LineChartSample(
                          allSpots: widget.allValues?.value2,
                          title: widget.name[2],
                          yTitle: widget.unit[2],
                          showTime: false,
                          colorlist: [
                            Color.fromARGB(255, 120, 126, 127).withOpacity(0.4),
                            Color.fromARGB(255, 71, 70, 71).withOpacity(0.4),
                            Color.fromARGB(255, 53, 53, 51).withOpacity(0.4),
                          ],
                        )),
                    Expanded(
                      flex: 1,
                      child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            '${widget.allValues?.value2[29].y.toInt()}  ${widget.unit[2]}',
                            style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          )),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            widget.name[3],
                            style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange),
                          )),
                    ),
                    Expanded(
                        flex: 4,
                        child: LineChartSample(
                          allSpots: widget.allValues?.value3,
                          title: widget.name[3],
                          yTitle: widget.unit[3],
                          showTime: false,
                          colorlist: [
                            const Color(0xff12c2e9).withOpacity(0.4),
                            const Color(0xffc471ed).withOpacity(0.4),
                            Color.fromARGB(255, 34, 37, 106).withOpacity(0.4),
                          ],
                        )),
                    Expanded(
                      flex: 1,
                      child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            '${widget.allValues?.value3[29].y.toStringAsFixed(2)} ${widget.unit[3]}',
                            style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange),
                          )),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            widget.name[4],
                            style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown),
                          )),
                    ),
                    Expanded(
                        flex: 4,
                        child: LineChartSample(
                          allSpots: widget.allValues?.value4,
                          title: widget.name[4],
                          yTitle: widget.unit[4],
                          showTime: true,
                          colorlist: [
                            Color.fromARGB(255, 233, 18, 194).withOpacity(0.4),
                            const Color(0xffc471ed).withOpacity(0.4),
                            Color.fromARGB(255, 246, 79, 207).withOpacity(0.4),
                          ],
                        )),
                    Expanded(
                      flex: 1,
                      child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            '${widget.allValues?.value4[29].y.toInt()} ${widget.unit[4]}',
                            style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown),
                          )),
                    ),
                  ],
                )
              ],
            ))
      ],
    );
  }
}

class LineChartSample extends StatelessWidget {
  LineChartSample({
    Key? key,
    required this.allSpots,
    required this.title,
    required this.yTitle,
    required this.showTime,
    required this.colorlist,
  }) : super(key: key);

  List<FlSpot>? allSpots;
  String? title;
  String? yTitle;
  bool showTime = false;
  List<Color> colorlist = [
    const Color(0xff12c2e9).withOpacity(0.4),
    const Color(0xffc471ed).withOpacity(0.4),
    const Color(0xfff64f59).withOpacity(0.4),
  ];

  final List<int> showIndexes = List.generate(15, (index) {
    return (((index + 1) * 2) - 1);
  });

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.blueGrey,
      fontFamily: 'Digital',
      fontSize: 6,
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
      fontSize: 15,
    );
    final lineBarsData = [
      LineChartBarData(
        showingIndicators: showIndexes,
        spots: allSpots,
        isCurved: true,
        barWidth: 2,
        shadow: const Shadow(
          blurRadius: 8,
          color: Colors.black,
        ),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: colorlist,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        dotData: FlDotData(show: false),
        gradient: LinearGradient(
          colors: colorlist,
          stops: [0.1, 0.4, 0.9],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    ];

    final tooltipsOnBar = lineBarsData[0];
    double h = showTime ? 110 : 90;
    return SizedBox(
      // width: 500,
      height: h,
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
                    color: Theme.of(context).dividerColor,
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
              tooltipMargin: 5,
              tooltipPadding: EdgeInsets.zero,
              tooltipBgColor: Colors.transparent,
              tooltipRoundedRadius: 3,
              getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                return lineBarsSpot.map((lineBarSpot) {
                  return LineTooltipItem(
                    lineBarSpot.y < 100
                        ? lineBarSpot.y.toStringAsFixed(1)
                        : lineBarSpot.y.toStringAsFixed(0),
                    TextStyle(
                      color: Theme.of(context).dividerColor,
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
              axisNameWidget: Text('$yTitle ', style: style),
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 0,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: showTime,
                interval: 2,
                //8getTitlesWidget: bottomTitleWidgets,
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
          gridData: FlGridData(show: true),
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
