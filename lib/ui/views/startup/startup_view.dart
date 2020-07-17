import 'package:chat_firebase/app/locator.dart';
import 'package:chat_firebase/common/ui/ui_helpers.dart';
import 'package:chat_firebase/ui/views/startup/startup_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class StartUpView extends StatelessWidget {
  static const String route = "/";
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
      builder: (BuildContext context, StartUpViewModel model, Widget child) =>
          Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Firebase Chat App"),
              sHeightSpan,
              const CircularProgressIndicator()
            ],
          ),
        ),
      ),
      viewModelBuilder: () => locator<StartUpViewModel>(),
      onModelReady: (model) => model.handleStartup(),
    );
  }
}
