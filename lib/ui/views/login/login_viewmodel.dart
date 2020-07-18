import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:chat_firebase/app/failure.dart';
import 'package:chat_firebase/app/locator.dart';
import 'package:chat_firebase/datamodels/user_datamodel.dart';
import 'package:chat_firebase/services/api_service.dart';
import 'package:chat_firebase/services/user_data_service.dart';
import 'package:chat_firebase/ui/views/home/home_view.dart';
import 'package:chat_firebase/ui/views/register/register_view.dart';

class LoginViewModel extends BaseViewModel {
  final ApiService _apiService = locator<ApiService>();
  final UserDataService _userDataService = locator<UserDataService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _username;
  GlobalKey<FormState> get formKey => _formKey;
  void onUsernameChanged(String username) {
    _username = username;
  }

  Future<void> onLoginPressed() async {
    if (_formKey.currentState.validate()) {
      setBusy(true);
      final result = await _apiService.login(username: _username);
      result.fold((Failure failure) => _showDialog(failure.error),
          (UserDataModel model) {
        _userDataService.saveData(model);
        _navigationService.clearStackAndShow(HomeView.route);
      });
      setBusy(false);
    }
  }

  void goToRegister() {
    _navigationService.clearTillFirstAndShow(RegisterView.route);
  }

  void _showDialog(message) {
    _dialogService.showDialog(
      title: "Login Failure",
      description: message,
      buttonTitle: "OK",
    );
    setBusy(false);
  }

  String validateUsername(String value) {
    if (value.isEmpty) {
      return "Invalid username provided!";
    }
    return null;
  }
}
