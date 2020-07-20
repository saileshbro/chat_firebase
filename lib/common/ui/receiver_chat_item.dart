import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_firebase/common/ui/ui_helpers.dart';
import 'package:chat_firebase/datamodels/message_datamodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReceiverChatItem extends StatelessWidget {
  final MessageDataModel message;
  final bool isLastMessage;
  final Color color;
  final String name;
  const ReceiverChatItem({
    Key key,
    @required this.message,
    @required this.isLastMessage,
    @required this.color,
    @required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            if (isLastMessage)
              Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(21),
                ),
                height: 42,
                width: 42,
                child: Center(
                  child: Text(
                    name[0],
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            else
              const SizedBox(width: 42.0),
            if (message.messageType == MessageType.message)
              Expanded(
                child: Container(
                  padding: mPadding,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey[300],
                  ),
                  margin: const EdgeInsets.only(top: 4.0, left: 4.0),
                  child: Text(
                    message.message,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            if (message.messageType == MessageType.image)
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 4.0, left: 4.0),
                  child: FlatButton(
                    onPressed: () {},
                    padding: const EdgeInsets.all(0),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          // padding: const EdgeInsets.all(70.0),
                          height: 180,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                          child:
                              const Center(child: CircularProgressIndicator()),
                        ),
                        imageUrl: message.message,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            sWidthSpan,
          ],
        ),
        // Time
        if (isLastMessage)
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 2,
                  color: Colors.grey[300],
                ),
              ),
              xsWidthSpan,
              Column(
                children: <Widget>[
                  sHeightSpan,
                  Text(
                    DateFormat('dd MMM kk:mm').format(DateTime.now()),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontStyle: FontStyle.italic),
                  ),
                  sHeightSpan,
                ],
              ),
              xsWidthSpan,
              Expanded(
                child: Container(
                  height: 2,
                  color: Colors.grey[300],
                ),
              ),
            ],
          )
        else
          const SizedBox.shrink()
      ],
    );
  }
}