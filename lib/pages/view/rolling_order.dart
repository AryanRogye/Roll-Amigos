// ignore_for_file: must_be_immutable

import 'package:dice_pt2/components/firebase/firebase_functions.dart';
import 'package:flutter/material.dart';

class RollOrderPage extends StatefulWidget {
  String roomName;
  final Function(List<String>) onOrderChanged;
  RollOrderPage({
    super.key,
    required this.roomName,
    required this.onOrderChanged,
  });

  @override
  State<RollOrderPage> createState() => _RollOrderPageState();
}

class _RollOrderPageState extends State<RollOrderPage> {
  late List<String> emails = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //get the emails from the database
    getEmailsFromDB();
  }

  getEmailsFromDB() async {
    //get the emails from the database
    var emailList =
        await FirebaseFunctions.getRollingOrder(roomName: widget.roomName);
    setState(() {
      emails = emailList;
      isLoading = false;
    });
    return emailList;
  }

  void updateMyList(int oldIndex, int newIndex) {
    setState(
      () {
        if (oldIndex < newIndex) {
          newIndex--;
        }
        //get the tile we are moving
        final tile = emails.removeAt(oldIndex);

        //place the tile in the new pos
        emails.insert(newIndex, tile);
        widget.onOrderChanged(emails);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: FittedBox(
          child: Text("Roll Order For ${widget.roomName}",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold)),
        ),
        backgroundColor: Colors.black,
      ),
      body: ReorderableListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          for (var email in emails)
            ListTile(
              key: ValueKey(email),
              tileColor: Colors.grey.shade300,
              title: Text(email),
              trailing: ReorderableDragStartListener(
                index: emails.indexOf(email),
                child: const Icon(Icons.drag_handle),
              ),
            ),
        ],
        onReorder: (oldIndex, newIndex) => updateMyList(oldIndex, newIndex),
      ),
    );
  }
}
