import 'package:chat_firebase/app/failure.dart';
import 'package:chat_firebase/app/locator.dart';
import 'package:chat_firebase/datamodels/user_datamodel.dart';
import 'package:chat_firebase/services/authentication_service.dart';
import 'package:chat_firebase/services/user_data_service.dart';
import 'package:chat_firebase/ui/views/home/home_view.dart';
import 'package:chat_firebase/ui/views/register/register_view.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginViewModel extends BaseViewModel {
  final TextEditingController usernameController = TextEditingController();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final UserDataService _userDataService = locator<UserDataService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future<void> onLoginPressed() async {
    setBusy(true);
    final result =
        await _authenticationService.login(username: usernameController.text);
    result.fold((Failure failure) => _showDialog(failure.error),
        (UserDataModel model) {
      _userDataService.saveData(model);
      _navigationService.clearStackAndShow(HomeView.route);
    });
    setBusy(false);
  }

  void onNameChanged(String val) {
    _validateName(usernameController.text);
    notifyListeners();
  }

  void _validateName(String name) {
    if (name.isEmpty) {
      setError("Invalid name provided");
    } else {
      clearErrors();
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
}