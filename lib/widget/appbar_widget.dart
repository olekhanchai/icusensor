import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icusensor/themes.dart';
import 'package:icusensor/utils/user_preferences.dart';

AppBar buildAppBar(BuildContext context) {
  var user = UserPreferences.getUser();
  var isDarkMode = user.isDarkMode;
  var icon = isDarkMode ? CupertinoIcons.sun_max : CupertinoIcons.moon_stars;

  return AppBar(
    leading: BackButton(),
    backgroundColor: Colors.transparent,
    iconTheme: IconThemeData(),
    elevation: 0,
    actions: [],
  );
}
