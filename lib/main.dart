import 'package:icusensor/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:icusensor/controllers/MenuController.dart';
import 'package:icusensor/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icusensor/utils/bluetooth_preferences.dart';
import 'package:mysql_client/mysql_client.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:icusensor/themes.dart';
import 'package:icusensor/utils/user_preferences.dart';

import 'localization/settings_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  await UserPreferences.init();
  await BluetoothPreferences.init();

  final conn = await MySQLConnection.createConnection(
      host: "127.0.0.1",
      port: 3306,
      userName: "admin",
      password: "admin",
      databaseName: "test", // optional
  );

  await conn.connect();

  print("Connected");


  // Insert some data
  var result = await conn.execute(
      'insert into users (name, email, address) values (:name, :email, :address)',
      {
      "name": "ole",
      "email": "olekhanchai@gmail.com",
      "address": "1234567890"
    },
  );
  print(result.affectedRows);


  // Finally, close the connection
  await conn.close();  

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [
      SystemUiOverlay.top, /*SystemUiOverlay.bottom*/
    ],
  ).then(
    (_) => runApp(MyApp()),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  static final String title = 'ICU Sensors Panel';

  @override
  Widget build(BuildContext context) {
    final user = UserPreferences.getUser();
    return ThemeProvider(
        initTheme: user.isDarkMode ? MyThemes.darkTheme : MyThemes.lightTheme,
        // initTheme: MyThemes.stdTheme,
        child: Builder(
          builder: (context) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: title,
            theme: user.isDarkMode ? MyThemes.darkTheme : MyThemes.lightTheme,
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('ar', 'EG'),
            ],
            localizationsDelegates: const [
              // A class which loads the translations from JSON files
              SettingsLocalizations.delegate,
              // Built-in localization of basic text for Material widgets
              GlobalMaterialLocalizations.delegate,
              // Built-in localization for text direction LTR/RTL
              GlobalWidgetsLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              // Check if the current device locale is supported
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale?.languageCode &&
                    supportedLocale.countryCode == locale?.countryCode) {
                  return supportedLocale;
                }
              }
              // If the locale of the device is not supported, use the first one
              // from the list (English, in this case).
              return supportedLocales.first;
            },
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) => MenuController(),
                ),
              ],
              child: MainScreen(),
            ),
          ),
        ));
  }
}
