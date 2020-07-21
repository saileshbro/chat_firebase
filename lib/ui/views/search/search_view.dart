import 'package:chat_firebase/app/locator.dart';
import 'package:chat_firebase/common/ui/ui_helpers.dart';
import 'package:chat_firebase/common/ui/user_list_tile.dart';
import 'package:chat_firebase/ui/views/search/search_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SearchView extends StatelessWidget {
  static const route = "/search";
  final FocusNode _searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchViewModel>.reactive(
        onModelReady: (model) {
          _searchFocusNode.requestFocus();
        },
        disposeViewModel: false,
        builder: (BuildContext context, SearchViewModel model, Widget child) =>
            Scaffold(
              appBar: AppBar(
                elevation: 0.0,
                title: TextFormField(
                  onChanged: model.onChanged,
                  onEditingComplete: model.onSubmitted,
                  focusNode: _searchFocusNode,
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    contentPadding: sPadding,
                    hintText: "search with name or username",
                    hintStyle: TextStyle(color: Colors.white70),
                    focusColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              body: Center(
                child: getUi(model),
              ),
            ),
        viewModelBuilder: () => locator<SearchViewModel>());
  }

  Widget getUi(SearchViewModel model) {
    if (model.isBusy) return const CircularProgressIndicator();
    if (model.hasError) return Text(model.modelError);
    if (model.init) return const Text("Type to search by name or username!");
    if (model.isEmpty) return const Text("No results found!");
    return ListView.builder(
      padding: sPagePadding,
      itemBuilder: (BuildContext context, int index) => UserListTile(
        userDataModel: model.users[index],
        onPressed: () => model.goToChatScreen(model.users[index]),
      ),
      itemCount: model.users.length,
    );
  }
}
