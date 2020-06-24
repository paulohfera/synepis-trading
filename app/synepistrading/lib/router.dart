import 'package:flutter/material.dart';

import 'features/account/presentatios/pages/login_page.dart';

const String homeRoute = '/';
const String registerRoute = '/register';
const String forgotPasswordRoute = '/register';
const String tabsRoute = '/tabs';

class Router {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => LoginPage());
      // case registerRoute:
      //   return MaterialPageRoute(builder: (_) => RegisterPage());
      // case forgotPasswordRoute:
      //   return MaterialPageRoute(builder: (_) => ForgotPasswordPage());
      // case tabsRoute:
      //   return MaterialPageRoute(builder: (_) => TabsPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
