import 'package:chat_firebase/services/user_data_service.dart';
import 'package:chat_firebase/ui/views/home/home_view.dart';
import 'package:chat_firebase/ui/views/login/login_view.dart';
import 'package:flutter/scheduler.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class StartUpViewModel extends BaseViewModel {
  final NavigationService _navigationService;
  final UserDataService _userDataService;

  StartUpViewModel(this._navigationService, this._userDataService);
  Future<void> handleStartup() async {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (_userDataService.isLoggedIn()) {
        _navigationService.clearStackAndShow(HomeView.route);
      } else {
        _navigationService.clearStackAndShow(LoginView.route);
      }
    });
  }
}
