import 'package:chat_firebase/datamodels/user_datamodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String usernameKey = "USERNAME_KEY";
const String userNameKey = "USER_NAME_KEY";
const String userIdKey = "USER_ID_KEY";

class UserDataService {
  final SharedPreferences _preferences;
  UserDataModel _userDataModel;
  UserDataModel get userDataModel => _userDataModel;
  UserDataService(this._preferences) {
    _userDataModel = UserDataModel(id: null, username: null, name: null);
  }
  Future<void> saveData(UserDataModel model) async {
    await _preferences.setString(userIdKey, model.id);
    await _preferences.setString(usernameKey, model.username);
    await _preferences.setString(userNameKey, model.name);
    _userDataModel = model;
  }

  void getData() {
    _userDataModel.id = _preferences.containsKey(userIdKey)
        ? _preferences.getString(userIdKey)
        : null;
    _userDataModel.username = _preferences.containsKey(usernameKey)
        ? _preferences.getString(usernameKey)
        : null;
    _userDataModel.name = _preferences.containsKey(userNameKey)
        ? _preferences.getString(userNameKey)
        : null;
  }

  Future<void> clearData() async {
    _userDataModel = null;
    await _preferences.remove(userIdKey);
    await _preferences.remove(usernameKey);
    await _preferences.remove(userNameKey);
  }

  bool isLoggedIn() {
    getData();
    return _isDataValid();
  }

  bool _isDataValid() {
    return !_userDataModel.isEmpty();
  }
}
