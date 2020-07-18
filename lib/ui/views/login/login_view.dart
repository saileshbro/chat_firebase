import 'package:chat_firebase/common/ui/dynamic_button.dart';
import 'package:chat_firebase/common/ui/ui_helpers.dart';
import 'package:chat_firebase/ui/views/login/login_viewmodel.dart';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class LoginView extends StatelessWidget {
  static const String route = "/login";

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
        builder: (BuildContext context, LoginViewModel model, Widget child) =>
            Scaffold(
              appBar: AppBar(
                title: const Text("Login"),
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
                            onChanged: model.onUsernameChanged,
                            validator: model.validateUsername,
                            // autovalidate: true,
                            decoration: InputDecoration(
                              contentPadding: sYPadding,
                              hintText: "username",
                              fillColor: Colors.grey[200],
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: Icon(Icons.alternate_email),
                            ),
                          ),
                          lHeightSpan,
                          DynamicRaisedButton(
                            onPressed: model.onLoginPressed,
                            color: Theme.of(context).primaryColor,
                            text: "Login",
                            loading: model.isBusy,
                          ),
                          xlHeightSpan,
                          GestureDetector(
                            onTap: model.goToRegister,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text(
                                  "Don't have an account?",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                sWidthSpan,
                                Text(
                                  "Register",
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
        viewModelBuilder: () => LoginViewModel());
  }
}
