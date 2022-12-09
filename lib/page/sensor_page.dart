import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:icusensor/models/flspotdata.dart';
import 'package:icusensor/widget/appbar_widget.dart';
import 'package:icusensor/widget/button_widget.dart';
import 'package:fl_chart/fl_chart.dart';

class SensorsPage extends StatefulWidget {
  SensorsPage({
    Key? key,
    required this.value,
  }) : super(key: key);

  FlSpotdata? value;

  @override
  _SensorsPageState createState() => _SensorsPageState();
}

class _SensorsPageState extends State<SensorsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Builder(
        builder: (context) => Scaffold(
          appBar: buildAppBar(context),
          body: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(
                      flex: 1,
                      child: Text(
                        '00',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )),
                  Expanded(
                      flex: 4,
                      child: LineChartSample(
                        allSpots: widget.value?.value0,
                        title: "Temp",
                        yTitle: "(C)",
                        showTime: false,
                      ))
                ],
              ),
              Row(
                children: [
                  const Expanded(
                      flex: 1,
                      child: Text(
                        '00',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )),
                  Expanded(
                      flex: 4,
                      child: LineChartSample(
                        allSpots: widget.value?.value1,
                        title: "O2",
                        yTitle: "(%)",
                        showTime: false,
                      ))
                ],
              ),
              Row(
                children: [
                  const Expanded(
                      flex: 1,
                      child: Text(
                        '00',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )),
                  Expanded(
                      flex: 4,
                      child: LineChartSample(
                        allSpots: widget.value?.value2,
                        title: "Co2",
                        yTitle: "(%)",
                        showTime: false,
                      ))
                ],
              ),
              Row(
                children: [
                  const Expanded(
                      flex: 1,
                      child: Text(
                        '00',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )),
                  Expanded(
                      flex: 4,
                      child: LineChartSample(
                        allSpots: widget.value?.value3,
                        title: "Humidity",
                        yTitle: "(%)",
                        showTime: false,
                      ))
                ],
              ),
              Row(
                children: [
                  const Expanded(
                      flex: 1,
                      child: Text(
                        '00',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )),
                  Expanded(
                      flex: 4,
                      child: LineChartSample(
                        allSpots: widget.value?.value4,
                        title: "PM",
                        yTitle: "(%)",
                        showTime: true,
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUpgradeButton() => ButtonWidget(
        text: 'Upgrade',
        onClicked: () {},
      );
}

class LineChartSample extends StatelessWidget {
  LineChartSample(
      {Key? key,
      required this.allSpots,
      required this.title,
      required this.yTitle,
      required this.showTime})
      : super(key: key);

  List<FlSpot>? allSpots;
  String? title;
  String? yTitle;
  bool showTime = false;

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
      fontSize: 13,
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
              axisNameWidget: Text('$title $yTitle ', style: style),
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
