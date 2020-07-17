import 'package:chat_firebase/app/locator.dart';
import 'package:chat_firebase/services/authentication_service.dart';
import 'package:chat_firebase/services/user_data_service.dart';
import 'package:chat_firebase/ui/views/login/login_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  void onLogoutPressed() {
    _authenticationService.logout();
    _navigationService.clearStackAndShow(LoginView.route);
  }
}
