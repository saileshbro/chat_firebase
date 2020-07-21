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
                height: 36,
                width: 36,
                child: Center(
                  child: Text(
                    name[0],
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            else
              const SizedBox(width: 36.0),
            if (message.messageType == MessageType.message)
              Flexible(
                child: Container(
                  padding: mXPadding.add(sYPadding),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(4),
                      topLeft: Radius.circular(4),
                      bottomRight: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    color: Colors.greenAccent[100],
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
                  constraints: const BoxConstraints(maxHeight: 180),
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 4.0, right: 4.0),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                ),
                                child: const Padding(
                                  padding: sPadding,
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                            imageUrl: message.message,
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
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
                    DateFormat('dd MMM kk:mm').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            int.parse(message.time))),
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
