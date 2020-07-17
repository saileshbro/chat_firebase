import 'package:chat_firebase/services/authentication_service.dart';
import 'package:chat_firebase/services/firebase_service.dart';
import 'package:chat_firebase/services/user_data_service.dart';
import 'package:chat_firebase/ui/views/home/home_viewmodel.dart';
import 'package:chat_firebase/ui/views/register/register_viewmodel.dart';
import 'package:chat_firebase/ui/views/startup/startup_viewmodel.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_services/stacked_services.dart';

final GetIt locator = GetIt.instance;
Future<void> setupLocator() async {
  final SharedPreferences _preferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton<UserDataService>(() => UserDataService());
  locator.registerLazySingleton<NavigationService>(() => NavigationService());
  locator.registerLazySingleton<DialogService>(() => DialogService());
  locator.registerFactory<SharedPreferences>(() => _preferences);
  locator.registerLazySingleton<StartUpViewModel>(() => StartUpViewModel());
  locator.registerLazySingleton<RegisterViewModel>(() => RegisterViewModel());
  locator.registerLazySingleton<FirebaseService>(() => FirebaseService());
  locator.registerLazySingleton<AuthenticationService>(
      () => AuthenticationService());
  locator.registerLazySingleton<HomeViewModel>(() => HomeViewModel());
}
