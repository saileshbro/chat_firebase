import 'package:chat_firebase/app/failure.dart';
import 'package:chat_firebase/app/locator.dart';
import 'package:chat_firebase/datamodels/user_datamodel.dart';
import 'package:chat_firebase/services/firebase_service.dart';
import 'package:chat_firebase/services/user_data_service.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

class AuthenticationService {
  final UserDataService _userDataService = locator<UserDataService>();
  final FirebaseService _firebaseService = locator<FirebaseService>();

  Future<Either<Failure, UserDataModel>> register(
      {@required String username}) async {
    try {
      final UserDataModel model =
          await _firebaseService.registerUser(username: username);
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

  void logout() {
    _userDataService.clearData();
  }
}
