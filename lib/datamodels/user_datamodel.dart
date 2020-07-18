import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserDataModel {
  String id;
  String username;
  String name;

  UserDataModel(
      {@required this.id, @required this.username, @required this.name});

  UserDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String;
    username = json['username'] as String;
    name = json['name'] as String;
  }
  UserDataModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    username = snapshot.data['username'] as String;
    name = snapshot.data['name'] as String;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['username'] = username;
    data['name'] = name;
    return data;
  }

  bool isEmpty() {
    return id == null ||
        id.isEmpty ||
        username == null ||
        username.isEmpty ||
        name == null ||
        name.isEmpty;
  }
}
