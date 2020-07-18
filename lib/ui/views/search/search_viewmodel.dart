import 'package:chat_firebase/app/failure.dart';
import 'package:chat_firebase/app/locator.dart';
import 'package:chat_firebase/datamodels/user_datamodel.dart';
import 'package:chat_firebase/services/api_service.dart';
import 'package:dartz/dartz.dart';
import 'package:stacked/stacked.dart';

class SearchViewModel extends BaseViewModel {
  String _query;
  List<UserDataModel> _users;
  List<UserDataModel> get users => _users;
  bool get isEmpty => _users != null && _users.isEmpty;
  bool get init => users == null;
  final ApiService _apiService = locator<ApiService>();
  void onChanged(String str) {
    _query = str;
  }

  Future<void> onSubmitted() async {
    // call api here
    setBusy(true);
    final Either<Failure, List<UserDataModel>> result =
        await _apiService.searchUsers(query: _query);
    result.fold((Failure failure) => error(failure.error),
        (List<UserDataModel> users) {
      _users = users;
    });
    setBusy(false);
  }
}
