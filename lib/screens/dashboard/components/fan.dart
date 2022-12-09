import 'package:flutter/material.dart';

class Fansetting extends StatelessWidget {
  const Fansetting({
    Key? key,
    required this.speed,
    required this.onSpeedChanged,
  }) : super(key: key);

  final int speed;
  final ValueChanged<int> onSpeedChanged;
  static List<String> level = ["LOW", "MIDLOW", "MID", "MIDHI", "HI "];

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      height: 40,
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        SizedBox(
          height: 25,
          child: Slider(
            value: speed.toDouble(),
            max: 4,
            divisions: 4,
            label: level[speed.toInt()],
            onChanged: (double value) {
              onSpeedChanged(value.toInt());
            },
          ),
        ),
        SizedBox(
          height: 25,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                level[0],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                level[2],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                level[4],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                // ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
