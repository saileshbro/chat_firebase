import 'package:chat_firebase/app/locator.dart';
import 'package:chat_firebase/common/ui/dynamic_button.dart';
import 'package:chat_firebase/common/ui/ui_helpers.dart';
import 'package:chat_firebase/ui/views/register/register_viewmodel.dart';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class RegisterView extends StatelessWidget {
  static const String route = "/register";
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegisterViewModel>.reactive(
        disposeViewModel: false,
        builder: (BuildContext context, RegisterViewModel model,
                Widget child) =>
            Scaffold(
              appBar: AppBar(
                title: const Text("Register"),
                elevation: 0.0,
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: sPagePadding,
                  child: Center(
                    child: Form(
                      key: model.formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          xxlHeightSpan,
                          const FlutterLogo(
                            size: 96,
                          ),
                          mHeightSpan,
                          const Text(
                            "Fire Chat",
                            style: TextStyle(fontSize: 24),
                          ),
                          lHeightSpan,
                          TextFormField(
                            validator: model.validateUsername,
                            onChanged: model.onUsernameChanged,
                            decoration: InputDecoration(
                              contentPadding: sYPadding,
                              hintText: "username",
                              fillColor: Colors.grey[200],
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Icons.alternate_email),
                            ),
                          ),
                          mHeightSpan,
                          TextFormField(
                            validator: model.validateName,
                            onChanged: model.onNameChanged,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              contentPadding: sYPadding,
                              hintText: "name",
                              fillColor: Colors.grey[200],
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                          lHeightSpan,
                          DynamicRaisedButton(
                            onPressed: model.onRegisterPressed,
                            color: Theme.of(context).primaryColor,
                            text: "Register",
                            loading: model.isBusy,
                          ),
                          xlHeightSpan,
                          GestureDetector(
                            onTap: model.goToLogin,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text(
                                  "Already have an account?",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                sWidthSpan,
                                Text(
                                  "Login",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        viewModelBuilder: () => locator<RegisterViewModel>());
  }
}
