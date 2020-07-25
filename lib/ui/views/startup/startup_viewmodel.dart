import 'package:chat_firebase/app/router.gr.dart';
import 'package:chat_firebase/services/user_data_service.dart';
import 'package:flutter/scheduler.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

@lazySingleton
class StartUpViewModel extends BaseViewModel {
  final NavigationService _navigationService;
  final UserDataService _userDataService;

  StartUpViewModel(this._navigationService, this._userDataService);
  Future<void> handleStartup() async {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (_userDataService.isLoggedIn()) {
        _navigationService.clearStackAndShow(Routes.homeView);
      } else {
        _navigationService.clearStackAndShow(Routes.loginView);
      }
    });
  }
}
