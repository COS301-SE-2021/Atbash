import 'package:flutter/material.dart';
import 'package:mobile/constants.dart';

class ProfanityManagerPage extends StatefulWidget {
  const ProfanityManagerPage({Key? key}) : super(key: key);

  @override
  _ProfanityManagerPageState createState() => _ProfanityManagerPageState();
}

class _ProfanityManagerPageState extends State<ProfanityManagerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profanity Management",
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 1 / 6),
            decoration: BoxDecoration(
                // border: Border(
                //   bottom: BorderSide(
                //     color: Colors.black,
                //   ),
                // ),
                ),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.black,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.search),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          "Profanity Packages",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(color: Constants.orange),
                        child: ListTile(
                          title: Text("Add Profanity Package"),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.add),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: 12,
                            itemBuilder: (context, index) {
                              return Center(
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 25),
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: InkWell(
                                    onLongPress: () {},
                                    child: Text(
                                      "Package With very long name",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: Colors.black,
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          "Profanity Words",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(color: Constants.orange),
                        child: ListTile(
                          title: Text("Add Profanity Word"),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.add),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: 16,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text("Profanity word!"),
                                    trailing: IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.cancel),
                                    ),
                                  ),
                                  Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: Colors.black,
                                  )
                                ],
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
