import 'package:chat_firebase/common/ui/ui_helpers.dart';
import 'package:flutter/material.dart';

void showCustomBottomSheet(
  BuildContext context, {
  Widget child,
  Function callOnThen,
  double bottomPadding = 32,
  Color barColor = const Color(0xffeeeeee),
}) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (BuildContext ctx) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16)),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 16, bottom: bottomPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 72,
                  height: 4,
                  decoration: BoxDecoration(
                      color: barColor, borderRadius: BorderRadius.circular(5)),
                ),
                lHeightSpan,
                child,
              ],
            ),
          ),
        );
      }).then((_) {
    if (callOnThen != null) callOnThen();
  });
}
