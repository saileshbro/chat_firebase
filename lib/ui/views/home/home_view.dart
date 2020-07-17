import 'package:chat_firebase/app/locator.dart';
import 'package:chat_firebase/ui/views/home/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatelessWidget {
  static const route = "/home";
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.nonReactive(
        builder: (BuildContext context, HomeViewModel model, Widget child) =>
            Scaffold(
              appBar: AppBar(
                title: const Text('Home Page'),
                centerTitle: true,
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.exit_to_app),
                      onPressed: model.onLogoutPressed)
                ],
              ),
              body: const Center(
                child: Text("Logged in"),
              ),
            ),
        viewModelBuilder: () => locator<HomeViewModel>());
  }
}
