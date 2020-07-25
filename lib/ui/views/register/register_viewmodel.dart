import 'package:chat_firebase/app/failure.dart';
import 'package:chat_firebase/app/router.gr.dart';
import 'package:chat_firebase/datamodels/user_datamodel.dart';
import 'package:chat_firebase/services/api_service.dart';
import 'package:chat_firebase/services/user_data_service.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

@lazySingleton
class RegisterViewModel extends BaseViewModel {
  String _username;
  String _name;
  final ApiService _apiService;
  final DialogService _dialogService;
  final NavigationService _navigationService;
  final UserDataService _userDataService;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  RegisterViewModel(this._apiService, this._dialogService,
      this._navigationService, this._userDataService);
  GlobalKey<FormState> get formKey => _formKey;

  Future<void> onRegisterPressed() async {
    if (_formKey.currentState.validate()) {
      setBusy(true);
      final result =
          await _apiService.register(username: _username, name: _name);
      result.fold((Failure failure) => _showDialog(failure.error),
          (UserDataModel model) async {
        await _userDataService.saveData(model);
        _navigationService.clearStackAndShow(Routes.homeView);
      });
      setBusy(false);
    }
  }

  void onUsernameChanged(String val) {
    _username = val;
  }

  void onNameChanged(String val) {
    _name = val;
  }

  String validateUsername(String name) {
    if (name.isEmpty) {
      return "Invalid username provided!";
    }
    return null;
  }

  String validateName(String name) {
    if (name.isEmpty) {
      return "Invalid name provided!";
    }
    return null;
  }

  void goToLogin() {
    _navigationService.back();
  }

  void _showDialog(message) {
    _dialogService.showDialog(
      title: "Register Failure",
      description: message,
      buttonTitle: "OK",
    );
    setBusy(false);
  }
}
