import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/constants.dart';
import 'package:mobile/dialogs/InputDialog.dart';
import 'package:mobile/domain/ChildProfanityWord.dart';
import 'package:mobile/domain/ProfanityWord.dart';
import 'package:mobile/services/ChildProfanityWordService.dart';
import 'package:mobile/services/CommunicationService.dart';
import 'package:mobile/util/Utils.dart';

class ChildProfanityFilterListPage extends StatefulWidget {
  final String childNumber;

  const ChildProfanityFilterListPage({Key? key, required this.childNumber})
      : super(key: key);

  @override
  _ChildProfanityFilterListPageState createState() =>
      _ChildProfanityFilterListPageState(childNumber: childNumber);
}

class _ChildProfanityFilterListPageState
    extends State<ChildProfanityFilterListPage> {
  final childNumber;
  final ChildProfanityWordService childProfanityWordService = GetIt.I.get();
  final CommunicationService communicationService = GetIt.I.get();
  List<ChildProfanityWord> profanityWordList = [];
  List<ChildProfanityWord> filteredProfanityWordList = [];

  _ChildProfanityFilterListPageState({required this.childNumber});

  @override
  void initState() {
    super.initState();

    void reload() {
      childProfanityWordService
          .fetchAllWordsByChildNumber(childNumber)
          .then((wordList) {
        setState(() {
          profanityWordList = List.of(wordList);
          filteredProfanityWordList = List.of(wordList);
        });
      });
    }

    reload();

    communicationService.onNewProfanityWordToParent = () => reload;
  }

  @override
  void dispose() {
    super.dispose();
    communicationService.onNewProfanityWordToParent = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Child Profanity Filter List"),
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

  void _addProfanityWord() async {
    final input = await showInputDialog(
        context, "Please insert the profanity you want to filter.");
    if (input != null) {
      childProfanityWordService
          .insert(input, widget.childNumber)
          .then((profanityWord) {
        communicationService.sendNewProfanityWordToChild(
            profanityWord.phoneNumber,
            ProfanityWord(
                profanityWordRegex: profanityWord.profanityWordRegex,
                profanityID: profanityWord.profanityID,
                profanityOriginalWord: profanityWord.profanityOriginalWord),
            "insert");
        setState(() {
          profanityWordList.add(profanityWord);
          filteredProfanityWordList.add(profanityWord);
        });
      }).catchError((_) {
        showSnackBar(context, "This word has already been added.");
      });
    }
  }

  void _removeProfanityWord(ChildProfanityWord profanityWord) {
    childProfanityWordService
        .deleteByNumberAndID(widget.childNumber, profanityWord.profanityID)
        .then((_) {
      communicationService.sendNewProfanityWordToChild(
          profanityWord.phoneNumber,
          ProfanityWord(
              profanityWordRegex: profanityWord.profanityWordRegex,
              profanityID: profanityWord.profanityID,
              profanityOriginalWord: profanityWord.profanityOriginalWord),
          "delete");
      setState(() {
        profanityWordList.remove(profanityWord);
        filteredProfanityWordList.remove(profanityWord);
      });
    }).catchError((_) {
      showSnackBar(context, "The word you tried to remove is not added.");
    });
  }
}
