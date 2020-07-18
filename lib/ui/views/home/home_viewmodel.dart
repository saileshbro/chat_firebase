import 'package:chat_firebase/app/locator.dart';
import 'package:chat_firebase/datamodels/user_datamodel.dart';
import 'package:chat_firebase/services/api_service.dart';
import 'package:chat_firebase/services/firebase_service.dart';
import 'package:chat_firebase/ui/views/login/login_view.dart';
import 'package:chat_firebase/ui/views/search/search_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final ApiService _apiService = locator<ApiService>();
  final FirebaseService _firebaseService = locator<FirebaseService>();
  final NavigationService _navigationService = locator<NavigationService>();
  List<UserDataModel> users;
  HomeViewModel() {
    _firebaseService.users.listen(_onUserAdded);
  }
  void _onUserAdded(List<UserDataModel> usersList) {
    users = usersList;
    if (users == null) {
      setBusy(true);
    } else {
      if (users.isEmpty) {
        setError("No users available");
      } else {
        setBusy(false);
      }
    }
  }

  void onLogoutPressed() {
    _apiService.logout();
    _navigationService.clearStackAndShow(LoginView.route);
  }

  void onSearchPressed() {
    _navigationService.navigateTo(SearchView.route);
  }
}
