import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_firebase/common/ui/ui_helpers.dart';
import 'package:chat_firebase/datamodels/message_datamodel.dart';
import 'package:chat_firebase/ui/views/chat/chat_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class SenderChatItem extends ViewModelWidget<ChatViewModel> {
  final MessageDataModel message;
  final bool isLastMessage;
  final Color color;
  final String name;

  const SenderChatItem({
    Key key,
    @required this.message,
    @required this.isLastMessage,
    @required this.color,
    @required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ChatViewModel model) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            sWidthSpan,
            if (message.messageType == MessageType.message)
              Flexible(
                child: Container(
                  padding: mXPadding.add(sYPadding),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(4),
                      topRight: Radius.circular(4),
                      bottomLeft: Radius.circular(16),
                      topLeft: Radius.circular(16),
                    ),
                    color: Colors.lightBlueAccent[100],
                  ),
                  margin: const EdgeInsets.only(top: 4.0, right: 4.0),
                  child: Text(
                    message.message,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            if (message.messageType == MessageType.image)
              // Image
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 180),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: <Widget>[
                        const Spacer(),
                        Container(
                          margin: const EdgeInsets.only(top: 4.0, right: 4.0),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            child: CachedNetworkImage(
                              placeholder: (context, url) => Center(
                                child: Container(
                                  decoration: model.fileImageCache
                                          .containsKey(message.time)
                                      ? const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8.0),
                                          ),
                                        )
                                      : BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(8.0),
                                          ),
                                        ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      if (model.fileImageCache
                                          .containsKey(message.time))
                                        Image.file(
                                          File(
                                            model.fileImageCache[message.time],
                                          ),
                                        ),
                                      const Padding(
                                        padding: sPadding,
                                        child: CircularProgressIndicator(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              imageUrl: message.message,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            else
              const SizedBox(width: 36.0),

            // Sticker
          ],
        ),
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
