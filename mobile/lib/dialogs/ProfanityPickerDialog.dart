import 'package:flutter/material.dart';
import 'package:mobile/constants.dart';
import 'package:mobile/util/Tuple.dart';

Future<String?> showProfanityPickerDialog(
    BuildContext context, List<Tuple<int, String>> words) {
  return showDialog<String>(
      context: context,
      builder: (context) => ProfanityPickerDialog(words: words));
}

class ProfanityPickerDialog extends StatefulWidget {
  final List<Tuple<int, String>> words;

  ProfanityPickerDialog({required this.words});

  @override
  _ProfanityPickerDialogState createState() => _ProfanityPickerDialogState();
}

class _ProfanityPickerDialogState extends State<ProfanityPickerDialog> {
  String currentlySelectedPackage = "";
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Pick a pack to send",
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.words.isEmpty)
            ListTile(
              title: Text(
                "You have no packages to send",
                textAlign: TextAlign.center,
              ),
            ),
          if (widget.words.isNotEmpty)
            Column(
              children: _buildPacks(),
            ),
        ],
      ),
      actions: [
        if (widget.words.isNotEmpty)
          TextButton(
            onPressed: () {
              Navigator.pop(context, currentlySelectedPackage);
            },
            child: Text("Send"),
          ),
        TextButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
            child: Text("Cancel"))
      ],
    );
  }

  List<Widget> _buildPacks() {
    final packs = <Widget>[];
    widget.words.forEach((word) {
      packs.add(Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: ListTile(
          onTap: () {
            setState(() {});
            currentlySelectedPackage = word.second;
          },
          tileColor:
              word.second == currentlySelectedPackage ? Constants.orange : null,
          title: Text(
            word.second,
            textAlign: TextAlign.center,
          ),
        ),
      ));
    });
    return packs;
  }
}
