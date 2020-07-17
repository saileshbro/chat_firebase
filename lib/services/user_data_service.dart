import 'package:chat_firebase/app/locator.dart';
import 'package:chat_firebase/datamodels/user_datamodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String userNameKey = "USERNAME_KEY";
const String userIdKey = "USER_ID_KEY";

class UserDataService {
  final SharedPreferences _preferences = locator<SharedPreferences>();
  UserDataModel _userDataModel;
  UserDataModel get userDataModel => _userDataModel;
  UserDataService() {
    _userDataModel = UserDataModel(id: null, username: null);
  }
  Future<void> saveData(UserDataModel model) async {
    await _preferences.setString(userIdKey, model.id);
    await _preferences.setString(userNameKey, model.username);
    _userDataModel = model;
  }

  void getData() {
    _userDataModel.id = _preferences.containsKey(userIdKey)
        ? _preferences.getString(userIdKey)
        : null;
    _userDataModel.username = _preferences.containsKey(userNameKey)
        ? _preferences.getString(userNameKey)
        : null;
  }

  void clearData() {
    _userDataModel = null;
    _preferences.remove(userIdKey);
    _preferences.remove(userNameKey);
  }

  bool isLoggedIn() {
    getData();
    return _isDataValid();
  }

  bool _isDataValid() {
    return !_userDataModel.isEmpty();
  }
}
