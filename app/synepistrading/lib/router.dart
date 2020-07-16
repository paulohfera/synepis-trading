import 'package:flutter/material.dart';

import 'features/account/presentation/pages/forgot_password_confirm.dart';
import 'features/account/presentation/pages/forgot_password_page.dart';
import 'features/account/presentation/pages/login_page.dart';
import 'features/account/presentation/pages/register_page.dart';
import 'features/tabs/presentation/pages/tabs_page.dart';

const String homeRoute = '/';
const String registerRoute = '/register';
const String forgotPasswordRoute = '/forgotPassword';
const String forgotPasswordConfirmRoute = '/forgotPasswordConfirm';
const String tabsRoute = '/tabs';

class Router {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case registerRoute:
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case forgotPasswordRoute:
        return MaterialPageRoute(builder: (_) => ForgotPasswordPage());
      case forgotPasswordConfirmRoute:
        return MaterialPageRoute(builder: (_) => ForgotPasswordConfirmPage());
      case tabsRoute:
        return MaterialPageRoute(builder: (_) => TabsPage());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
