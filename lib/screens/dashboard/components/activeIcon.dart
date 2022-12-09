import 'package:flutter/material.dart';
import 'dart:async';

class ActivateIcon extends StatefulWidget {
  const ActivateIcon({
    Key? key,
    required this.width,
    required this.height,
    required this.enable,
    required this.enablecolor,
    required this.disablecolor,
  }) : super(key: key);

  final double width;
  final double height;
  final bool enable;
  final Color enablecolor;
  final Color disablecolor;

  @override
  State<ActivateIcon> createState() => _ActivateIconState();
}

class _ActivateIconState extends State<ActivateIcon>
    with SingleTickerProviderStateMixin {
  final BorderRadiusGeometry borderRadius = BorderRadius.circular(8);

  late double _width = widget.width;
  late double _height = widget.height;
  bool state = false;
  late Timer _timer;

  void _changeData() {
    setState(() {
      if (state) {
        _width = widget.width;
        _height = widget.height;
      } else {
        _width = 5;
        _height = 5;
      }
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
        SizedBox(
          width: widget.width,
        ),
        widget.enable
            ? Container(
                width: widget.width,
                height: widget.height,
                // color: Colors.red,
                alignment: Alignment.center,
                child: AnimatedContainer(
                  // Use the properties stored in the State class.
                  width: _width,
                  height: _height,
                  decoration: BoxDecoration(
                    color: widget.enablecolor,
                    borderRadius: borderRadius,
                  ),
                  // Define how long the animation should take.
                  duration: const Duration(seconds: 1),
                  // Provide an optional curve to make the animation feel smoother.
                  curve: Curves.fastOutSlowIn,
                ),
              )
            : Container(
                width: widget.width,
                height: widget.height,
                color: widget.disablecolor,
              )
      ],
    );
  }
}
