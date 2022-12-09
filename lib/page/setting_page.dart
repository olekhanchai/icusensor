import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:icusensor/widget/appbar_widget.dart';
import '../../constants.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:icusensor/utils/navigation.dart';
import 'package:icusensor/page/system_page.dart';
import 'package:icusensor/page/network_info_page.dart';
import 'package:app_settings/app_settings.dart';

class SettingPage extends StatefulWidget {
  SettingPage({
    Key? key,
  }) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late bool sw1 = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Builder(
        builder: (context) => Scaffold(
          appBar: buildAppBar(context),
          body: SettingsList(
            platform: DevicePlatform.iOS,
            sections: [
              SettingsSection(
                tiles: [
                  SettingsTile(
                    onPressed: (context) =>
                        Navigation.toScreen(context, NetworkInfoPage()),
                    title: Text('Network & internet'),
                    description: Text('Wi-Fi, IP Camera'),
                    leading: Icon(Icons.wifi),
                  ),
                  SettingsTile(
                    // onPressed: (context) =>
                    //     Navigation.toScreen(context, SystemsPage()),
                    title: Text('Connected devices'),
                    description: Text('Controller,uart'),
                    leading: Icon(Icons.devices_other),
                    trailing: Text('Connected'),
                    enabled: false,
                  ),
                  SettingsTile.switchTile(
                    initialValue: sw1,
                    onToggle: (val) {
                      setState(() {
                        sw1 = val;
                      });
                    },
                    title: Text('Enable notifications'),
                    description: Text('Notification history, conversations'),
                    leading: Icon(Icons.notifications_none),
                  ),
                  SettingsTile(
                    onPressed: (context) =>
                        Navigation.toScreen(context, SystemsPage()),
                    title: Text('Storage'),
                    description: Text('30% used - 5.60 GB free'),
                    leading: Icon(Icons.storage),
                  ),
                  SettingsTile(
                    onPressed: (context) => Navigation.toApp(
                        context, AppSettings.openDisplaySettings()),
                    title: Text('Display'),
                    enabled: true,
                    description: Text('Dark theme, font size, brightness'),
                    leading: Icon(Icons.brightness_6_outlined),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
