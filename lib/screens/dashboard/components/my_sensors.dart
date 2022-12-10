 
import 'package:icusensor/responsive.dart';
import 'package:flutter/material.dart';
import 'package:icusensor/models/MyFiles.dart';
import 'package:icusensor/screens/dashboard/components/sensor_info_ext.dart';
import 'package:icusensor/screens/dashboard/components/sensor_info_ext1.dart';
import '../../../constants.dart';
import 'sensor_info.dart';

class MySensor extends StatelessWidget {
  const MySensor({
    Key? key,
    required this.data,
    required this.onStatesChanged,
    required this.extdeviceName,
    required this.extdeviceId,
    required this.extdeviceType,
    required this.extonValueChanged,
    required this.extonClick,
  }) : super(key: key);

  final List<CloudSensorInfo> data;
  final ValueChanged<SensorStateChanged> onStatesChanged;

 
  final String extdeviceName;
  final String extdeviceId;
  final int extdeviceType;
  final ValueChanged<SensorExtChanged> extonValueChanged;
  final VoidCallback extonClick;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text(
        //       "My Files",
        //       style: Theme.of(context).textTheme.subtitle1,
        //     ),
        //     ElevatedButton.icon(
        //       style: TextButton.styleFrom(
        //         padding: EdgeInsets.symmetric(
        //           horizontal: defaultPadding * 1.5,
        //           vertical:
        //               defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
        //         ),
        //       ),
        //       onPressed: () {},
        //       icon: const Icon(Icons.add),
        //       label: const Text("Add New"),
        //     ),
        //   ],
        // ),
        // const SizedBox(height: defaultPadding),
        Responsive(
          mobile: FileInfoCardGridView(
            crossAxisCount: size.width < 650 ? 2 : 4,
            childAspectRatio: size.width < 650 ? 1.4 : 0.8,
            data: data,
            onStatesChanged: onStatesChanged,
            extdeviceName: extdeviceName,
            extdeviceId: extdeviceId,
            extdeviceType: extdeviceType,
            extonValueChanged: extonValueChanged,
            extonClick: extonClick,
          ),
          tablet: FileInfoCardGridView(
            data: data,
            onStatesChanged: onStatesChanged,
           extdeviceName: extdeviceName,
            extdeviceId: extdeviceId,
            extdeviceType: extdeviceType,
            extonValueChanged: extonValueChanged,
            extonClick: extonClick,
          ),
          desktop: FileInfoCardGridView(
            childAspectRatio: size.width < 1400 ? 1.1 : 1.4,
            data: data,
            onStatesChanged: onStatesChanged,
            extdeviceName: extdeviceName,
            extdeviceId: extdeviceId,
            extdeviceType: extdeviceType,
            extonValueChanged: extonValueChanged,
            extonClick: extonClick,
          ),
        ),
      ],
    );
  }
}

class FileInfoCardGridView extends StatelessWidget {
  const FileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 0.75,
    required this.data,
    required this.onStatesChanged,
    required this.extdeviceName,
    required this.extdeviceId,
    required this.extdeviceType,
    required this.extonValueChanged,
    required this.extonClick,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;
  final List<CloudSensorInfo> data;
  final ValueChanged<SensorStateChanged> onStatesChanged;

   final String extdeviceName;
  final String extdeviceId;
  final int extdeviceType;
  final ValueChanged<SensorExtChanged> extonValueChanged;
  final VoidCallback extonClick;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: data.length + 1,
    //  itemCount: data.length ,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => index < data.length
          ? SensorInfo(
              id: index,
              info: data[index],
              onStatesChanged: onStatesChanged,
            )
          : SensorInfoExternal1(
              deviceName: extdeviceName,
              deviceId: extdeviceId,
              deviceType: extdeviceType,
              onValueChanged: extonValueChanged,
              onClick: extonClick,
            ),
      // itemBuilder: (context, index) => 
      //      SensorInfo(
      //         id: index,
      //         info: data[index],
      //         onStatesChanged: onStatesChanged,
      //       )
           
    );
  }
}
