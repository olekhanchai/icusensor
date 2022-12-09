import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:icusensor/screens/dashboard/components/lightcolors.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:icusensor/utils/navigation.dart';
import 'package:app_settings/app_settings.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../widget/button_widget.dart';

class NetworkInfoPage extends StatefulWidget {
  const NetworkInfoPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<NetworkInfoPage> createState() => _NetworkInfoPageState();
}

class _NetworkInfoPageState extends State<NetworkInfoPage> {
  String _connectionStatus = 'Unknown';
  String _tetheringStatus = 'Unknown';
  final NetworkInfo _networkInfo = NetworkInfo();
  StreamSubscription? connection;
  bool isoffline = true;

  bool state = false;
  int sec = 0;
  late Timer _timer;

  void _changeData() {
    setState(() {
      sec++;
      //state = !state;
      if (sec < 3) {
        state = true;
      } else {
        state = false;
        sec = 0;
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void checkConnection(ConnectivityResult result) {
    {
      // whenevery connection status is changed.
      if (result == ConnectivityResult.none) {
        //there is no any connection
        setState(() {
          isoffline = true;
        });
      } else if (result == ConnectivityResult.wifi) {
        //connection is from wifi
        setState(() {
          isoffline = false;
        });
        // } else if (result == ConnectivityResult.mobile) {
        //   //connection is mobile data network
        //   setState(() {
        //     isoffline = false;
        //   });
        // } else if (result == ConnectivityResult.ethernet) {
        //   //connection is from wired connection
        //   setState(() {
        //     isoffline = false;
        //   });
        // } else if (result == ConnectivityResult.bluetooth) {
        //   //connection is from bluetooth threatening
        //   setState(() {
        //     isoffline = false;
        //   });
      }
    }
    if (!isoffline) {
      _initNetworkInfo();
      _scanNetwork();
    } else {
      _connectionStatus = "";
      _tetheringStatus = "";
    }
  }

  @override
  void initState() {
    super.initState();
    connection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) => checkConnection(result));

    _timer =
        Timer.periodic(const Duration(seconds: 1), (Timer t) => _changeData());
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
        child: Builder(
            builder: (context) => Scaffold(
                  appBar: AppBar(
                    title: const Text('Network Information'),
                  ),
                  body: Center(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Column(
                            children: [
                              const Text(
                                'Internet Connection',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    state
                                        ? 'assets/images/ex_wifi_on.png'
                                        : 'assets/images/ex_wifi_off.png',
                                    scale: 1.5,
                                  ),
                                  ButtonWidget(
                                    text: 'Open',
                                    onClicked: () {
                                      AppSettings.openWIFISettings();
                                    },
                                  ),
                                ],
                              ),
                              Icon(
                                isoffline
                                    ? Icons.wifi_off_sharp
                                    : Icons.signal_wifi_4_bar_sharp,
                                color: Colors.red[200],
                                size: 200,
                              ),
                              const SizedBox(height: 16),
                              Text(isoffline ? "" : _connectionStatus),
                            ],
                          )),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Text(
                                  'Ip camera connection',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      state
                                          ? 'assets/images/ex_ethernet_on.png'
                                          : 'assets/images/ex_ethernet_off.png',
                                      scale: 1.5,
                                    ),
                                    ButtonWidget(
                                      text: 'Open',
                                      onClicked: () {
                                        AppSettings.openHotspotSettings(
                                          asAnotherTask: true,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.settings_ethernet_outlined,
                                  color: Colors.red[200],
                                  size: 200,
                                ),
                                const SizedBox(height: 16),
                                Text(_tetheringStatus),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  )),
                )));
  }

  Future<void> _initNetworkInfo() async {
    String? wifiName,
        wifiBSSID,
        wifiIPv4,
        wifiIPv6,
        wifiGatewayIP,
        wifiBroadcast,
        wifiSubmask;

    try {
      // if (!kIsWeb && Platform.isIOS) {
      //   var status = await _networkInfo.getLocationServiceAuthorization();
      //   if (status == LocationAuthorizationStatus.notDetermined) {
      //     status = await _networkInfo.requestLocationServiceAuthorization();
      //   }
      //   if (status == LocationAuthorizationStatus.authorizedAlways ||
      //       status == LocationAuthorizationStatus.authorizedWhenInUse) {
      //     wifiName = await _networkInfo.getWifiName();
      //   } else {
      //     wifiName = await _networkInfo.getWifiName();
      //   }
      // } else {
      wifiName = await _networkInfo.getWifiName();
      //}
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi Name', error: e);
      wifiName = 'Failed to get Wifi Name';
    }

    try {
      // if (!kIsWeb && Platform.isIOS) {
      //   var status = await _networkInfo.getLocationServiceAuthorization();
      //   if (status == LocationAuthorizationStatus.notDetermined) {
      //     status = await _networkInfo.requestLocationServiceAuthorization();
      //   }
      //   if (status == LocationAuthorizationStatus.authorizedAlways ||
      //       status == LocationAuthorizationStatus.authorizedWhenInUse) {
      //     wifiBSSID = await _networkInfo.getWifiBSSID();
      //   } else {
      //     wifiBSSID = await _networkInfo.getWifiBSSID();
      //   }
      // } else {
      wifiBSSID = await _networkInfo.getWifiBSSID();
      // }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi BSSID', error: e);
      wifiBSSID = 'Failed to get Wifi BSSID';
    }

    try {
      wifiIPv4 = await _networkInfo.getWifiIP();
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi IPv4', error: e);
      wifiIPv4 = 'Failed to get Wifi IPv4';
    }

    try {
      if (!Platform.isWindows) {
        wifiIPv6 = await _networkInfo.getWifiIPv6();
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi IPv6', error: e);
      wifiIPv6 = 'Failed to get Wifi IPv6';
    }

    try {
      if (!Platform.isWindows) {
        wifiSubmask = await _networkInfo.getWifiSubmask();
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi submask address', error: e);
      wifiSubmask = 'Failed to get Wifi submask address';
    }

    try {
      if (!Platform.isWindows) {
        wifiBroadcast = await _networkInfo.getWifiBroadcast();
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi broadcast', error: e);
      wifiBroadcast = 'Failed to get Wifi broadcast';
    }

    try {
      if (!Platform.isWindows) {
        wifiGatewayIP = await _networkInfo.getWifiGatewayIP();
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi gateway address', error: e);
      wifiGatewayIP = 'Failed to get Wifi gateway address';
    }

    setState(() {
      _connectionStatus = 'Wifi Name: $wifiName\n'
          'Wifi BSSID: $wifiBSSID\n'
          'Wifi IPv4: $wifiIPv4\n'
          'Wifi IPv6: $wifiIPv6\n'
          'Wifi Broadcast: $wifiBroadcast\n'
          'Wifi Gateway: $wifiGatewayIP\n'
          'Wifi Submask: $wifiSubmask\n';
    });
  }

  Future<void> _scanNetwork() async {
    try {
      await (_networkInfo.getWifiIP()).then(
        (ip) async {
          final String subnet = ip!.substring(0, ip.lastIndexOf('.'));
          const port = 22;
          for (var i = 0; i < 256; i++) {
            String ip = '$subnet.$i';
            await Socket.connect(ip, port, timeout: Duration(milliseconds: 50))
                .then((socket) async {
              await InternetAddress(socket.address.address)
                  .reverse()
                  .then((value) {
                setState(() {
                  _tetheringStatus = ('value.host : ${value.host}');
                  _tetheringStatus +=
                      ('socket.address :${socket.address.address}');
                });
              }).catchError((error) {
                setState(() {
                  _tetheringStatus =
                      ('socket.address :${socket.address.address}');
                  _tetheringStatus += ('Error: $error');
                });
              });
              socket.destroy();
            }).catchError((error) => null);
          }
        },
      );
    } on PlatformException catch (e) {
      //   developer.log('Failed to get Local  gateway address', error: e);
      _tetheringStatus = 'Failed to get local gateway address';
    }
    //print('Done');
  }
}
