import 'package:chat_firebase/common/helpers/random_color.dart';
import 'package:chat_firebase/common/ui/ui_helpers.dart';
import 'package:chat_firebase/datamodels/user_datamodel.dart';
import 'package:flutter/material.dart';

class UserListTile extends StatelessWidget {
  final UserDataModel userDataModel;
  final VoidCallback onPressed;
  const UserListTile({@required this.userDataModel, @required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: sPadding,
              child: CircleAvatar(
                radius: 22,
                backgroundColor: getRandomColor(),
                child: Text(
                  userDataModel.name[0],
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            sWidthSpan,
            Expanded(
              child: Text(
                userDataModel.name,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
