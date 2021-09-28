import 'package:flutter/material.dart';
import 'package:mobile/constants.dart';

class ProfanityFilterListPage extends StatefulWidget {
  const ProfanityFilterListPage({Key? key}) : super(key: key);

  @override
  _ProfanityFilterListPageState createState() =>
      _ProfanityFilterListPageState();
}

class _ProfanityFilterListPageState extends State<ProfanityFilterListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profanity Filter List"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(context),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Align(
                          alignment: Alignment.center,
                          child: _buildBubble("Added filters"))),
                  Expanded(
                      flex: 1,
                      child: Align(
                          alignment: Alignment.center,
                          child: _buildBubble("Removed filters"))),
                ],
              ),
            ),
            ListTile(
              title: Text("Add/Remove filter"),
              trailing: IconButton(
                onPressed: () {},
                icon: Icon(Icons.add),
                splashRadius: 18,
              ),
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
}
