import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:icusensor/constants.dart';

class Mylight extends StatelessWidget {
  const Mylight({
    Key? key,
    required this.onoff,
    required this.state,
    required this.brightness,
    required this.currentColor,
    required this.onOnOffChanged,
    required this.onStateChanged,
    required this.onBrightnessChanged,
    required this.onColorChanged,
  }) : super(key: key);

  final bool onoff;
  final List<bool> state;
  final double brightness;
  final Color currentColor;
  final ValueChanged<bool> onOnOffChanged;
  final ValueChanged<List<bool>> onStateChanged;
  final ValueChanged<double> onBrightnessChanged;
  final ValueChanged<Color> onColorChanged;

  static List<String> speed = ["LOW", "MID-LOW", "MID", "MID-HI", "HI "];

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(defaultPadding * 0.5),
        //height: 30,
        //width: 300,
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          children: [
            SizedBox(
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'LIGHT',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    FlutterSwitch(
                      width: 65.0,
                      height: 30.0,
                      valueFontSize: 15.0,
                      toggleSize: 15.0,
                      value: onoff,
                      borderRadius: 30.0,
                      padding: 5.0,
                      showOnOff: true,
                      onToggle: (val) {
                        onOnOffChanged(val);
                      },
                    ),
                  ],
                )),
            const SizedBox(
              height: defaultPadding * 1.5,
            ),
            SizedBox(
              height: 30,
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        titlePadding: const EdgeInsets.all(0),
                        contentPadding: const EdgeInsets.all(25),
                        content: SingleChildScrollView(
                          child: BlockColorPickerCycle(
                            pickerColor: currentColor,
                            onColorChanged: onColorChanged,
                          ),
                        ),
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: currentColor,
                  elevation: 10,
                ),
                child: const Icon(Icons.code, color: Colors.white),
              ),
            ),
            const SizedBox(
              height: (defaultPadding * 1),
            ),
            SizedBox(
              height: 35,
              child: Slider(
                activeColor: Colors.white,
                value: brightness,
                max: 4,
                divisions: 4,
                label: speed[brightness.toInt()],
                onChanged: (double value) {
                  onBrightnessChanged(value);
                },
              ),
            ),
            const SizedBox(
              height: (defaultPadding * 0.5),
            ),
            SizedBox(
              height: 70,
              child: BlockColorPickerExample(
                pickerColor: currentColor,
                onColorChanged: onColorChanged,
                colorHistory: colors,
              ),
            ),
            const SizedBox(
              height: (defaultPadding * 0.5),
            ),
            Container(
                height: 35,
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: ToggleButtons(
                  color: Colors.black, //.withOpacity(0.60),
                  selectedColor: const Color.fromARGB(255, 162, 157, 168),
                  selectedBorderColor: const Color.fromARGB(255, 101, 211, 38),
                  fillColor: const Color(0xFF6200EE).withOpacity(0.08),
                  splashColor: const Color(0xFF6200EE).withOpacity(0.12),
                  hoverColor: const Color(0xFF6200EE).withOpacity(0.04),
                  borderRadius: BorderRadius.circular(4.0),
                  constraints: const BoxConstraints(minHeight: 25.0),
                  isSelected: state,
                  onPressed: (index) {
                    // Respond to button selection
                    for (int i = 0; i < 3; i++) {
                      state[i] = (i == index);
                    }
                    onStateChanged(state);
                  },
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                        'WHITE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                        'COOL',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                        'WRAM',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ));
  }
}

const List<Color> colors = [
  Color(0xFFEEEEEE),
  Colors.amber,
  Colors.lime,
  Colors.cyan,
  Color(0xFFFFFFFF),
  Colors.deepOrange,
  Colors.green,
  Colors.blue,
];

class BlockColorPickerExample extends StatefulWidget {
  const BlockColorPickerExample({
    Key? key,
    required this.pickerColor,
    required this.onColorChanged,
    required this.colorHistory,
  }) : super(key: key);

  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;
  final List<Color> colorHistory;

  void colorChange(Color color) {
    _BlockColorPickerExampleState();
    onColorChanged(color);
  }

  @override
  State<BlockColorPickerExample> createState() =>
      _BlockColorPickerExampleState();
}

class _BlockColorPickerExampleState extends State<BlockColorPickerExample> {
  final int _portraitCrossAxisCount = 2;
  final int _landscapeCrossAxisCount = 4;
  final double _borderRadius = 30;
  final double _blurRadius = 5;
  final double _iconSize = 24;

  Widget pickerLayoutBuilder(
      BuildContext context, List<Color> colors, PickerItem child) {
    Orientation orientation = MediaQuery.of(context).orientation;

    return SizedBox(
      width: 280,
      // height: orientation == Orientation.portrait ? 280 : 280,
      child: GridView.count(
        crossAxisCount: orientation == Orientation.portrait
            ? _portraitCrossAxisCount
            : _landscapeCrossAxisCount,
        crossAxisSpacing: 3,
        mainAxisSpacing: 3,
        children: [for (Color color in colors) child(color)],
      ),
    );
  }

  Widget pickerItemBuilder(
      Color color, bool isCurrentColor, void Function() changeColor) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        color: color,
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.8),
              offset: const Offset(1, 2),
              blurRadius: _blurRadius)
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: changeColor,
          borderRadius: BorderRadius.circular(_borderRadius),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: isCurrentColor
                ? (colors.contains(widget.pickerColor) ? 1 : 0)
                : 0,
            child: Icon(
              Icons.done,
              size: _iconSize,
              color: useWhiteForeground(color) ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlockPicker(
        pickerColor: widget.pickerColor,
        onColorChanged: widget.onColorChanged,
        availableColors:
            widget.colorHistory.isNotEmpty ? widget.colorHistory : colors,
        layoutBuilder: pickerLayoutBuilder,
        itemBuilder: pickerItemBuilder,
      ),
    );
  }
}

class BlockColorPickerCycle extends StatefulWidget {
  BlockColorPickerCycle({
    Key? key,
    required this.pickerColor,
    required this.onColorChanged,
  }) : super(key: key);

  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;
  late Color setColor;

  @override
  State<BlockColorPickerCycle> createState() => _BlockColorPickerCycleState();
}

class _BlockColorPickerCycleState extends State<BlockColorPickerCycle> {
  @override
  void initState() {
    widget.setColor = widget.pickerColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleColorPicker(
          size: const Size(250, 250),
          controller: CircleColorPickerController(
            initialColor: widget.pickerColor,
          ),
          onChanged: (color) {
            setState(() {
              widget.setColor = color;
              widget.onColorChanged(color);
            });
          },
        ),
        SizedBox(
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    widget.onColorChanged(widget.pickerColor);
                    Navigator.pop(context, true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.pickerColor,
                    elevation: 10,
                  ),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.setColor,
                    elevation: 10,
                  ),
                  child: const Text("OK"),
                ),
              ],
            )),
      ],
    );
  }
}
