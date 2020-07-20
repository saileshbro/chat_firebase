import 'package:chat_firebase/common/helpers/generate_group_id.dart';
import 'package:chat_firebase/datamodels/message_datamodel.dart';
import 'package:chat_firebase/datamodels/user_datamodel.dart';
import 'package:chat_firebase/services/firebase_service.dart';
import 'package:chat_firebase/services/user_data_service.dart';
import 'package:stacked/stacked.dart';

class ChatViewModel extends BaseViewModel {
  String _messageToSend;
  final FirebaseService _firebaseService;
  final UserDataService _userDataService;
  UserDataService get loggedUser => _userDataService;
  String _groupId;
  UserDataModel _otherUser;
  List<MessageDataModel> messages;
  ChatViewModel(this._firebaseService, this._userDataService);
  void init(UserDataModel receiver) {
    _groupId = generateGroupId(_userDataService.userDataModel.id, receiver.id);
    _otherUser = receiver;
    _firebaseService
        .getMessagesStream(
            generateGroupId(_userDataService.userDataModel.id, receiver.id))
        .listen(_onMessagedChanged);
  }

  void onMessageSent(String message) {
    _messageToSend = message;
    _firebaseService.sendMessage(
      groupId: _groupId,
      model: MessageDataModel(
        message: _messageToSend,
        messageType: MessageType.message,
        receiver: _otherUser.id,
        sender: _userDataService.userDataModel.id,
        time: DateTime.now().millisecondsSinceEpoch.toString(),
      ),
    );
  }

  void _onMessagedChanged(List<MessageDataModel> newMessageList) {
    messages = newMessageList;
    if (messages == null) {
      setBusy(true);
    } else {
      if (messages.isEmpty) {
        setError("No messages available");
      } else {
        setBusy(false);
      }
    }
  }
}
