import 'package:chat_firebase/app/router.gr.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:chat_firebase/app/failure.dart';
import 'package:chat_firebase/datamodels/user_datamodel.dart';
import 'package:chat_firebase/services/api_service.dart';
import 'package:chat_firebase/services/user_data_service.dart';

@lazySingleton
class LoginViewModel extends BaseViewModel {
  final ApiService _apiService;
  final UserDataService _userDataService;
  final DialogService _dialogService;
  final NavigationService _navigationService;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _username;

  LoginViewModel(this._apiService, this._userDataService, this._dialogService,
      this._navigationService);
  GlobalKey<FormState> get formKey => _formKey;
  void onUsernameChanged(String username) {
    _username = username;
  }

  Future<void> onLoginPressed() async {
    if (_formKey.currentState.validate()) {
      setBusy(true);
      final result = await _apiService.login(username: _username);
      result.fold((Failure failure) => _showDialog(failure.error),
          (UserDataModel model) async {
        await _userDataService.saveData(model);
        _navigationService.clearStackAndShow(Routes.homeView);
      });
      setBusy(false);
    }
  }

  void goToRegister() {
    _navigationService.clearTillFirstAndShow(Routes.registerView);
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
