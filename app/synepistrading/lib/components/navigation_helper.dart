import 'package:flutter/material.dart';

class NavigationHelper {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  Future<dynamic> pushReplacementNamed(String routeName) {
    return navigatorKey.currentState.pushReplacementNamed(routeName);
  }

  Future<dynamic> pushNamed(String routeName) {
    return navigatorKey.currentState.pushNamed(routeName);
  }
}
