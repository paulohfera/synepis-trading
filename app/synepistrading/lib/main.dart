import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synepistrading/features/tabs/presentation/pages/tabs_page.dart';

import 'components/navigation_helper.dart';
import 'containers.dart';
import 'core/datasources/local_data_source.dart';
import 'features/account/presentation/pages/login_page.dart';
import 'route.dart';

Future<void> main({String env}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await initContainer();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    var _localData = sl.get<LocalDataSource>();
    var _cachedUser = _localData.user;
    var _currentTheme = _localData.theme;

    return MaterialApp(
      title: 'Synapis Trading',
      debugShowCheckedModeBanner: false,
      theme: _currentTheme.getTheme().themeData,
      onGenerateRoute: Router.generateRoute,
      navigatorKey: sl.get<NavigationHelper>().navigatorKey,
      home: _cachedUser == null ? LoginPage() : TabsPage(),
    );
  }
}
