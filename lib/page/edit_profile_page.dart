import 'dart:io';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:icusensor/models/user.dart';
import 'package:icusensor/utils/user_preferences.dart';
import 'package:icusensor/widget/appbar_widget.dart';
import 'package:icusensor/widget/button_widget.dart';
import 'package:icusensor/widget/profile_widget.dart';
import 'package:icusensor/widget/textfield_widget.dart';
import 'package:path/path.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late User user;

  @override
  void initState() {
    super.initState();

    user = UserPreferences.getUser();
  }

  @override
  Widget build(BuildContext context) => ThemeSwitchingArea(
        child: Builder(
          builder: (context) => Scaffold(
            appBar: buildAppBar(context),
            body: ListView(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
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
                              isEdit: true,
                              onClicked: () async {
                                final image = await ImagePicker()
                                    .getImage(source: ImageSource.gallery);

                                if (image == null) return;

                                final directory =
                                    await getApplicationDocumentsDirectory();
                                final name = basename(image.path);
                                final imageFile =
                                    File('${directory.path}/$name');
                                final newImage =
                                    await File(image.path).copy(imageFile.path);

                                setState(() =>
                                    user = user.copy(imagePath: newImage.path));
                              },
                            ),
                          ],
                        )),
                    const SizedBox(width: 24),
                    Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            const SizedBox(height: 14),
                            TextFieldWidget(
                              label: 'Full Name',
                              text: user.name,
                              onChanged: (name) => user = user.copy(name: name),
                            ),
                            const SizedBox(height: 14),
                            TextFieldWidget(
                              label: 'Email',
                              text: user.email,
                              onChanged: (email) =>
                                  user = user.copy(email: email),
                            ),
                            const SizedBox(height: 24),
                            TextFieldWidget(
                              label: 'Medical and health information',
                              text: user.about,
                              maxLines: 5,
                              onChanged: (about) =>
                                  user = user.copy(about: about),
                            )
                          ],
                        ))
                  ],
                ),
                const SizedBox(height: 24),
                ButtonWidget(
                  text: 'Save',
                  onClicked: () {
                    UserPreferences.setUser(user);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ),
      );
}
