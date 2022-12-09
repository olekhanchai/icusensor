import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:icusensor/models/user.dart';
import 'package:icusensor/page/edit_profile_page.dart';
import 'package:icusensor/utils/user_preferences.dart';
import 'package:icusensor/widget/appbar_widget.dart';
import 'package:icusensor/widget/button_widget.dart';
import 'package:icusensor/widget/numbers_widget.dart';
import 'package:icusensor/widget/profile_widget.dart';

import '../screens/dashboard/components/camerastream.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
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
            physics: const BouncingScrollPhysics(),
            children: [
              CameraStream(
                isFullScreen: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}
