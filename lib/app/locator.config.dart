// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:injectable/get_it_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_services/stacked_services.dart';

import '../services/api_service.dart';
import '../services/firebase_service.dart';
import '../services/push_notification_service.dart';
import '../services/third_party_services.dart';
import '../services/user_data_service.dart';
import '../ui/views/chat/chat_viewmodel.dart';
import '../ui/views/home/home_viewmodel.dart';
import '../ui/views/login/login_viewmodel.dart';
import '../ui/views/register/register_viewmodel.dart';
import '../ui/views/search/search_viewmodel.dart';
import '../ui/views/startup/startup_viewmodel.dart';

/// adds generated dependencies
/// to the provided [GetIt] instance

Future<void> $initGetIt(GetIt g, {String environment}) async {
  final gh = GetItHelper(g, environment);
  final thirdPartyServicesModule = _$ThirdPartyServicesModule();
  gh.lazySingleton<DialogService>(() => thirdPartyServicesModule.dialogService);
  gh.lazySingleton<NavigationService>(
      () => thirdPartyServicesModule.navigationService);
  gh.lazySingleton<PushNotificationService>(
      () => PushNotificationService(g<NavigationService>()));
  gh.lazySingleton<SearchViewModel>(
      () => SearchViewModel(g<NavigationService>()));
  final sharedPreferences = await thirdPartyServicesModule.prefs;
  gh.factory<SharedPreferences>(() => sharedPreferences);
  gh.lazySingleton<SnackbarService>(
      () => thirdPartyServicesModule.snackbarService);
  gh.lazySingleton<UserDataService>(
      () => UserDataService(g<SharedPreferences>()));
  gh.factory<FirebaseService>(() => FirebaseService(g<UserDataService>()));
  gh.lazySingleton<StartUpViewModel>(
      () => StartUpViewModel(g<NavigationService>(), g<UserDataService>()));
  gh.lazySingleton<ApiService>(
      () => ApiService(g<UserDataService>(), g<FirebaseService>()));
  gh.factory<ChatViewModel>(() => ChatViewModel(
        g<FirebaseService>(),
        g<UserDataService>(),
        g<NavigationService>(),
      ));
  gh.factory<HomeViewModel>(() => HomeViewModel(
        g<ApiService>(),
        g<FirebaseService>(),
        g<NavigationService>(),
        g<UserDataService>(),
        g<PushNotificationService>(),
      ));
  gh.lazySingleton<LoginViewModel>(() => LoginViewModel(
        g<ApiService>(),
        g<UserDataService>(),
        g<DialogService>(),
        g<NavigationService>(),
      ));
  gh.lazySingleton<RegisterViewModel>(() => RegisterViewModel(
        g<ApiService>(),
        g<DialogService>(),
        g<NavigationService>(),
        g<UserDataService>(),
      ));
}

class _$ThirdPartyServicesModule extends ThirdPartyServicesModule {
  @override
  DialogService get dialogService => DialogService();
  @override
  NavigationService get navigationService => NavigationService();
  @override
  SnackbarService get snackbarService => SnackbarService();
}
