import 'package:chat_firebase/app/failure.dart';
import 'package:chat_firebase/datamodels/user_datamodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection('users');
  Future<UserDataModel> registerUser({@required String username}) async {
    try {
      final QuerySnapshot response = await _usersCollectionReference
          .where('username', isEqualTo: username)
          .limit(1)
          .getDocuments();
      if (response.documents.isNotEmpty) {
        throw Failure("User already exists with username $username");
      }
      final DocumentReference newUserDocReference =
          await _usersCollectionReference.add({"username": username});
      final DocumentSnapshot snapshot = await newUserDocReference.get();
      return UserDataModel.fromDocumentSnapshot(snapshot);
    } catch (e) {
      print("Error:${e.toString()}");
      throw Failure(e.toString());
    }
  }

  Future<UserDataModel> loginUser({@required String username}) async {
    try {
      final QuerySnapshot response = await _usersCollectionReference
          .where('username', isEqualTo: username)
          .limit(1)
          .getDocuments();
      if (response.documents.isEmpty) {
        throw Failure("User doesn't exists with username $username");
      }
      final DocumentSnapshot snapshot = response.documents.first;
      return UserDataModel.fromDocumentSnapshot(snapshot);
    } catch (e) {
      print("Error:${e.toString()}");
      throw Failure(e.toString());
    }
  }
}
