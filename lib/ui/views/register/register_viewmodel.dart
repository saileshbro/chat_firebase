import 'package:chat_firebase/app/failure.dart';
import 'package:chat_firebase/app/locator.dart';
import 'package:chat_firebase/datamodels/user_datamodel.dart';
import 'package:chat_firebase/services/authentication_service.dart';
import 'package:chat_firebase/ui/views/home/home_view.dart';
import 'package:chat_firebase/ui/views/login/login_view.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class RegisterViewModel extends BaseViewModel {
  final TextEditingController usernameController = TextEditingController();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  Future<void> onRegisterPressed() async {
    setBusy(true);
    final result = await _authenticationService.register(
        username: usernameController.text);
    result.fold((Failure failure) => _showDialog(failure.error),
        (UserDataModel model) {
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
