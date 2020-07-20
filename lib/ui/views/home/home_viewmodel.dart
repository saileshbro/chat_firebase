import 'package:chat_firebase/datamodels/user_datamodel.dart';
import 'package:chat_firebase/services/api_service.dart';
import 'package:chat_firebase/services/firebase_service.dart';
import 'package:chat_firebase/services/user_data_service.dart';
import 'package:chat_firebase/ui/views/chat/chat_view.dart';
import 'package:chat_firebase/ui/views/login/login_view.dart';
import 'package:chat_firebase/ui/views/search/search_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final ApiService _apiService;
  final FirebaseService _firebaseService;
  final NavigationService _navigationService;
  final UserDataService _userDataService;
  String get loggedinUsername => _userDataService.userDataModel.username;
  List<UserDataModel> users;
  HomeViewModel(this._apiService, this._firebaseService,
      this._navigationService, this._userDataService) {
    _firebaseService.users.listen(_onUserAdded);
  }
  void _onUserAdded(List<UserDataModel> usersList) {
    users = usersList
        .where((element) => element.id != _userDataService.userDataModel.id)
        .toList();
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

  void goToChatScreen(UserDataModel user) {
    _navigationService.navigateTo(ChatView.route, arguments: user);
  }
}
