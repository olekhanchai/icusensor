import 'dart:async';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:icusensor/models/bluetoothid.dart';
import 'package:icusensor/widget/button_widget.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../utils/bluetooth_preferences.dart';

class BluetoothPage extends StatefulWidget {
  BluetoothPage({
    Key? key,
  }) : super(key: key);

  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
        child: Builder(
            builder: (context) => Scaffold(
                appBar: AppBar(
                  title: const Text('Bluetooth  Sensor'),
                ),
                body: LayoutBuilder(
                  builder: (builder, constraints) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Column(children: [
                          const Text(
                            'Sensor Model',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Image.asset(
                            'assets/images/bluetoothsensor.png',
                            scale: 1.6,
                          ),
                        ])),
                        Expanded(
                          child: StreamBuilder<BluetoothState>(
                              stream: FlutterBluePlus.instance.state,
                              initialData: BluetoothState.unknown,
                              builder: (c, snapshot) {
                                final state = snapshot.data;
                                if (state == BluetoothState.on) {
                                  return BluetoothListScreen();
                                }
                                return BluetoothOffScreen(state: state);
                              }),
                        ),
                      ],
                    );
                  },
                ))));
  }
}

class BluetoothListScreen extends StatefulWidget {
  BluetoothListScreen({
    Key? key,
  }) : super(key: key);

  @override
  _BluetoothListScreenState createState() => _BluetoothListScreenState();
}

class _BluetoothListScreenState extends State<BluetoothListScreen> {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  List<ScanResult> scanResultList = [];
  bool _isScanning = false;

  late bluetoothID bluetoothid;

  @override
  initState() {
    super.initState();
    bluetoothid = BluetoothPreferences.getBluetooth();
    initBle();
    scan();
  }

  void initBle() {
    flutterBlue.isScanning.listen((isScanning) {
      setState(() {
        _isScanning = isScanning;
      });
    });
  }

  scan() async {
    if (!_isScanning) {
      scanResultList.clear();
      flutterBlue.startScan(timeout: Duration(seconds: 10));
      flutterBlue.scanResults.listen((results) {
        scanResultList = results;
        setState(() {});
      });
    } else {
      flutterBlue.stopScan();
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Widget deviceSignal(ScanResult r) {
    return Text(r.rssi.toString());
  }

  Widget deviceMacAddress(ScanResult r) {
    return Text(r.device.id.id);
  }

  Widget deviceName(ScanResult r) {
    String name = '';
    if (r.device.name.isNotEmpty) {
      name = r.device.name;
    } else if (r.advertisementData.localName.isNotEmpty) {
      name = r.advertisementData.localName;
    } else {
      name = 'N/A';
    }
    return Text(name);
  }

  Widget leading(ScanResult r) {
    return const CircleAvatar(
      backgroundColor: Colors.cyan,
      child: Icon(
        Icons.bluetooth,
        color: Colors.white,
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Ok"),
      onPressed: () {
        bluetoothID bt = BluetoothPreferences.getBluetooth();
        BluetoothDevice.fromId(bt.id,
                name: bt.name, type: BluetoothDeviceType.values[bt.type])
            .disconnect();
        BluetoothPreferences.setBluetooth(bluetoothid);
        // BluetoothDevice.fromId(bluetoothid.id,  name: bluetoothid.name, type: BluetoothDeviceType.values[bluetoothid.type]).connect();
        Navigator.of(context).pop();
        scan();
        setState(() {});
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Disconnect : ${BluetoothPreferences.getBluetooth().name}"),
      content: const Text("Would you like to change bluetooth device?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void onTap(BuildContext context, ScanResult r) {
    bluetoothid = bluetoothid.copy(
        id: r.device.id.toString(),
        name: r.device.name,
        type: r.device.type.index);
    showAlertDialog(context);
  }

  Widget listItem(BuildContext context, ScanResult r) {
    return ListTile(
      onTap: () => onTap(context, r),
      leading: leading(r),
      title: deviceName(r),
      subtitle: deviceMacAddress(r),
      trailing: deviceSignal(r),
    );
  }

  // Widget TitleItem() {
  //   return ListTile(
  //     onTap: () {
  //       if (!_isScanning) {
  //         bluetoothID bt = BluetoothPreferences.getBluetooth();
  //         BluetoothDevice.fromId(bt.id,
  //                 name: bt.name, type: BluetoothDeviceType.values[bt.type])
  //             .disconnect();
  //       }
  //     },
  //     leading: Text("Bluetooth Devices"),
  //     title: Text("Disconnect"),
  //     subtitle: Text(
  //         'Bluetooth Devices : ${BluetoothPreferences.getBluetooth().name}'),
  //     trailing: Icon(Icons.close),
  //   );
  // }

  Widget scanItem() {
    return ListTile(
      onTap: () {
        if (!_isScanning) {
          scan();
        }
      },
      leading: const Text(""),
      title: _isScanning ? const Text("Searching") : const Text("Search"),
      subtitle: const Text(""),
      trailing: Icon(_isScanning ? Icons.stop : Icons.search),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: scanResultList.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Bluetooth Devices : ${BluetoothPreferences.getBluetooth().id} : ${BluetoothPreferences.getBluetooth().name}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        } else if (index <= scanResultList.length) {
          return listItem(context, scanResultList[index - 1]);
        } else {
          return scanItem();
        }
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, this.state}) : super(key: key);

  final BluetoothState? state;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Icon(
          Icons.bluetooth_disabled,
          size: 120.0,
          color: Colors.blue,
        ),
        Text(
          'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
          style: Theme.of(context)
              .primaryTextTheme
              .subtitle2
              ?.copyWith(color: Colors.blue),
        ),
        ElevatedButton(
            child: const Text('TURN ON'),
            onPressed: () => FlutterBluePlus.instance.turnOn()),
      ],
    );
  }
}
