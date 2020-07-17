import 'package:chat_firebase/app/locator.dart';
import 'package:chat_firebase/ui/router.dart';
import 'package:chat_firebase/ui/views/startup/startup_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Chat Application',
      onGenerateRoute: onGenerateRoute,
      navigatorKey: locator<NavigationService>().navigatorKey,
      initialRoute: StartUpView.route,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
