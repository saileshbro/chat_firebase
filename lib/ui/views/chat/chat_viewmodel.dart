import 'dart:io';

import 'package:chat_firebase/datamodels/message_datamodel.dart';
import 'package:chat_firebase/datamodels/user_datamodel.dart';
import 'package:chat_firebase/services/firebase_service.dart';
import 'package:chat_firebase/services/user_data_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ChatViewModel extends BaseViewModel {
  String _messageToSend;
  final FirebaseService _firebaseService;
  final UserDataService _userDataService;
  final NavigationService _navigationService;
  File _image;
  UserDataService get loggedUser => _userDataService;
  UserDataModel _otherUser;
  final ImagePicker picker = ImagePicker();
  List<MessageDataModel> get messages => _messages;
  List<MessageDataModel> _messages;
  ChatViewModel(
      this._firebaseService, this._userDataService, this._navigationService);
  final Map<String, String> _fileImageCache = {};
  Map<String, String> get fileImageCache => _fileImageCache;

  void init(UserDataModel receiver) {
    _otherUser = receiver;
    _firebaseService
        .getMessagesStream(_otherUser.id)
        .listen(_onMessagesChanged);
  }

  Future<void> _getImage(ImageSource imageSource) async {
    final imagePath = await picker.getImage(source: imageSource);
    _image = File(imagePath.path);
    final String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    _fileImageCache[timeStamp] = imagePath.path;
    _messages = [
      MessageDataModel(
        message: imagePath.path,
        messageType: MessageType.image,
        receiver: _otherUser.id,
        isImageTemp: true,
        sender: _userDataService.userDataModel.id,
        time: timeStamp,
      ),
      ..._messages
    ];
    notifyListeners();
    await _firebaseService.sendImage(
      receiverId: _otherUser.id,
      image: _image,
      time: timeStamp,
    );
  }

  Future<void> clickImage() async {
    await _getImage(ImageSource.camera);
  }

  Future<void> pickImage() async {
    await _getImage(ImageSource.gallery);
  }

  void onMessageSent(String message) {
    _messageToSend = message;
    _firebaseService.sendMessage(
      receiverId: _otherUser.id,
      model: MessageDataModel(
        message: _messageToSend,
        messageType: MessageType.message,
        receiver: _otherUser.id,
        sender: _userDataService.userDataModel.id,
        time: DateTime.now().millisecondsSinceEpoch.toString(),
      ),
    );
  }

  void _onMessagesChanged(List<MessageDataModel> newMessageList) {
    _messages = newMessageList;
    if (_messages == null) {
      setBusy(true);
      return;
    }
    if (_messages.isEmpty) {
      setError("No messages available");
    } else {
      clearErrors();
      setBusy(false);
    }
  }

  void onBackPressed() {
    _firebaseService.clearChattingWith();
    _navigationService.back();
  }
}
