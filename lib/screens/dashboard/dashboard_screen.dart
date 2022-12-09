import 'dart:ffi';
import 'dart:typed_data';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:icusensor/screens/dashboard/components/header.dart';
import 'package:icusensor/responsive.dart';
import 'package:icusensor/screens/dashboard/components/my_sensors.dart';
import 'package:flutter/material.dart';
import 'package:icusensor/screens/dashboard/sensor_chart.dart';
import 'package:icusensor/screens/dashboard/sensor_diagram.dart';
import 'package:icusensor/utils/bluetooth_preferences.dart';
import 'package:string_validator/string_validator.dart';

import '../../constants.dart';

import 'dart:async';
import 'dart:math';
import 'package:intl/intl.dart';

//import 'components/recent_files.dart';
import '../../models/bluetoothid.dart';
import '../../page/bluetooth_page.dart';
import '../../page/cam_page.dart';
import 'components/temperature_details.dart';
//import 'components/camera.dart';
//import 'components/camerastream.dart';
import 'components/lightcolors.dart';
import 'components/modules.dart';
import 'package:icusensor/models/MyFiles.dart';
import 'components/times.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';

import 'package:icusensor/models/flspotdata.dart';
import 'package:app_settings/app_settings.dart';

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

  void getUartValue(Map data) {
    setState(() {
      try {
        tempcurrentTarget = double.parse(data["TargetTemp"]);
        tempIsEnable = int.parse(data["ConStateTemp"]) == 1 ? true : false;
        tempMode = int.parse(data["ConMode1Temp"]) == 1 ? true : false;
        tempUnit = int.parse(data["ConMode2Temp"]) == 1 ? true : false;
        tempIson = int.parse(data["ConSfPwmTemp"]) > 1 ? true : false;
        tempGain = double.parse(data["GainTemp"]);
        tempOffset = double.parse(data["OffsetTemp"]);
        tempHysteresis = double.parse(data["HysteresisTemp"]);
        tempInvert = int.parse(data["ConInvTemp"]) == 1 ? true : false;

        co2Data.target = double.parse(data["TargetCo2"]).toInt();
        co2Data.timer = int.parse(data["ConTimerCo2"]);
        co2Data.state = int.parse(data["ConStateCo2"]);
        co2Data.elaps = int.parse(data["ConElapsCo2"]);
        co2Data.ison = int.parse(data["ConSfPwmCo2"]) > 0 ? true : false;
        co2Data.gain = double.parse(data["GainCo2"]);
        co2Data.offset = double.parse(data["OffsetCo2"]);
        co2Data.hysteresis = double.parse(data["HysteresisCo2"]);
        co2Data.inv = int.parse(data["ConInvCo2"]) == 1 ? true : false;

        humidityData.target = double.parse(data["TargetHumi"]).toInt();
        humidityData.timer = int.parse(data["ConTimerHumi"]);
        humidityData.state = int.parse(data["ConStateHumi"]);
        humidityData.elaps = int.parse(data["ConElapsHumi"]);
        humidityData.ison = int.parse(data["ConSfPwmHumi"]) > 0 ? true : false;
        humidityData.gain = double.parse(data["GainHumi"]);
        humidityData.offset = double.parse(data["OffsetHumi"]);
        humidityData.hysteresis = double.parse(data["HysteresisHumi"]);
        humidityData.inv = int.parse(data["ConInvHumi"]) == 1 ? true : false;

        o2Data.target = double.parse(data["TargetO2"]).toInt();
        o2Data.timer = int.parse(data["ConTimerO2"]);
        o2Data.state = int.parse(data["ConStateO2"]);
        o2Data.elaps = int.parse(data["ConElapsO2"]);
        o2Data.ison = int.parse(data["ConSfPwmO2"]) > 0 ? true : false;
        o2Data.gain = double.parse(data["GainO2"]);
        o2Data.offset = double.parse(data["OffsetO2"]);
        o2Data.hysteresis = double.parse(data["HysteresisO2"]);
        o2Data.inv = int.parse(data["ConInvO2"]) == 1 ? true : false;

        lightcolor = Color.fromRGBO(int.parse(data["RgbRed"]),
            int.parse(data["RgbGreen"]), int.parse(data["RgbBlue"]), 1);
        lightlevel =
            max(0, (int.parse(data["RgbBright"]) ~/ (255 / 5) - 1).toDouble());
        lightonoff = (int.parse(data["ConStateLight"]) > 0) ? true : false;
        //lighttimer = int.parse(data["ConTimerLight"]);
        lightselect[0] = (int.parse(data["ConMode1Light"]) == 0) &&
                (int.parse(data["ConMode2Light"]) == 0)
            ? true
            : false;
        lightselect[1] = (int.parse(data["ConMode1Light"]) == 1) &&
                (int.parse(data["ConMode2Light"]) == 0)
            ? true
            : false;
        lightselect[2] = (int.parse(data["ConMode1Light"]) == 1) &&
                (int.parse(data["ConMode2Light"]) == 1)
            ? true
            : false;

        moduleStates[0] = (int.parse(data["ConStateIron"]) == 1) ? true : false;
        moduleStates[1] = (int.parse(data["ConStateNebu"]) == 1) ? true : false;
        moduleStates[2] = (int.parse(data["ConStateUvc"]) == 1) ? true : false;
        moduleStates[3] = false;

        moduleTimers[0] = int.parse(data["ConTimerIron"]);
        moduleTimers[1] = int.parse(data["ConTimerNebu"]);
        moduleTimers[2] = int.parse(data["ConTimerUvc"]);
        moduleTimers[3] = 0;

        moduleElaps[0] = int.parse(data["ConElapsIron"]);
        moduleElaps[1] = int.parse(data["ConElapsNebu"]);
        moduleElaps[2] = int.parse(data["ConElapsUvc"]);
        moduleElaps[3] = 0;

        tempFanSpeed = max(0, (int.parse(data["FanTemp"]) ~/ (255 / 5)) - 1);
        fanO2 = (int.parse(data["FanO2"]) ~/ (255 / 5));
        fanHumi = (int.parse(data["FanHumi"]) ~/ (255 / 5));

        thermal0 = roundableFloat(double.parse(data["Thermal0"]), 2);
        thermal1 = roundableFloat(double.parse(data["Thermal1"]), 2);
        thermal2 = roundableFloat(double.parse(data["Thermal2"]), 2);
        thermal3 = roundableFloat(double.parse(data["Thermal3"]), 2);

        if (tempMode) {
          tempcurrentThermals = "Heater: ${thermal0.toStringAsFixed(2)}";
        } else {
          tempcurrentThermals =
              "Cp: ${thermal1.toStringAsFixed(2)}  Cd: ${thermal2.toStringAsFixed(2)}  Ev:${thermal3.toStringAsFixed(2)}";
        }

        tempcurrentTemp = roundableFloat(double.parse(data["ValTemp"]), 2);
        demoMyFiles[0].value = roundableFloat(double.parse(data["ValO2"]), 2);
        demoMyFiles[1].value = roundableFloat(double.parse(data["ValCo2"]), 2);
        demoMyFiles[2].value = roundableFloat(double.parse(data["ValHumi"]), 2);
        // demoMyFiles[3].value = 50;

        for (int i = 0; i < 30 - 1; i++) {
          data0[i] = FlSpot(data0[i].x, data0[i + 1].y);
          data1[i] = FlSpot(data1[i].x, data1[i + 1].y);
          data2[i] = FlSpot(data2[i].x, data2[i + 1].y);
          data3[i] = FlSpot(data3[i].x, data3[i + 1].y);
          data4[i] = FlSpot(data4[i].x, data4[i + 1].y);
        }
        data0[29] = FlSpot(29, tempcurrentTemp);
        data1[29] = FlSpot(29, demoMyFiles[0].value);
        data2[29] = FlSpot(29, demoMyFiles[1].value);
        data3[29] = FlSpot(29, demoMyFiles[2].value);
        data4[29] = FlSpot(29, Random().nextDouble() * 100);

        flspotvalues = FlSpotdata(
            value0: data0,
            value1: data1,
            value2: data2,
            value3: data3,
            value4: data4);

        icount++;

        o2Sum += demoMyFiles[0].value;
        co2Sum += demoMyFiles[1].value;
        humiditySum += demoMyFiles[2].value;
        //  dSum += demoMyFiles[3].value;

        int seccount = 10;
        if (icount > (seccount)) {
          icount = 0;
          dataO2 = [
            FlSpot(0, dataO2[1].y),
            FlSpot(1, dataO2[2].y),
            FlSpot(2, dataO2[3].y),
            FlSpot(3, dataO2[4].y),
            FlSpot(4, dataO2[5].y),
            FlSpot(5, dataO2[6].y),
            FlSpot(6, o2Sum / seccount)
          ];
          o2Data.data = dataO2;
          o2Sum = 0;

          dataCo2 = [
            FlSpot(0, dataCo2[1].y),
            FlSpot(1, dataCo2[2].y),
            FlSpot(2, dataCo2[3].y),
            FlSpot(3, dataCo2[4].y),
            FlSpot(4, dataCo2[5].y),
            FlSpot(5, dataCo2[6].y),
            FlSpot(6, co2Sum / seccount)
          ];
          co2Data.data = dataCo2;
          co2Sum = 0;

          dataHumidity = [
            FlSpot(0, dataHumidity[1].y),
            FlSpot(1, dataHumidity[2].y),
            FlSpot(2, dataHumidity[3].y),
            FlSpot(3, dataHumidity[4].y),
            FlSpot(4, dataHumidity[5].y),
            FlSpot(5, dataHumidity[6].y),
            FlSpot(6, humiditySum / seccount)
          ];
          humidityData.data = dataHumidity;
          humiditySum = 0;
        }
      } on PlatformException catch (e) {}
    });
  }

  void updateioState() {
    setState(() {
      strState = strStates[ioState];
    });
  }

  void sentUartData(String input) {
    input += " Z101\n";
    //input += " M500\n";
    //sentonlyUartData(input);
    setState(() {});
    sentrecieveUartData(input);
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

  Future<void> sentrecieveUartData(String input) async {
    setState(() {
      callCount++;
    });
    var result = await methodChannel.invokeMethod('UartSendRecieve', input);
    // getUartValue(result);
    setState(() {
      doneCount++;
    });
  }

  void onCallbackEvent(dynamic data) {
    getUartValue(data);
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
      genDataDemo(false);
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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    demoMyFiles = [
      o2Data,
      co2Data,
      humidityData,
    ];

    ioState = 0;
    genData();
    screenIndex = 0;
    Timer.periodic(const Duration(seconds: 1), (Timer t) => getTime());
    // eventSubscription = eventCallback
    //     .receiveBroadcastStream("argument")
    //     .listen(onCallbackEvent, onError: onCallbackError);

    //sentUartData("");
  }

  @override
  void deactivate() {
    super.deactivate();
    Clossing();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    Clossing();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    bluetootid = BluetoothPreferences.getBluetooth();

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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    TemperatureDetails(
                                      isEnable: tempIsEnable,
                                      currentTemperature: tempcurrentTemp,
                                      currentMin: 18,
                                      currentMax: 45,
                                      tragetTemperature: tempcurrentTarget,
                                      cuurentTime: tempcurrentTime,
                                      currentFanSpeed: tempFanSpeed,
                                      currentMode: tempMode,
                                      currentUnit: tempUnit,
                                      currentIson: tempIson,
                                      currentThermals: tempcurrentThermals,
                                      onEnableChanged: tempEnableChanged,
                                      onTragetTemperatureChangedMinus:
                                          tempTragetTemperatureMinus,
                                      onTragetTemperatureChangedPluse:
                                          tempTragetTemperaturePlus,
                                      onFanSpeedChanged: tempFanSpeedChanged,
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
                                  extdevice: BluetoothDevice.fromId(
                                      bluetootid.id,
                                      name: bluetootid.name,
                                      type: BluetoothDeviceType
                                          .values[bluetootid.type]),
                                  extonValueChanged: bluetoothDataChange,
                                  extonClick: bluetoothSetting,
                                ),
                                const SizedBox(height: defaultPadding),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child:
                                    const  SizedBox(width:100,
                                      height:100),

                                      //  CameraStream(
                                      //   isFullScreen: false,
                                      //   onClick: cameraFullscreen,
                                      // ),
                                    ),
                                    const SizedBox(width: defaultPadding),
                                    Expanded(
                                        flex: 2,
                                        child: Row(
                                          children: [
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
                                            const SizedBox(
                                                width: defaultPadding),
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
                                        )),
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
                      "Temperature",
                      "O2",
                      "Co2",
                      "Humidity",
                      "Bluetooth"
                    ],
                    unit: const ["°C", "%", "ppm", "%", "C"],
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
  }
}
