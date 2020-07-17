import 'package:chat_firebase/ui/views/home/home_view.dart';
import 'package:chat_firebase/ui/views/login/login_view.dart';
import 'package:chat_firebase/ui/views/register/register_view.dart';
import 'package:chat_firebase/ui/views/startup/startup_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case StartUpView.route:
      return MaterialPageRoute(builder: (_) => StartUpView());
      break;
    case RegisterView.route:
      return MaterialPageRoute(builder: (_) => RegisterView());
      break;
    case LoginView.route:
      return MaterialPageRoute(builder: (_) => LoginView());
      break;
    case HomeView.route:
      return MaterialPageRoute(builder: (_) => HomeView());
      break;
    default:
      return MaterialPageRoute(
        builder: (BuildContext context) => const Scaffold(
          body: Center(
            child: Text("Route not found!"),
          ),
        ),
      );
  }
}
