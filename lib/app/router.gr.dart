// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../datamodels/user_datamodel.dart';
import '../ui/views/chat/chat_view.dart';
import '../ui/views/home/home_view.dart';
import '../ui/views/login/login_view.dart';
import '../ui/views/register/register_view.dart';
import '../ui/views/search/search_view.dart';
import '../ui/views/startup/startup_view.dart';

class Routes {
  static const String startUpView = '/';
  static const String registerView = '/register-view';
  static const String loginView = '/login-view';
  static const String searchView = '/search-view';
  static const String chatView = '/chat-view';
  static const String homeView = '/home-view';
  static const all = <String>{
    startUpView,
    registerView,
    loginView,
    searchView,
    chatView,
    homeView,
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.startUpView, page: StartUpView),
    RouteDef(Routes.registerView, page: RegisterView),
    RouteDef(Routes.loginView, page: LoginView),
    RouteDef(Routes.searchView, page: SearchView),
    RouteDef(Routes.chatView, page: ChatView),
    RouteDef(Routes.homeView, page: HomeView),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    StartUpView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => StartUpView(),
        settings: data,
      );
    },
    RegisterView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => RegisterView(),
        settings: data,
      );
    },
    LoginView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => LoginView(),
        settings: data,
      );
    },
    SearchView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => SearchView(),
        settings: data,
      );
    },
    ChatView: (data) {
      var args = data.getArgs<ChatViewArguments>(
        orElse: () => ChatViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => ChatView(
          key: args.key,
          otherUser: args.otherUser,
        ),
        settings: data,
      );
    },
    HomeView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => HomeView(),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// ChatView arguments holder class
class ChatViewArguments {
  final Key key;
  final UserDataModel otherUser;
  ChatViewArguments({this.key, this.otherUser});
}
