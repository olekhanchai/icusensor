import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:icusensor/models/flspotdata.dart';
import 'package:icusensor/widget/appbar_widget.dart';
import 'package:icusensor/widget/button_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../constants.dart';
import 'package:flutter_switch/flutter_switch.dart';

class SystemsPage extends StatefulWidget {
  SystemsPage({
    Key? key,
  }) : super(key: key);

  @override
  _SystemsPageState createState() => _SystemsPageState();
}

class _SystemsPageState extends State<SystemsPage> {
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
            padding: const EdgeInsets.all(defaultPadding * 2),
            physics: BouncingScrollPhysics(),
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Wifi",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        FlutterSwitch(
                          width: 105,
                          height: 40,
                          valueFontSize: 15.0,
                          toggleSize: 15.0,
                          value: true,
                          borderRadius: 30.0,
                          padding: 5.0,
                          showOnOff: true,
                          onToggle: (val) {},
                        ),
                      ]),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "IP Camera",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        FlutterSwitch(
                          width: 105,
                          height: 40,
                          valueFontSize: 15.0,
                          toggleSize: 15.0,
                          value: true,
                          borderRadius: 30.0,
                          padding: 5.0,
                          showOnOff: true,
                          onToggle: (val) {},
                        ),
                      ]),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Setting 1",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        FlutterSwitch(
                          width: 105,
                          height: 40,
                          valueFontSize: 15.0,
                          toggleSize: 15.0,
                          value: true,
                          borderRadius: 30.0,
                          padding: 5.0,
                          showOnOff: true,
                          onToggle: (val) {},
                        ),
                      ]),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Language",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        FlutterSwitch(
                          width: 105,
                          height: 40,
                          valueFontSize: 15.0,
                          toggleSize: 15.0,
                          value: true,
                          borderRadius: 30.0,
                          padding: 5.0,
                          showOnOff: true,
                          onToggle: (val) {},
                        ),
                      ]),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Filter reset",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        FlutterSwitch(
                          width: 105,
                          height: 40,
                          valueFontSize: 15.0,
                          toggleSize: 15.0,
                          value: true,
                          borderRadius: 30.0,
                          padding: 5.0,
                          showOnOff: true,
                          onToggle: (val) {},
                        ),
                      ]),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Factory Reset",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        ButtonWidget(
                          text: 'Reset',
                          onClicked: () {},
                        )
                      ]),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
