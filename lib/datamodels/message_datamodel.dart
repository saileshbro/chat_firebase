import 'package:cloud_firestore/cloud_firestore.dart';

class MessageDataModel {
  String sender;
  String receiver;
  MessageType messageType;
  String time;
  String message;
  bool isImageTemp = false;
  MessageDataModel({
    this.sender,
    this.receiver,
    this.message,
    this.messageType,
    this.time,
    this.isImageTemp,
  });

  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'receiver': receiver,
      'message': message,
      'messageType': messageType.index,
      'time': time,
    };
  }

  MessageDataModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    messageType = MessageType.values[snapshot.data['messageType']];
    sender = snapshot.data['sender'] as String;
    receiver = snapshot.data['receiver'] as String;
    time = snapshot.data['time'] as String;
    message = snapshot.data['message'] as String;
  }

  @override
  String toString() {
    return 'MessageDataModel(sender: $sender, receiver: $receiver, messageType: $messageType, time: $time, message: $message)';
  }
}

enum MessageType { message, image }
