import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/constants.dart';
import 'package:mobile/dialogs/InputDialog.dart';
import 'package:mobile/services/ProfanityWordService.dart';
import 'package:mobile/util/Utils.dart';

class ProfanityFilterListPage extends StatefulWidget {
  const ProfanityFilterListPage({Key? key}) : super(key: key);

  @override
  _ProfanityFilterListPageState createState() =>
      _ProfanityFilterListPageState();
}

class _ProfanityFilterListPageState extends State<ProfanityFilterListPage> {
  final ProfanityWordService profanityWordService = GetIt.I.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profanity Filter List"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            _buildSearchBar(context),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Align(
                          alignment: Alignment.center,
                          child: _buildBubble("Additional filters"))),
                  Expanded(
                      flex: 1,
                      child: Align(
                          alignment: Alignment.center,
                          child: _buildBubble("Removed filters"))),
                ],
              ),
            ),
            ListTile(
              title: Text("Add filter"),
              trailing: IconButton(
                onPressed: () => _addProfanityWord(),
                icon: Icon(Icons.add),
                splashRadius: 18,
              ),
              tileColor: Constants.orange,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (_, index) {
                  return ListTile(
                    title: Text("Regex"),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.cancel_outlined),
                      splashRadius: 18,
                    ),
                    dense: true,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildSearchBar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 4 / 5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Constants.darkGrey.withOpacity(0.5),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            size: 20,
          ),
          Expanded(
            child: TextField(
              onChanged: (String input) {},
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: "Search",
                contentPadding: EdgeInsets.all(2),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(String string) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.all(5),
      child: Text(string),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.black,
        ),
      ),
    );
  }

  void _addProfanityWord() async {
    final input = await showInputDialog(
        context, "Please insert the profanity you want to filter.");
    if (input != null)
      profanityWordService.addWord(input).catchError((_) {
        showSnackBar(context, "This word has already been added.");
      });
  }
}
