import 'dart:async';
import 'dart:io';

import 'package:chat_firebase/app/failure.dart';
import 'package:chat_firebase/common/helpers/generate_group_id.dart';
import 'package:chat_firebase/common/helpers/generate_keywords.dart';
import 'package:chat_firebase/datamodels/message_datamodel.dart';
import 'package:chat_firebase/datamodels/user_datamodel.dart';
import 'package:chat_firebase/services/user_data_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  final UserDataService _userDataService;
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection('users');
  final StorageReference _storageReference = FirebaseStorage.instance.ref();
  CollectionReference messagesCollectionReference(String conversationId) {
    return Firestore.instance
        .collection("messages")
        .document(conversationId)
        .collection(conversationId);
  }

  final StreamController<List<UserDataModel>> _usersHomeController =
      StreamController<List<UserDataModel>>();

  CollectionReference get usersCollectionReference => _usersCollectionReference;
  List _recipients = [];
  DocumentReference _myDocumentReference;

  FirebaseService(this._userDataService) {
    _myDocumentReference = Firestore.instance
        .collection('users')
        .document(_userDataService.userDataModel.id);
    _myDocumentReference.snapshots().listen(_onRecipientsChanged);
    _usersCollectionReference.snapshots().listen(_onUsersAdded);
  }

  void _onRecipientsChanged(DocumentSnapshot snapshot) {
    if (snapshot.data == null || snapshot.data['recipients'] == null) {
      return;
    } else {
      _recipients = snapshot.data['recipients'] as List;
    }
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
      return _getUsersFromSnapshot(
          snapshot,
          (documentSnapshot) =>
              _userDataService.userDataModel.id != documentSnapshot.documentID);
    } catch (e) {
      throw Failure(e.toString());
    }
  }

  void _onUsersAdded(QuerySnapshot snapshot) {
    final List<UserDataModel> list = _getUsersFromSnapshot(
        snapshot,
        (documentSnapshot) =>
            _recipients.contains(documentSnapshot.documentID));
    _usersHomeController.add(list);
  }

  List<UserDataModel> _getUsersFromSnapshot(QuerySnapshot snapshot,
      bool Function(DocumentSnapshot documentSnapshot) predicate) {
    final List<UserDataModel> users = [];
    final List<DocumentSnapshot> documents = snapshot.documents;
    if (documents.isNotEmpty) {
      for (final DocumentSnapshot documentSnapshot in documents) {
        if (predicate(documentSnapshot)) {
          users.add(UserDataModel.fromDocumentSnapshot(documentSnapshot));
        }
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

  Stream<List<MessageDataModel>> getMessagesStream(String otherId) {
    return messagesCollectionReference(
            generateGroupId(_userDataService.userDataModel.id, otherId))
        .orderBy('time', descending: true)
        .snapshots()
        .map(_getMessagesFromSnapshot);
  }

  Future<void> sendMessage(
      {@required String receiverId, @required MessageDataModel model}) async {
    final String groupId =
        generateGroupId(_userDataService.userDataModel.id, receiverId);
    await Future.wait([
      _markRecipient(receiverId),
      messagesCollectionReference(groupId).add(model.toMap())
    ]);
  }

  Future<void> sendImage(
      {@required String receiverId,
      @required File image,
      @required String time}) async {
    final StorageReference storageReference = _storageReference
        .child("images/${DateTime.now().millisecondsSinceEpoch}");
    final StorageUploadTask imageUploadTask = storageReference.putFile(image);
    final StorageTaskSnapshot snapshot = await imageUploadTask.onComplete;
    final downloadUrl = await snapshot.ref.getDownloadURL();
    final String groupId =
        generateGroupId(_userDataService.userDataModel.id, receiverId);
    await Future.wait([
      _markRecipient(receiverId),
      messagesCollectionReference(groupId).add(MessageDataModel(
        message: downloadUrl,
        messageType: MessageType.image,
        receiver: receiverId,
        sender: _userDataService.userDataModel.id,
        time: time,
      ).toMap())
    ]);
  }

  Future<void> _markRecipient(String receiverId) async {
    List receiverRecipients = [];
    final DocumentReference _receiverDocumentReference =
        Firestore.instance.collection('users').document(receiverId);
    final DocumentSnapshot receiverDocumentSnapShot =
        await _receiverDocumentReference.get();
    if (!_recipients.contains(receiverId)) {
      _recipients.add(receiverId);
    }
    if (receiverDocumentSnapShot.data['recipients'] == null) {
      receiverRecipients.add(_userDataService.userDataModel.id);
    } else {
      receiverRecipients = receiverDocumentSnapShot.data['recipients'] as List;
      if (!receiverRecipients.contains(_userDataService.userDataModel.id)) {
        receiverRecipients.add(_userDataService.userDataModel.id);
      }
    }
    await Future.wait([
      _myDocumentReference.updateData({'recipients': _recipients}),
      _receiverDocumentReference.updateData({'recipients': receiverRecipients})
    ]);
    return;
  }
}
