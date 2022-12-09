import 'dart:io';

import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final bool isEdit;
  final VoidCallback onClicked;

  const ProfileWidget({
    Key? key,
    required this.imagePath,
    this.isEdit = false,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
        child: InkWell(
      onTap: onClicked,
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(color),
          ),
        ],
      ),
    ));
  }

  Widget buildImage() {
    // ImageProvider<Object> getCharacterAvatar(String url) {
    //   final image = Image.network(
    //     url,
    //     errorBuilder: (context, object, trace) {
    //       return Image(image: AssetImage('assets/images/logo.png'));
    //     },
    //   ).image;
    //   return image;
    // }

    // ImageProvider image;
    // if (imagePath.contains('https://')) {
    //   image = getCharacterAvatar(imagePath);
    // } else {
    //   image = FileImage(File(imagePath));
    // }
    final image = imagePath.contains('https://')
        ? NetworkImage(imagePath)
        : FileImage(File(imagePath));

    return ClipOval(
      child: Material(
          color: Colors.transparent,
          // child: Ink.image(
          //   image: image,
          //   fit: BoxFit.cover,
          //   width: 128,
          //   height: 128,
          //   child: InkWell(onTap: onClicked),
          // ),
          child: FadeInImage(
            image: image as ImageProvider,
            placeholder: AssetImage("assets/images/cats-and-dogs.jpg"),
            imageErrorBuilder: (context, error, stackTrace) {
              return Image.asset('assets/images/cats-and-dogs.jpg',
                  fit: BoxFit.fitWidth);
            },
            fit: BoxFit.fitWidth,
            width: 256,
            height: 256,
          )),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: Icon(
            isEdit ? Icons.add_a_photo : Icons.edit,
            color: Colors.white,
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
