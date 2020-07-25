import 'package:chat_firebase/app/failure.dart';
import 'package:chat_firebase/datamodels/user_datamodel.dart';
import 'package:chat_firebase/services/firebase_service.dart';
import 'package:chat_firebase/services/user_data_service.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ApiService {
  final UserDataService _userDataService;
  final FirebaseService _firebaseService;

  ApiService(this._userDataService, this._firebaseService);

  Future<Either<Failure, UserDataModel>> register(
      {@required String username, @required String name}) async {
    try {
      final UserDataModel model =
          await _firebaseService.registerUser(username: username, name: name);
      _userDataService.saveData(model);
      return right(model);
    } on Failure catch (e) {
      return left(e);
    }
  }

  Future<Either<Failure, UserDataModel>> login(
      {@required String username}) async {
    try {
      final UserDataModel model =
          await _firebaseService.loginUser(username: username);
      _userDataService.saveData(model);
      return right(model);
    } on Failure catch (e) {
      return left(e);
    }
  }

  Future<Either<Failure, List<UserDataModel>>> searchUsers(
      {@required String query}) async {
    try {
      final List<UserDataModel> users =
          await _firebaseService.searchUsers(query: query);
      return right(users);
    } on Failure catch (e) {
      return left(e);
    }
  }

  Future<void> logout() async {
    await _userDataService.clearData();
  }
}
