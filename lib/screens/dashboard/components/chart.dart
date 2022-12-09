import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class Chart extends StatelessWidget {
  const Chart({
    Key? key,
    required this.temperature,
    required this.unit,
    required this.mode,
    required this.level,
    required this.levelmin,
    required this.levelmax,
  }) : super(key: key);

  final double temperature;
  final bool unit;
  final bool mode;
  final double level;
  final double levelmin;
  final double levelmax;

  static double interpolateWithEasing(double cmin, double cmax, double t) {
    double lerp = (t - cmin) / (cmax - cmin);
    lerp = min(1.05, lerp);
    lerp = max(-0.05, lerp);
    return lerp * 100;
  }

  Size calcTextSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textScaleFactor: WidgetsBinding.instance.window.textScaleFactor,
    )..layout();
    return textPainter.size;
  }

  @override
  Widget build(BuildContext context) {
    // var size = calcTextSize(
    //     temperature.toStringAsFixed(2),
    //     TextStyle(
    //       fontSize: 30,
    //       fontWeight: FontWeight.w500,
    //     ));

    return SizedBox(
        //color: Colors.red,
        child: SizedBox(
      height: 200,
      child: Stack(
        children: [
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: defaultPadding),
                Container(
                  //color: Colors.black,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          unit
                              ? (temperature * (9 / 5) + 32).toStringAsFixed(1)
                              : temperature.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.w500,
                          ),
                          // "12.3",
                          // style:
                          //     Theme.of(context).textTheme.headline4!.copyWith(
                          //           color: Colors.white,
                          //           fontWeight: FontWeight.w600,
                          //           height: 0.5,
                          //         ),
                        ),
                      ]),
                ),
                Text(
                  //size.width.toString(),
                  unit ? "° Fahrenheit" : "° Celsius",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
          PieChart(
            PieChartData(
              sectionsSpace: 5,
              centerSpaceRadius: 70,
              startDegreeOffset: 135,
              sections: paiChartSelectionDatas,
            ),
          ),
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 60,
              startDegreeOffset: 135 +
                  (2.2 *
                      interpolateWithEasing(levelmin, levelmax, temperature)),
              sections: paiChartValue,
            ),
          ),
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 80,
              startDegreeOffset: 125 +
                  (2.2 * interpolateWithEasing(levelmin, levelmax, level)),
              sections: mode ? paiChartSetHot : paiChartSetCool,
            ),
          ),
        ],
      ),
    ));
  }
}

List<PieChartSectionData> paiChartSetCool = [
  PieChartSectionData(
    color: Colors.blue,
    value: 30,
    showTitle: false,
    radius: 20,
  ),
  PieChartSectionData(
    color: primaryColor.withOpacity(0.0),
    value: 335,
    showTitle: false,
    radius: 20,
  ),
];

List<PieChartSectionData> paiChartSetHot = [
  PieChartSectionData(
    color: Colors.red,
    value: 30,
    showTitle: false,
    radius: 20,
  ),
  PieChartSectionData(
    color: primaryColor.withOpacity(0.0),
    value: 335,
    showTitle: false,
    radius: 20,
  ),
];

List<PieChartSectionData> paiChartValue = [
  PieChartSectionData(
    color: Colors.white,
    value: 3,
    showTitle: false,
    radius: 20,
  ),
  PieChartSectionData(
    color: primaryColor.withOpacity(0.0),
    value: 355,
    showTitle: false,
    radius: 20,
  ),
];
List<PieChartSectionData> paiChartSelectionDatas = [
  PieChartSectionData(
    color: Color(0xFF2697FF),
    value: 10,
    showTitle: false,
    radius: 25,
  ),
  PieChartSectionData(
    color: const Color(0xFF26E5FF),
    value: 10,
    showTitle: false,
    radius: 23,
  ),
  PieChartSectionData(
    color: const Color(0xFFFFCF26),
    value: 10,
    showTitle: false,
    radius: 21,
  ),
  PieChartSectionData(
    color: const Color(0xFFEE2727),
    value: 10,
    showTitle: false,
    radius: 19,
  ),
  PieChartSectionData(
    color: primaryColor.withOpacity(0.1),
    value: 23,
    showTitle: false,
    radius: 13,
  ),
];
