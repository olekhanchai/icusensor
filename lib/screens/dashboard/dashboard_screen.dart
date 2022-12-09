import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:icusensor/events/TempVal.dart';
import 'package:icusensor/events/UartValues.dart';
import 'package:icusensor/screens/dashboard/components/header.dart';
import 'package:icusensor/responsive.dart';
import 'package:icusensor/screens/dashboard/components/my_sensors.dart';
import 'package:flutter/material.dart';
import 'package:icusensor/screens/dashboard/sensor_chart.dart';
import 'package:icusensor/screens/dashboard/sensor_diagram.dart';
import 'package:icusensor/utils/bluetooth_preferences.dart';
import 'package:event_bus/event_bus.dart';
import 'package:string_validator/string_validator.dart';

import '../../constants.dart';

import 'dart:async';
import 'dart:math';
import 'package:intl/intl.dart';

//import 'components/recent_files.dart';
import '../../models/bluetoothid.dart';
import '../../page/bluetooth_page.dart';
import '../../page/cam_page.dart';
import '../../events/ValCo2Event.dart';
import '../../firebase_options.dart';
import '../../models/Setting.dart';
import 'components/temperature_details.dart';
//import 'components/camera.dart';
//import 'components/camerastream.dart';
import 'components/camera.dart';
import 'components/camerastream.dart';
import 'components/lightcolors.dart';
import 'components/modules.dart';
import 'package:icusensor/models/MyFiles.dart';
import 'components/times.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';

import 'package:icusensor/models/flspotdata.dart';
import 'package:app_settings/app_settings.dart';


@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await setupFlutterNotifications();
  showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Handling a background message ${message.messageId}');
}


bool isFlutterLocalNotificationsInitialized = false;

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'test', // id
    'test', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: 'launch_background',
        ),
      ),
    );
  }
}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;


