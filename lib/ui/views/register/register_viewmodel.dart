import 'package:chat_firebase/app/failure.dart';
import 'package:chat_firebase/app/locator.dart';
import 'package:chat_firebase/datamodels/user_datamodel.dart';
import 'package:chat_firebase/services/api_service.dart';
import 'package:chat_firebase/ui/views/home/home_view.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class RegisterViewModel extends BaseViewModel {
  String _username;
  String _name;
  final ApiService _apiService = locator<ApiService>();

  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  Future<void> onRegisterPressed() async {
    if (_formKey.currentState.validate()) {
      setBusy(true);
      final result =
          await _apiService.register(username: _username, name: _name);
      result.fold((Failure failure) => _showDialog(failure.error),
          (UserDataModel model) {
        _navigationService.clearStackAndShow(HomeView.route);
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
