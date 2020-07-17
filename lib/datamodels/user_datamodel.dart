import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserDataModel {
  String id;
  String username;

  UserDataModel({@required this.id, @required this.username});

  UserDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String;
    username = json['username'] as String;
  }
  UserDataModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    username = snapshot.data['username'] as String;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['username'] = username;
    return data;
  }

  bool isEmpty() {
    return id == null || id.isEmpty || username == null || username.isEmpty;
  }
}
