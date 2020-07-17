import 'package:flutter/material.dart';

class DynamicRaisedButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final bool loading;
  final Color color;

  const DynamicRaisedButton(
      {Key key, this.onPressed, this.text, this.loading = false, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: double.infinity,
      child: RaisedButton(
        padding: const EdgeInsets.all(0),
        color: color,
        disabledColor: color.withOpacity(0.7),
        onPressed: loading ? null : onPressed,
        elevation: 2,
        child: loading
            ? Container(
                height: 25,
                width: 25,
                child: const CircularProgressIndicator(),
              )
            : Text(
                text?.toUpperCase() ?? "",
                style:
                    TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
              ),
      ),
    );
  }
}
