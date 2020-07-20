import 'dart:async';

import 'package:chat_firebase/app/failure.dart';
import 'package:chat_firebase/common/helpers/generate_keywords.dart';
import 'package:chat_firebase/datamodels/message_datamodel.dart';
import 'package:chat_firebase/datamodels/user_datamodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection('users');
  CollectionReference messagesCollectionReference(String conversationId) {
    return Firestore.instance
        .collection("messages")
        .document(conversationId)
        .collection(conversationId);
  }

  final StreamController<List<UserDataModel>> _usersHomeController =
      StreamController<List<UserDataModel>>();
  CollectionReference get usersCollectionReference => _usersCollectionReference;
  FirebaseService() {
    _usersCollectionReference.snapshots().listen(_onUsersAdded);
  }

  Stream<List<UserDataModel>> get users => _usersHomeController.stream;

  Future<UserDataModel> registerUser(
      {@required String username, @required String name}) async {
    try {
      final QuerySnapshot response = await _usersCollectionReference
          .where('username', isEqualTo: username)
          .limit(1)
          .getDocuments();
      if (response.documents.isNotEmpty) {
        throw Failure("User already exists with username $username");
      }
      final DocumentReference newUserDocReference =
          await _usersCollectionReference.add({
        "username": username,
        "name": name,
        // Keywords added for searching
        "keywords": generateKeywords([name, username])
      });
      final DocumentSnapshot snapshot = await newUserDocReference.get();
      return UserDataModel.fromDocumentSnapshot(snapshot);
    } catch (e) {
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
      throw Failure(e.toString());
    }
  }

  Future<List<UserDataModel>> searchUsers({@required String query}) async {
    try {
      final QuerySnapshot snapshot = await _usersCollectionReference
          .where('keywords', arrayContains: query)
          .getDocuments();
      if (snapshot.documents.isEmpty) {
        throw Failure("No users found!");
      }
      return _getUsersFromSnapshot(snapshot);
    } catch (e) {
      throw Failure(e.toString());
    }
  }

  void _onUsersAdded(QuerySnapshot snapshot) {
    final List<UserDataModel> list = _getUsersFromSnapshot(snapshot);
    _usersHomeController.add(list);
  }

  List<UserDataModel> _getUsersFromSnapshot(QuerySnapshot snapshot) {
    final List<UserDataModel> users = [];
    final List<DocumentSnapshot> documents = snapshot.documents;
    if (documents.isNotEmpty) {
      for (final DocumentSnapshot documentSnapshot in documents) {
        users.add(UserDataModel.fromDocumentSnapshot(documentSnapshot));
      }
    }
    return users;
  }

  List<MessageDataModel> _getMessagesFromSnapshot(QuerySnapshot snapshot) {
    final List<MessageDataModel> messages = [];
    final List<DocumentSnapshot> documents = snapshot.documents;
    if (documents.isNotEmpty) {
      for (final DocumentSnapshot documentSnapshot in documents) {
        messages.add(MessageDataModel.fromDocumentSnapshot(documentSnapshot));
      }
    }
    return messages;
  }

  Stream<List<MessageDataModel>> getMessagesStream(String groupId) {
    return messagesCollectionReference(groupId)
        .orderBy('time', descending: true)
        .snapshots()
        .map(_getMessagesFromSnapshot);
  }

  Future<void> sendMessage(
      {@required String groupId, @required MessageDataModel model}) async {
    try {
      await messagesCollectionReference(groupId).add(model.toMap());
    } catch (e) {
      print(e);
    }
  }
}
// final DocumentReference newUserDocReference =
//           await _usersCollectionReference.add({
//         "username": username,
//         "name": name,
//         // Keywords added for searching
//         "keywords": generateKeywords([name, username])
//       });
//       final DocumentSnapshot snapshot = await newUserDocReference.get();
