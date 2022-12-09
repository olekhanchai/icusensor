import 'dart:convert';

import 'package:icusensor/models/bluetoothid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BluetoothPreferences {
  static late SharedPreferences _preferences;

  static const _keyBluetooth = 'bluetooth';
  static const myBluetoothId = bluetoothID(
    id: 'A4:C1:38:AC:CD:4E',
    name: 'LYWSD03MMC',
    type: 2,
  );

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setBluetooth(bluetoothID bt) async {
    final json = jsonEncode(bt.toJson());

    await _preferences.setString(_keyBluetooth, json);
  }

  static bluetoothID getBluetooth() {
    final json = _preferences.getString(_keyBluetooth);
    return json == null
        ? myBluetoothId
        : bluetoothID.fromJson(jsonDecode(json));
  }
}
