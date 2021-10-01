import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/constants.dart';
import 'package:mobile/dialogs/InputDialog.dart';
import 'package:mobile/domain/Parent.dart';
import 'package:mobile/domain/ProfanityWord.dart';
import 'package:mobile/services/CommunicationService.dart';
import 'package:mobile/services/ParentService.dart';
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
  final ParentService parentService = GetIt.I.get();
  final CommunicationService communicationService = GetIt.I.get();
  List<ProfanityWord> profanityWordList = [];
  List<ProfanityWord> filteredProfanityWordList = [];
  Parent? hasParent;

  @override
  void initState() {
    super.initState();
    profanityWordService.fetchAll().then((wordList) {
      setState(() {
        profanityWordList = List.of(wordList);
        filteredProfanityWordList = List.of(wordList);
      });
    });
    parentService.fetchByEnabled().then((parent) {
      setState(() {
        hasParent = parent;
      });
    }).catchError((_) {});
  }

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
            SizedBox(
              height: 10,
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
                itemCount: filteredProfanityWordList.length,
                itemBuilder: (_, index) {
                  return ListTile(
                    title: Text(
                        filteredProfanityWordList[index].profanityOriginalWord),
                    trailing: IconButton(
                      onPressed: () => _removeProfanityWord(
                          filteredProfanityWordList[index]),
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

  void _filter(String value) {
    setState(() {
      filteredProfanityWordList = profanityWordList
          .where((profanityWord) => profanityWord.profanityOriginalWord
              .contains(RegExp(value, caseSensitive: false)))
          .toList();
    });
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
              onChanged: (String input) => _filter(input),
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
    if (input != null) {
      profanityWordService.addWord(input).then((profanityWord) {
        final parent = hasParent;
        if (parent != null)
          communicationService.sendNewProfanityWordToParent(
              parent.phoneNumber, profanityWord, "insert");
        setState(() {
          profanityWordList.add(profanityWord);
          filteredProfanityWordList.add(profanityWord);
        });
      }).catchError((_) {
        showSnackBar(context, "This word has already been added.");
      });
    }
  }

  void _removeProfanityWord(ProfanityWord profanityWord) {
    profanityWordService.deleteByID(profanityWord.profanityID).then((_) {
      final parent = hasParent;
      if (parent != null)
        communicationService.sendNewProfanityWordToParent(
            parent.phoneNumber, profanityWord, "delete");
      setState(() {
        profanityWordList.remove(profanityWord);
        filteredProfanityWordList.remove(profanityWord);
      });
    }).catchError((_) {
      showSnackBar(context, "The word you tried to remove is not added.");
    });
  }
}
