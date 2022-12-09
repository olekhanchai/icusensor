import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../constants.dart';

class MyTime extends StatelessWidget {
  const MyTime({
    Key? key,
    required this.timeString,
  }) : super(key: key);

  final String timeString;

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.red,
      // height: 40,
      margin: const EdgeInsets.only(top: defaultPadding),
      padding: const EdgeInsets.only(left: defaultPadding),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: primaryColor.withOpacity(0.15)),
        borderRadius: const BorderRadius.all(
          Radius.circular(defaultPadding),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 20,
            width: 20,
            child: SvgPicture.asset("assets/icons/media.svg"),
          ),
          Container(
            width: 180,
            // color: Colors.red,
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding * 0.5),
                child: Text(
                  timeString,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                )),
          )
        ],
      ),
    );
  }
}
