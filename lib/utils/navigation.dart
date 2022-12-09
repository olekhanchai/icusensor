import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum NavigationRouteStyle {
  cupertino,
  material,
}

class Navigation {
  static toApp(BuildContext context, Future<void> app) {
    return app;
  }

  static toScreen(BuildContext context, Widget screen) {
    Navigation.navigateTo(
      context: context,
      screen: screen,
      style: NavigationRouteStyle.material,
    );
  }

  static Future<T?> navigateTo<T>({
    required BuildContext context,
    required Widget screen,
    NavigationRouteStyle? style,
  }) async {
    Route route;
    if (style == NavigationRouteStyle.cupertino) {
      route = CupertinoPageRoute<T>(builder: (_) => screen);
    } else if (style == NavigationRouteStyle.material) {
      route = MaterialPageRoute<T>(builder: (_) => screen);
    }

    return await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}
