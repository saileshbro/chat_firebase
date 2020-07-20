import 'package:chat_firebase/app/failure.dart';
import 'package:chat_firebase/app/locator.dart';
import 'package:chat_firebase/datamodels/user_datamodel.dart';
import 'package:chat_firebase/services/api_service.dart';
import 'package:chat_firebase/ui/views/chat/chat_view.dart';
import 'package:dartz/dartz.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SearchViewModel extends BaseViewModel {
  String _query;
  List<UserDataModel> _users;

  SearchViewModel(this._navigationService);
  List<UserDataModel> get users => _users;
  bool get isEmpty => _users != null && _users.isEmpty;
  bool get init => users == null;
  final ApiService _apiService = locator<ApiService>();
  final NavigationService _navigationService;
  void onChanged(String str) {
    _query = str;
  }

  Future<void> onSubmitted() async {
    clearErrors();
    setBusy(true);
    final Either<Failure, List<UserDataModel>> result =
        await _apiService.searchUsers(query: _query);
    result.fold((Failure failure) => setError(failure.error),
        (List<UserDataModel> users) {
      _users = users;
    });
    setBusy(false);
  }

  void goToChatScreen(UserDataModel user) {
    _navigationService.navigateTo(ChatView.route, arguments: user);
  }
}
