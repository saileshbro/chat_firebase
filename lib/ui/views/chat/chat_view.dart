import 'package:chat_firebase/common/helpers/random_color.dart';
import 'package:chat_firebase/common/ui/receiver_chat_item.dart';
import 'package:chat_firebase/common/ui/sender_chat_item.dart';
import 'package:chat_firebase/common/ui/ui_helpers.dart';
import 'package:chat_firebase/app/locator.dart';
import 'package:chat_firebase/datamodels/message_datamodel.dart';
import 'package:chat_firebase/datamodels/user_datamodel.dart';
import 'package:chat_firebase/ui/views/chat/chat_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:chat_firebase/common//ui/show_custom_botton_sheet.dart';

class ChatView extends StatelessWidget {
  static const route = "/chat";
  final UserDataModel otherUser;

  final TextEditingController _controller = TextEditingController();
  ChatView({Key key, this.otherUser}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatViewModel>.reactive(
        disposeViewModel: false,
        onModelReady: (model) => model.init(otherUser),
        builder: (BuildContext context, ChatViewModel model, Widget _) =>
            Scaffold(
              appBar: AppBar(
                title: Text(otherUser.name),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: model.onBackPressed,
                ),
                centerTitle: true,
                elevation: 0,
              ),
              body: Column(
                children: <Widget>[
                  Expanded(child: _getBody(model)),
                  SizedBox(
                    height: kToolbarHeight,
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.add_a_photo),
                          onPressed: () {
                            showCustomBottomSheet(
                              context,
                              child: MultimediaPicker(
                                onCameraPressed: model.clickImage,
                                onGalleryPressed: model.pickImage,
                              ),
                            );
                          },
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: TextFormField(
                              controller: _controller,
                              textInputAction: TextInputAction.send,
                              onFieldSubmitted: (String str) {
                                _controller.clear();
                              },
                              minLines: 1,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 8),
                                hintText: "type a message...",
                                fillColor: Colors.grey[200],
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.send,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            if (_controller.text.trim().isNotEmpty) {
                              model.onMessageSent(_controller.text.trim());
                            }
                            _controller.clear();
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
        viewModelBuilder: () => locator<ChatViewModel>());
  }

  Widget _getBody(ChatViewModel model) {
    if (model.messages == null || model.isBusy) {
      return const Center(child: CircularProgressIndicator());
    }
    if (model.hasError) {
      return Center(child: Text(model.modelError));
    }
    return ListView.builder(
      padding: sXPagePadding.add(const EdgeInsets.only(bottom: 10)),
      itemBuilder: (BuildContext context, int index) {
        final MessageDataModel message = model.messages[index];
        if (message.sender == model.loggedUser.userDataModel.id) {
          return SenderChatItem(
            message: message,
            name: model.loggedUser.userDataModel.name[0],
            color: getRandomColor(),
            isLastMessage: isMyLastMessage(index, model),
          );
        } else {
          return ReceiverChatItem(
            message: message,
            name: otherUser.name,
            color: getRandomColor(),
            isLastMessage: isTheirLastMessage(index, model),
          );
        }
      },
      reverse: true,
      itemCount: model.messages.length,
    );
  }

  bool isMyLastMessage(int index, ChatViewModel model) {
    return (index > 0 &&
            model.messages != null &&
            model.messages[index - 1].sender !=
                model.loggedUser.userDataModel.id) ||
        index == 0;
  }

  bool isTheirLastMessage(int index, ChatViewModel model) {
    return (index > 0 &&
            model.messages != null &&
            model.messages[index - 1].sender ==
                model.loggedUser.userDataModel.id) ||
        index == 0;
  }
}

class MultimediaPicker extends StatelessWidget {
  final Function onCameraPressed;
  final Function onGalleryPressed;

  const MultimediaPicker({
    Key key,
    @required this.onCameraPressed,
    @required this.onGalleryPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: xlXPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              onCameraPressed();
            },
            child: Container(
              padding: mPadding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 4),
                      color: Colors.grey[300],
                      blurRadius: 16),
                ],
                color: Colors.white,
              ),
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.camera_alt,
                    size: 32,
                  ),
                  xsHeightSpan,
                  const Text("Take an picture!"),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              onGalleryPressed();
            },
            child: Container(
              padding: mPadding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 4),
                      color: Colors.grey[300],
                      blurRadius: 16),
                ],
                color: Colors.white,
              ),
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.image,
                    size: 32,
                  ),
                  xsHeightSpan,
                  const Text("Pick a picture!"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
