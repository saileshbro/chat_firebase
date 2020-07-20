import 'package:chat_firebase/services/api_service.dart';
import 'package:chat_firebase/services/firebase_service.dart';
import 'package:chat_firebase/services/user_data_service.dart';
import 'package:chat_firebase/ui/views/chat/chat_viewmodel.dart';
import 'package:chat_firebase/ui/views/home/home_viewmodel.dart';
import 'package:chat_firebase/ui/views/login/login_viewmodel.dart';
import 'package:chat_firebase/ui/views/register/register_viewmodel.dart';
import 'package:chat_firebase/ui/views/search/search_viewmodel.dart';
import 'package:chat_firebase/ui/views/startup/startup_viewmodel.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_services/stacked_services.dart';

final GetIt locator = GetIt.instance;
Future<void> setupLocator() async {
  final SharedPreferences _preferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton<NavigationService>(() => NavigationService());
  locator.registerLazySingleton<DialogService>(() => DialogService());
  locator.registerFactory<SharedPreferences>(() => _preferences);
  locator.registerLazySingleton<UserDataService>(
      () => UserDataService(locator<SharedPreferences>()));
  locator.registerLazySingleton<FirebaseService>(() => FirebaseService());
  locator.registerLazySingleton<ApiService>(
      () => ApiService(locator<UserDataService>(), locator<FirebaseService>()));
  locator.registerLazySingleton<StartUpViewModel>(() => StartUpViewModel(
      locator<NavigationService>(), locator<UserDataService>()));
  locator.registerLazySingleton<RegisterViewModel>(() => RegisterViewModel(
        locator<ApiService>(),
        locator<DialogService>(),
        locator<NavigationService>(),
        locator<UserDataService>(),
      ));
  locator.registerLazySingleton<LoginViewModel>(() => LoginViewModel(
        locator<ApiService>(),
        locator<UserDataService>(),
        locator<DialogService>(),
        locator<NavigationService>(),
      ));
  locator.registerLazySingleton<HomeViewModel>(() => HomeViewModel(
        locator<ApiService>(),
        locator<FirebaseService>(),
        locator<NavigationService>(),
        locator<UserDataService>(),
      ));
  locator.registerLazySingleton<SearchViewModel>(
      () => SearchViewModel(locator<NavigationService>()));
  locator.registerFactory<ChatViewModel>(() =>
      ChatViewModel(locator<FirebaseService>(), locator<UserDataService>()));
}
