import 'package:icusensor/controllers/MenuController.dart';
import 'package:icusensor/models/flspotdata.dart';
import 'package:icusensor/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:icusensor/page/system_page.dart';
import 'package:icusensor/page/setting_page.dart';
import 'package:icusensor/page/profile_page.dart';
import 'package:string_validator/string_validator.dart';
import '../../../constants.dart';
import 'package:icusensor/utils/user_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:icusensor/themes.dart';

class MyBar extends StatelessWidget {
  MyBar({
    required this.onScreenChanged,
    Key? key,
  }) : super(key: key);

  final ValueChanged<int> onScreenChanged;

  @override
  Widget build(BuildContext context) {
    var user = UserPreferences.getUser();
    var isDarkMode = user.isDarkMode;
    var icon = isDarkMode ? CupertinoIcons.sun_max : CupertinoIcons.moon_stars;

    return Container(
      height: 50,
      // color: Colors.red,
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Row(
                children: [
                  ThemeSwitcher(
                    builder: (context) => IconButton(
                      icon: Icon(icon),
                      onPressed: () {
                        user = UserPreferences.getUser();
                        isDarkMode = user.isDarkMode;
                        icon = isDarkMode
                            ? CupertinoIcons.sun_max
                            : CupertinoIcons.moon_stars;

                        final theme = isDarkMode
                            ? MyThemes.lightTheme
                            : MyThemes.darkTheme;
                        final switcher = ThemeSwitcher.of(context);
                        switcher.changeTheme(theme: theme);
                        final newUser = user.copy(isDarkMode: !isDarkMode);
                        UserPreferences.setUser(newUser);
                      },
                    ),
                  ),
                  Text(
                    "Dashboard",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              )),
          const SizedBox(
            width: defaultPadding,
          ),
          Expanded(
              flex: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const ButtonProfile(),
                  ButtonChart(
                    onScreenChanged: onScreenChanged,
                  ),
                  ButtonDiagram(
                    onScreenChanged: onScreenChanged,
                  ),
                  ButtonSystem(
                    onScreenChanged: onScreenChanged,
                  ),
                ],
              ))
        ],
      ),
    );
  }
}

class ButtonProfile extends StatelessWidget {
  const ButtonProfile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 156,
      child: ElevatedButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ProfilePage()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).canvasColor,
          elevation: 10,
        ),
        child: Row(
          children: [
            Icon(
              Icons.pages,
              color: Theme.of(context).dividerColor,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "Information",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).dividerColor),
            ),
          ],
        ),
      ),

      // const SizedBox(
      //   height: 5,
      //   child: Icon(Icons.keyboard_arrow_down),
      // )
    );
  }
}

class ButtonDiagram extends StatelessWidget {
  ButtonDiagram({
    required this.onScreenChanged,
    Key? key,
  }) : super(key: key);
  final ValueChanged<int> onScreenChanged;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 155,
      // color: Colors.red,
      child: ElevatedButton(
        onPressed: () {
          onScreenChanged(2);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).canvasColor,
          elevation: 10,
        ),
        child: Row(
          children: [
            Icon(
              Icons.pages,
              color: Theme.of(context).dividerColor,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "Diagrams",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).dividerColor),
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonChart extends StatelessWidget {
  ButtonChart({
    required this.onScreenChanged,
    Key? key,
  }) : super(key: key);
  final ValueChanged<int> onScreenChanged;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 155,
      child: ElevatedButton(
        onPressed: () {
          onScreenChanged(1);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).canvasColor,
          elevation: 10,
        ),
        child: Row(
          children: [
            Icon(
              Icons.pages,
              color: Theme.of(context).dividerColor,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "Charts",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).dividerColor),
            ),
          ],
        ),
      ),

      // const SizedBox(
      //   height: 5,
      //   child: Icon(Icons.keyboard_arrow_down),
      // )
    );
  }
}

class ButtonSystem extends StatelessWidget {
  ButtonSystem({
    required this.onScreenChanged,
    Key? key,
  }) : super(key: key);
  final ValueChanged<int> onScreenChanged;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 155,
      child: ElevatedButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => SettingPage()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).canvasColor,
          elevation: 10,
        ),
        child: Row(
          children: [
            Icon(
              Icons.pages,
              color: Theme.of(context).dividerColor,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "System",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).dividerColor),
            ),
          ],
        ),
      ),

      // const SizedBox(
      //   height: 5,
      //   child: Icon(Icons.keyboard_arrow_down),
      // )
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: Theme.of(context).canvasColor,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(defaultPadding * 0.75),
            margin: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: SvgPicture.asset("assets/icons/Search.svg"),
          ),
        ),
      ),
    );
  }
}
