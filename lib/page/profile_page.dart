import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:icusensor/models/user.dart';
import 'package:icusensor/page/edit_profile_page.dart';
import 'package:icusensor/utils/user_preferences.dart';
import 'package:icusensor/widget/appbar_widget.dart';
import 'package:icusensor/widget/button_widget.dart';
import 'package:icusensor/widget/numbers_widget.dart';
import 'package:icusensor/widget/profile_widget.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User user;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = UserPreferences.getUser();
    return ThemeSwitchingArea(
      child: Builder(
        builder: (context) => Scaffold(
          appBar: buildAppBar(context),
          body: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Row(
                children: [
                  Expanded(
                      // It takes 5/6 part of the screen
                      flex: 1,
                      child: Column(
                        children: [
                          ProfileWidget(
                            imagePath: user.imagePath,
                            onClicked: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => EditProfilePage()),
                              );
                              setState(() {});
                            },
                          ),
                        ],
                      )),
                  Expanded(
                      // It takes 5/6 part of the screen
                      flex: 1,
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          buildName(user),
                          const SizedBox(height: 24),
                          buildAbout(user),
                          const SizedBox(height: 24),
                          NumbersWidget(),
                        ],
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildName(User user) => Column(
        children: [
          Text(
            user.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildUpgradeButton() => ButtonWidget(
        text: 'Upgrade',
        onClicked: () {},
      );

  Widget buildAbout(User user) => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Medical and health information',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              user.about,
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );
}
