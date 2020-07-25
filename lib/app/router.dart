import 'package:auto_route/auto_route_annotations.dart';
import 'package:chat_firebase/ui/views/chat/chat_view.dart';
import 'package:chat_firebase/ui/views/home/home_view.dart';
import 'package:chat_firebase/ui/views/login/login_view.dart';
import 'package:chat_firebase/ui/views/register/register_view.dart';
import 'package:chat_firebase/ui/views/search/search_view.dart';
import 'package:chat_firebase/ui/views/startup/startup_view.dart';

@MaterialAutoRouter(routes: [
  MaterialRoute(
    page: StartUpView,
    initial: true,
  ),
  MaterialRoute(
    page: RegisterView,
  ),
  MaterialRoute(
    page: LoginView,
  ),
  MaterialRoute(
    page: SearchView,
  ),
  MaterialRoute(
    page: ChatView,
  ),
  MaterialRoute(
    page: HomeView,
  ),
])
class $Router {}
