import 'package:chat_firebase/app/locator.dart';
import 'package:chat_firebase/common/ui/ui_helpers.dart';
import 'package:chat_firebase/common/ui/user_list_tile.dart';
import 'package:chat_firebase/ui/views/home/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatelessWidget {
  static const route = "/home";
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
        disposeViewModel: false,
        builder: (BuildContext context, HomeViewModel model, Widget child) =>
            Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: model.onSearchPressed,
                child: Icon(Icons.search),
              ),
              appBar: AppBar(
                elevation: 0,
                title: Text(model.loggedinUsername),
                centerTitle: true,
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.exit_to_app),
                      onPressed: model.onLogoutPressed)
                ],
              ),
              body: Center(
                child: _getBody(model),
              ),
            ),
        viewModelBuilder: () => locator<HomeViewModel>());
  }

  Widget _getBody(HomeViewModel model) {
    if (model.users == null || model.isBusy) {
      return const CircularProgressIndicator();
    }
    if (model.hasError) {
      return Text(model.modelError);
    }
    return ListView.separated(
      padding: sPagePadding,
      itemCount: model.users.length,
      itemBuilder: (BuildContext context, int index) {
        return UserListTile(
          userDataModel: model.users[index],
          onPressed: () => model.goToChatScreen(model.users[index]),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return sHeightSpan;
      },
    );
  }
}