class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen>
    with WidgetsBindingObserver {
  AppLifecycleState? _notification;

  static const MethodChannel methodChannel =
      MethodChannel('icusensor.odroidm1.io/thingsio');
  static const EventChannel eventCallback =
  static const EventChannel eventChannel =
      EventChannel('icusensor.odroidm1.io/thingscallback');

  late StreamSubscription eventSubscription;

  final List<String> strStates = [
    "Unknow",
    "Initial",
    "Connected",
    "Disconect"
  ];
  int ioState = 0;
  int screenIndex = 0;
  String strState = "";

  List<String> modulenames = ["IRONIZE", "NEBULIZ", "UVC", "INFARED"];
  List<bool> moduleStates = [false, false, false, false];
  List<int> moduleTimers = [0, 0, 0, 0];
  List<int> moduleElaps = [0, 0, 0, 0];
  int moduleSelect = 0;
  static List<int> minTarget = [10, 400, 0, 0];
  static List<int> maxTarget = [100, 2000, 100, 10000];
  static List<int> stepTarget = [1, 100, 1, 1000];

  static List<int> minValue = [0, 0, 0, 0];
  static List<int> maxValue = [100, 10000, 100, 10000];

  int icount = 0;
  double o2Sum = 0;
  double co2Sum = 0;
  double humiditySum = 0;
  //double dSum = 0;

  bool isready = false;
  int callCount = 0;
  int doneCount = 0;

  double tempcurrentLevel = 25;
  double tempcurrentTemp = 25;
  double tempcurrentTarget = 25;
  String tempcurrentThermals = "";
  double tempminTarget = 18;
  double tempmaxTarget = 45;
  int tempFanSpeed = 1;
  bool tempIsEnable = false;
  bool tempMode = false;
  bool tempUnit = false;
  bool tempIson = false;
  double tempGain = 0;
  double tempOffset = 0;
  double tempHysteresis = 0;
  bool tempInvert = false;
  String tempcurrentTime = "";
  Stream<String> _thingStream = const Stream.empty();
  EventBus eventBus = EventBus();

  Stream<String> thingStream() {
    _thingStream =
        eventChannel.receiveBroadcastStream().map<String>((value) => value);
    return _thingStream;
  }

  // final Future<FirebaseApp> firebase = Firebase.initializeApp();
  // final CollectionReference _chamberSettings = FirebaseFirestore.instance.collection("Setting");
  
  static List<FlSpot> datas = [
    const FlSpot(0, 0),
    const FlSpot(1, 0),
    const FlSpot(2, 0),
    const FlSpot(3, 0),
    const FlSpot(4, 0),
    const FlSpot(5, 0),
    const FlSpot(6, 0),
  ];

  List<FlSpot> dataO2 = [
    const FlSpot(0, 0),
    const FlSpot(1, 0),
    const FlSpot(2, 0),
    const FlSpot(3, 0),
    const FlSpot(4, 0),
    const FlSpot(5, 0),
    const FlSpot(6, 0),
  ];
  List<FlSpot> dataCo2 = [
    const FlSpot(0, 0),
    const FlSpot(1, 0),
    const FlSpot(2, 0),
    const FlSpot(3, 0),
    const FlSpot(4, 0),
    const FlSpot(5, 0),
    const FlSpot(6, 0),
  ];
  List<FlSpot> dataHumidity = [
    const FlSpot(0, 0),
    const FlSpot(1, 0),
    const FlSpot(2, 0),
    const FlSpot(3, 0),
    const FlSpot(4, 0),
    const FlSpot(5, 0),
    const FlSpot(6, 0),
  ];
  List<FlSpot> dataPM = [
    const FlSpot(0, 0),
    const FlSpot(1, 0),
    const FlSpot(2, 0),
    const FlSpot(3, 0),
    const FlSpot(4, 0),
    const FlSpot(5, 0),
    const FlSpot(6, 0),
  ];

  CloudSensorInfo o2Data = CloudSensorInfo(
    displayOnly: false,
    value: 20,
    valuemin: minValue[0],
    valuemax: maxValue[0],
    state: 0,
    target: 25,
    targetmin: minTarget[0],
    targetmax: maxTarget[0],
    timer: 0,
    elaps: 0,
    ison: false,
    gain: 1,
    offset: 0,
    hysteresis: 0,
    inv: false,
    limitdir: -1,
    digit: 1,
    title: "Oxygen",
    unit: "%",
    svgSrc: "assets/icons/oxygen.svg",
    color: primaryColor,
    data: datas,
  );
  CloudSensorInfo co2Data = CloudSensorInfo(
    displayOnly: false,
    value: 450,
    valuemin: minValue[1],
    valuemax: maxValue[1],
    state: 0,
    target: 800,
    targetmin: minTarget[1],
    targetmax: maxTarget[1],
    timer: 0,
    elaps: 0,
    ison: false,
    gain: 1,
    offset: 0,
    hysteresis: 0,
    inv: false,
    limitdir: 1,
    digit: 0,
    title: "Carbondioxide",
    unit: "ppm",
    svgSrc: "assets/icons/co2.svg",
    color: const Color(0xFFFFA113),
    data: datas,
  );
  CloudSensorInfo humidityData = CloudSensorInfo(
    displayOnly: false,
    value: 60,
    valuemin: minValue[2],
    valuemax: maxValue[2],
    state: 0,
    target: 50,
    targetmin: minTarget[2],
    targetmax: maxTarget[2],
    timer: 0,
    elaps: 0,
    ison: false,
    gain: 1,
    offset: 0,
    hysteresis: 0,
    inv: false,
    limitdir: 0,
    digit: 1,
    title: "Humidity",
    unit: "%",
    svgSrc: "assets/icons/humidity.svg",
    color: const Color(0xFFA4CDFF),
    data: datas,
  );
  CloudSensorInfo s3 = CloudSensorInfo(
    displayOnly: true,
    value: 500,
    valuemin: minValue[3],
    valuemax: maxValue[3],
    state: 0,
    target: 1000,
    targetmin: minTarget[3],
    targetmax: maxTarget[3],
    timer: 0,
    elaps: 0,
    ison: false,
    gain: 1,
    offset: 0,
    hysteresis: 0,
    inv: false,
    limitdir: 1,
    digit: 0,
    title: "",
    unit: "",
    svgSrc: "assets/icons/google_drive.svg",
    color: const Color(0xFF007EE5),
    data: datas,
  );

  late FlSpotdata flspotvalues;
  late List<FlSpot> data0;
  late List<FlSpot> data1;
  late List<FlSpot> data2;
  late List<FlSpot> data3;
  late List<FlSpot> data4;

  late bluetoothID bluetootid;
  double extTemperature = 0;
  double extHumidity = 0;
  double extBattery = 0;

  bool lightonoff = false;
  List<bool> lightselect = [false, false, false];
  double lightlevel = 0;
  Color lightcolor = Colors.red;

  // late StreamSubscription eventSubscription = eventBus.on<UartValuesEvent>().listen((event) {
  //     setState(() {
  //       tempcurrentLevel = double.parse(event.temp.substring(1,2));
  //     });
  //     print("========================= in set state temp "+event.temp);
  //   });

// Returns a float value (as a double) that approximates the double.
  double roundableFloat(double doubleValue, int fractionalDigits) {
    return double.parse((doubleValue).toStringAsFixed(fractionalDigits));

    // var target = doubleValue.toStringAsFixed(fractionalDigits);
    // var buffer = Float32List(1);
    // buffer[0] = doubleValue;
    // var rounded = buffer[0];
    // var result = rounded.toStringAsFixed(fractionalDigits);
    // if (result != target) {
    //   // Assume same endianness for floats and integers.
    //   // Not always true on ARM, so more cleverness might be needed.
    //   buffer.buffer.asUint32List()[0] += rounded < doubleValue ? 1 : -1;
    //   rounded = buffer[0];
    // }
    // return rounded;

    // int 16  print(bd.getUint16(1, Endian.little)); // print the first short
    // int 16 print(bd.getUint16(3, Endian.little)); // and the second
    //double print(bd.getFloat32(5, Endian.little)); // and the third
    // int stringLength = input[7]; // get the length of the string
    // print(utf8.decode(input.sublist(8, 8 + stringLength))); // decode the string
    // final data = [125, 29, 2, 64];
    // final bytes = Uint8List.fromList(data);
    // final byteData = ByteData.sublistView(bytes);
    // double value = byteData.getFloat32(0,Endian.little);
    // print(value); // 2.0330498218536377
  }

  Uint8List roundableFloatto4Byte(double doubleValue, int fractionalDigits) {
    var valueFloat = Float32List(1);
    valueFloat[0] = roundableFloat(doubleValue, fractionalDigits);
    return valueFloat.buffer.asUint8List();
  }

  int fanO2 = 0;
  int fanHumi = 0;

  double thermal0 = 0;
  double thermal1 = 0;
  double thermal2 = 0;
  double thermal3 = 0;

  dynamic parseType(String input) {
    if (isNumeric(input) && input.contains(".")) {
      return double.parse(input);
    } else if (isNumeric(input)) {
      return int.parse(input);
    }
  }

  void updateioState() {
    setState(() {
      strState = strStates[ioState];
    });
  }

  void sentUartData(String input) {
    input += " Z101\n";
    //input += " M500\n";
    sentonlyUartData(input);
    setState(() {});
    //sentrecieveUartData(input);
  }

  Future<void> sentonlyUartData(String input) async {
    String status;
    try {
      //  await methodChannel.invokeMethod('UartSend', input);
    } on PlatformException catch (e) {
      if (e.code == 'NO_SERIAL') {
        status = 'No SERIAL.';
      } else {
        status = 'Failed to get io status.';
      }
    }
  }

  // Future<void> sentrecieveUartData(String input) async {
  //   setState(() {
  //     callCount++;
  //   });
  //   var result = await methodChannel.invokeMethod('UartSendRecieve', input);
  //   getUartValue(result);
  //   setState(() {
  //     doneCount++;
  //   });
  // }

  void onCallbackEvent(dynamic data) {
//    getUartValue(data);
    ioState = 2;
  }

  void onCallbackError(Object e) {
    ioState = 0;
  }

  void tempEnableChanged(bool state) {
    setState(() => tempIsEnable = state);
    String cmd = "D10 S${tempIsEnable ? 1 : 0}\n";
    sentUartData(cmd);
  }

  void tempTragetTemperatureMinus(double currentTraget) {
    if (currentTraget > tempminTarget) {
      setState(() => tempcurrentTarget = currentTraget - 1.0);
      String cmd = "C10 T${tempcurrentTarget.toStringAsFixed(2)}\n";
      sentUartData(cmd);
    }
  }

  void tempTragetTemperaturePlus(double currentTraget) {
    if (currentTraget < tempmaxTarget) {
      setState(() => tempcurrentTarget = currentTraget + 1.0);
      String cmd = "C10 T${tempcurrentTarget.toStringAsFixed(2)}\n";
      sentUartData(cmd);
    }
  }

  void tempFanSpeedChanged(int level) {
    setState(() => tempFanSpeed = level);
    String cmd = "G10 T${((tempFanSpeed + 1) * (255 / 5)).toInt()}\n";
    sentUartData(cmd);
  }

  void tempUnitChanged(bool state) {
    setState(() => tempUnit = state);
    String cmd = "D10 N${tempUnit ? 1 : 0}\n";
    sentUartData(cmd);
  }

  void tempModeChanged(bool state) {
    setState(() => tempMode = state);
    String cmd = "D10 M${tempMode ? 1 : 0}\n";
    sentUartData(cmd);
  }

  void lightset(bool onoff) {
    setState(() => lightonoff = onoff);
    String cmd = "E10 S${lightonoff ? 1 : 0}\n";
    sentUartData(cmd);
  }

  void lightmode(List<bool> selectmode) {
    setState(() => lightselect = selectmode);
    bool M, N;
    if (lightselect[0]) {
      M = false;
      N = false;
    } else if (lightselect[1]) {
      M = true;
      N = false;
    } else if (lightselect[2]) {
      M = true;
      N = true;
    } else {
      M = false;
      N = true;
    }
    String cmd = "E10 M${M ? 1 : 0} N${N ? 1 : 0}\n";
    sentUartData(cmd);
  }

  void lightColor(Color color) {
    setState(() => lightcolor = color);
    setState(() => lightselect = [false, false, false]);
    String cmd =
        "F10 R${lightcolor.red} G${lightcolor.green} B${lightcolor.blue}\n";
    cmd += "E10 M${0} N${1}\n";
    sentUartData(cmd);
  }

  void lightbrightness(double level) {
    setState(() => lightlevel = level);
    String cmd = "F10 I${((lightlevel + 1) * (255 / 5)).toInt()}\n";
    sentUartData(cmd);
  }

  void changeModuleStates(List<bool> states) {
    setState(() => moduleStates = states);
    String cmd = "E13 S${moduleStates[0] ? 1 : 0}\n";
    cmd += "E12 S${moduleStates[1] ? 1 : 0}\n";
    cmd += "E11 S${moduleStates[2] ? 1 : 0}\n";
    sentUartData(cmd);
  }

  void changeModuleTimers(List<int> timer) {
    setState(() => moduleTimers = timer);
    String cmd = "E13 T${moduleTimers[0]} \n";
    cmd += "E12 T${moduleTimers[1]}\n";
    cmd += "E11 T${moduleTimers[2]}\n";
    sentUartData(cmd);
  }

  void changeModuleSelect(int module) {
    setState(() => moduleSelect = module);
  }

  void onstatesChanged(SensorStateChanged mstate) {
    setState(() => {demoMyFiles[mstate.id].state = mstate.state});
    String cmd;
    String strID = "";
    if (mstate.id == 0) {
      strID = "11";
    } else if (mstate.id == 1) {
      strID = "12";
    } else if (mstate.id == 2) {
      strID = "13";
    } else if (mstate.id == 3) {
      strID = "14";
    }

    cmd = "D$strID S${demoMyFiles[mstate.id].state}\n";
    if (mstate.state == 3) {
      if ((demoMyFiles[mstate.id].timer < 15) & (mstate.dir == 1)) {
        setState(() => {demoMyFiles[mstate.id].timer++});
      } else if ((demoMyFiles[mstate.id].timer > 0) & (mstate.dir == -1)) {
        setState(() => {demoMyFiles[mstate.id].timer--});
      }
      cmd += "D$strID T${demoMyFiles[mstate.id].timer}\n";
    }
    if (mstate.state == 2) {
      if ((demoMyFiles[mstate.id].target < maxTarget[mstate.id]) &
          (mstate.dir == 1)) {
        setState(
            () => {demoMyFiles[mstate.id].target += stepTarget[mstate.id]});
      } else if ((demoMyFiles[mstate.id].target > minTarget[mstate.id]) &
          (mstate.dir == -1)) {
        setState(
            () => {demoMyFiles[mstate.id].target -= stepTarget[mstate.id]});
      }
      cmd += "C$strID T${demoMyFiles[mstate.id].target}\n";
    }
    sentUartData(cmd);
  }

  void bluetoothDataChange(SensorExtChanged data) {
    extTemperature = data.temperature;
    extHumidity = data.humidity;
    extBattery = data.bettery;
  }

  void bluetoothSetting() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => BluetoothPage()),
    );
    setState(() {
      
    });
  }

  void cameraFullscreen() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => CameraPage()),
    );
  }

  void setScreen(int states) {
    setState(() => screenIndex = states);
  }

  void genDataDemo(bool init) {
    if (init) {
      data0 = List.generate(30, (index) {
        return FlSpot(index.toDouble(), Random().nextDouble() * 100);
      });
      data1 = List.generate(30, (index) {
        return FlSpot(index.toDouble(), Random().nextDouble() * 100);
      });
      data2 = List.generate(30, (index) {
        return FlSpot(index.toDouble(), Random().nextDouble() * 1000);
      });
      data3 = List.generate(30, (index) {
        return FlSpot(index.toDouble(), Random().nextDouble() * 100);
      });
      data4 = List.generate(30, (index) {
        return FlSpot(index.toDouble(), Random().nextDouble() * 1000);
      });
    } else {
      for (int i = 0; i < 30 - 1; i++) {
        data0[i] = FlSpot(data0[i].x, data0[i + 1].y);
        data1[i] = FlSpot(data1[i].x, data1[i + 1].y);
        data2[i] = FlSpot(data2[i].x, data2[i + 1].y);
        data3[i] = FlSpot(data3[i].x, data3[i + 1].y);
        data4[i] = FlSpot(data4[i].x, data4[i + 1].y);
      }
      data0[29] = FlSpot(29, Random().nextDouble() * 100);
      data1[29] = FlSpot(29, Random().nextDouble() * 100);
      data2[29] = FlSpot(29, Random().nextDouble() * 1000);
      data3[29] = FlSpot(29, Random().nextDouble() * 100);
      data4[29] = FlSpot(29, Random().nextDouble() * 1000);
    }
    flspotvalues = FlSpotdata(
        value0: data0,
        value1: data1,
        value2: data2,
        value3: data3,
        value4: data4);
  }

  void genData() {
    data0 = List.generate(30, (index) {
      return FlSpot(index.toDouble(), 0);
    });
    data1 = List.generate(30, (index) {
      return FlSpot(index.toDouble(), 0);
    });
    data2 = List.generate(30, (index) {
      return FlSpot(index.toDouble(), 0);
    });
    data3 = List.generate(30, (index) {
      return FlSpot(index.toDouble(), 0);
    });
    data4 = List.generate(30, (index) {
      return FlSpot(index.toDouble(), 0);
    });
  }

  void getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime =
        DateFormat('MM/dd/yyyy hh:mm:ss').format(now);
    setState(() {
      tempcurrentTime = formattedDateTime;
    });
    if ((now.second % 2) == 0) {
      sentUartData("");
      updateioState();
    }
  }

  List<CloudSensorInfo> demoMyFiles = [];

  void Clossing() {
    // eventSubscription.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // eventSubscription = eventCallback
        //     .receiveBroadcastStream("Start")
        //     .listen(onCallbackEvent, onError: onCallbackError);
        print("app in resumed");
        break;
      case AppLifecycleState.inactive:
        //   Clossing();
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        //     Clossing();
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        //     Clossing();
        print("app in detached");
        break;
    }
  }

   Future<void> updateToCloud(String field, String value) async {
    try {
        final post = await FirebaseFirestore.instance
            .collection('ChamberSetting')
            .where('ip', isEqualTo: '192.168.1.99')
            .limit(1)
            .get()
            .then((QuerySnapshot snapshot) {
                //Here we get the document reference and return to the post variable.
                return snapshot.docs[0].reference;
            });

        var batch = FirebaseFirestore.instance.batch();
        //Updates the field value, using post as document reference
        batch.update(post, { field: value }); 
        batch.commit();
        
    } catch (e) {
        print(e);
    }
    //  await _chamberSettings.add({
    //     "gainChamber":input.gainChamber,
    //     "offsetChamber":input.offsetChamber,
    //     "gainO2":input.gainO2,
    //     "offsetO2":input.offsetO2,
    //     "gainCo2":input.gainCo2,
    //     "offsetCo2":input.offsetCo2,
    //     "gainHumidit":input.gainHumidit,
    //     "offsetHumidity":input.offsetHumidity,
    //     "temp":input.temp,
    //     "targetTemp":input.targetTemp,
    //     "hystersisTemp":input.hystersisTemp,
    //     "o2":input.o2,
    //     "targetO2":input.targetO2,
    //     "hystersisO2":input.hystersisO2,
    //     "co2":input.co2,
    //     "targetCO2":input.targetCO2,
    //     "hystersisCO2":input.hystersisCO2,
    //     "humi":input.humi,
    //     "targetHumi":input.targetHumi,
    //     "hystersisHumi":input.hystersisHumi,
    //     "tempState":input.tempState,
    //     "tempTimer":input.tempTimer,
    //     "tempMode1":input.tempMode1,
    //     "tempMode2":input.tempMode2,
    //     "tempElaps":input.tempElaps,
    //     "tempPWM":input.tempPWM,
    //     "tempInverting":input.tempInverting,
    //     "o2State":input.o2State,
    //     "o2Timer":input.o2Timer,
    //     "o2Mode1":input.o2Mode1,
    //     "o2Mode2":input.o2Mode2,
    //     "o2Elaps":input.o2Elaps,
    //     "o2PWM":input.o2PWM,
    //     "o2Inverting":input.o2Inverting,
    //     "co2State":input.co2State,
    //     "co2Timer":input.co2Timer,
    //     "co2Mode1":input.co2Mode1,
    //     "co2Mode2":input.co2Mode2,
    //     "co2Elaps":input.co2Elaps,
    //     "co2PWM":input.co2PWM,
    //     "co2Inverting":input.co2Inverting,
    //     "humiState":input.humiState,
    //     "humiTimer":input.humiTimer,
    //     "humiMode1":input.humiMode1,
    //     "humiMode2":input.humiMode2,
    //     "humiElaps":input.humiElaps,
    //     "humiPWM":input.humiPWM,
    //     "humiInverting":input.humiInverting,
    //     "lightState":input.lightState,
    //     "lightTimer":input.lightTimer,
    //     "lightMode1":input.lightMode1,
    //     "lightMode2":input.lightMode2,
    //     "lightElaps":input.lightElaps,
    //     "uvcState":input.uvcState,
    //     "uvcTimer":input.uvcTimer,
    //     "uvcMode1":input.uvcMode1,
    //     "uvcMode2":input.uvcMode2,
    //     "uvcElaps":input.uvcElaps,
    //     "nebuState":input.nebuState,
    //     "nebuTimer":input.nebuTimer,
    //     "nebuMode1":input.nebuMode1,
    //     "nebuMode2":input.nebuMode2,
    //     "nebuElaps":input.nebuElaps,
    //     "ironState":input.ironState,
    //     "ironTimer":input.ironTimer,
    //     "ironMode1":input.ironMode1,
    //     "ironMode2":input.ironMode2,
    //     "ironElaps":input.ironElaps,
    //     "red":input.red,
    //     "green":input.green,
    //     "blue":input.blue,
    //     "bright":input.bright,
    //     "tempFan":input.tempFan,
    //     "o2Fan":input.o2Fan,
    //     "humiFan":input.humiFan,
    //     "hotEnd1":input.hotEnd1,
    //     "hotEnd2":input.hotEnd2,
    //     "hotEnd3":input.hotEnd3,
    //     "hotEnd4":input.hotEnd4
    //  });
   }

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    String? _token;
    String? initialMessage;
    bool _resolved = false;

    FirebaseMessaging.instance.getInitialMessage().then(
            (value) => setState(
              () {
                _resolved = true;
                initialMessage = value?.data.toString();
              },
            ),
          );

      FirebaseMessaging.instance.subscribeToTopic("test");

      FirebaseMessaging.onMessage.listen(showFlutterNotification);

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('A new onMessageOpenedApp event was published!');
        Navigator.pushNamed(
          context,
          '/test',
          arguments: MessageArguments(message, true),
        );
      });


    WidgetsBinding.instance?.addObserver(this);
    demoMyFiles = [
      o2Data,
      co2Data,
      humidityData,
      s3,
    ];

    Map<String, dynamic> data;
    ioState = 0;
    genData();
    screenIndex = 0;
    Timer.periodic(const Duration(seconds: 1), (Timer t) => getTime());

    eventBus.on<TempValEvent>().listen((event) {
      setState(() {
        try {
          tempcurrentTarget = double.parse(event.data);
          updateToCloud('TempVal',event.data);
        } on PlatformException catch (e) {}
      });
    });

    eventBus.on<ValCo2Event>().listen((event) {
      setState(() {
        try {
          demoMyFiles[1].value = double.parse(event.data);
        } on PlatformException catch (e) {}
      });
    });

    eventBus.on<UartValuesEvent>().listen((event) {
      if (event.data.isNotEmpty) {
        data = jsonDecode(event.data);

        if (data.keys.contains("Temp")) {
          eventBus.fire(TempValEvent(data["Temp"]));
        }
      }
    });
  }

  @override
  void deactivate() {
    super.deactivate();
    Clossing();
    WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    Clossing();
    WidgetsBinding.instance?.removeObserver(this);
  }   

  @override
  Widget build(BuildContext context) {
 
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: ((context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
              appBar: AppBar(title: const Text("Error")),
              body: Center(child: Text("${snapshot.error}")));
        }
          return SafeArea(
            child: SingleChildScrollView(
              //Container( //SingleChildScrollView
              //primary: false,
              // height: 585,
              padding: const EdgeInsets.all(defaultPadding * 0.2),
              child: Column(
                children: [
                  if (screenIndex == 0)
                    Column(
                      children: [
                        MyBar(
                          onScreenChanged: setScreen,
                        ),
                        Row(
                          children: [
                            // On Mobile means if the screen is less than 850 we dont want to show it
                            if (!Responsive.isMobile(context))
                              Expanded(
                                  flex: 2,
                                  child: Container(
                                      height: 500,
                                      // color: Colors.orange,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          TemperatureDetails(
                                            isEnable: tempIsEnable,
                                            currentTemperature: tempcurrentTemp,
                                            currentMin: 18,
                                            currentMax: 45,
                                            tragetTemperature:
                                                tempcurrentTarget,
                                            cuurentTime: tempcurrentTime,
                                            currentFanSpeed: tempFanSpeed,
                                            currentMode: tempMode,
                                            currentUnit: tempUnit,
                                            currentIson: tempIson,
                                            currentThermals:
                                                tempcurrentThermals,
                                            onEnableChanged: tempEnableChanged,
                                            onTragetTemperatureChangedMinus:
                                                tempTragetTemperatureMinus,
                                            onTragetTemperatureChangedPluse:
                                                tempTragetTemperaturePlus,
                                            onFanSpeedChanged:
                                                tempFanSpeedChanged,
                                            onModeChanged: tempModeChanged,
                                            onUnitChanged: tempUnitChanged,
                                          ),
                                        ],
                                      ))),
                            if (!Responsive.isMobile(context))
                              const SizedBox(width: defaultPadding),
                            Expanded(
                                flex: 5,
                                child: SizedBox(
                                  height: 500,
                                  // color: Colors.red,
                                  child: Column(
                                    children: [
                                      MySensor(
                                        data: demoMyFiles,
                                        onStatesChanged: onstatesChanged,
                                      ),
                                      const SizedBox(height: defaultPadding),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // ignore: prefer_const_constructors
                                          Expanded(
                                            flex: 2,
                                            child: //const CameraStream(),
                                                SizedBox(
                                              width: defaultPadding,
                                              child: Column(
                                                children: [
                                                  StreamBuilder(
                                                    stream: thingStream(),
                                                    builder:
                                                        ((context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        eventBus.fire(
                                                            UartValuesEvent(
                                                                "${snapshot.data}"));
                                                        return Text(
                                                            "return stream data ${snapshot.data}");
                                                      }
                                                      return const Text(
                                                          "nothing from snapshot");
                                                    }),
                                                  )
                                                ],
                                              ),
                                            ), //
                                          ),
                                          const SizedBox(width: defaultPadding),
                                          Expanded(
                                              flex: 1,
                                              child: Mymodules(
                                                states: moduleStates,
                                                names: modulenames,
                                                timers: moduleTimers,
                                                elaps: moduleElaps,
                                                currentModule: moduleSelect,
                                                onStatesChanged:
                                                    changeModuleStates,
                                                onTimerChanged:
                                                    changeModuleTimers,
                                                onModuleChanged:
                                                    changeModuleSelect,
                                              )),
                                          const SizedBox(width: defaultPadding),
                                          Expanded(
                                            flex: 1,
                                            child: Mylight(
                                              onoff: lightonoff,
                                              state: lightselect,
                                              brightness: lightlevel,
                                              currentColor: lightcolor,
                                              onOnOffChanged: lightset,
                                              onStateChanged: lightmode,
                                              onBrightnessChanged:
                                                  lightbrightness,
                                              onColorChanged: lightColor,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ],
                    ),
                  if (screenIndex == 1)
                    Column(
                      children: [
                        SensorsChart(
                          name: const [
                            "Temp",
                            "O2",
                            "Co2",
                            "Humidity",
                            "PM2.5"
                          ],
                          unit: const ["°C", "%", "ppm", "%", "ppm"],
                          currentValues: [0, 0, 0, 0, 0],
                          allValues: flspotvalues,
                          onScreenChanged: setScreen,
                        ),
                      ],
                    ),
                  if (screenIndex == 2)
                    Column(
                      children: [
                        SensorsDiagram(
                          tempState: tempIsEnable,
                          tempVal: tempcurrentTemp,
                          tempUnit: tempUnit,
                          tempMode: tempMode,
                          tempFan: tempFanSpeed,
                          tempEv: thermal1,
                          tempCd: thermal2,
                          tempCp: thermal3,
                          tempHt: thermal0,
                          o2State: o2Data.state,
                          o2Val: o2Data.value,
                          o2Fan: fanO2,
                          co2State: co2Data.state,
                          co2Val: co2Data.value,
                          huState: humidityData.state,
                          huVal: humidityData.value,
                          huFan: fanHumi,
                          reState: 0,
                          reVal: 100,
                          onScreenChanged: setScreen,
                        ),
                      ],
                    )
                  // SizedBox(height: defaultPadding * 0.5),
                ],
              ),
            ),
          );
      })
    );
  }
}

MessageArguments(RemoteMessage message, bool bool) {
  print(message);
}