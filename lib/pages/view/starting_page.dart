// ignore_for_file: no_leading_underscores_for_local_identifiers, avoid_print, unused_local_variable, dead_code, use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dice_pt2/components/firebase/firebase_functions.dart';
import 'package:dice_pt2/models/join_room_entry.dart';
import 'package:dice_pt2/models/my_game_start.dart';
import 'package:dice_pt2/models/start_room_entry.dart';
import 'package:dice_pt2/pages/view/dice_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

// ignore: must_be_immutable
class StartingPage extends StatefulWidget {
  SharedPreferences prefs;
  StartingPage({
    super.key,
    required this.prefs,
  });

  @override
  State<StartingPage> createState() => _StartingPageState();
}

class _StartingPageState extends State<StartingPage> {
  TutorialCoachMark? tutorialCoachMark;
  List<TargetFocus> targets = [];

  //SETTINGS KEYS FOR THE IN APP TUTORIAL

  @override
  void initState() {
    super.initState();

    // Check if the tutorial has been shown before
  }

  bool signOutConfirm = false;
  bool roomCreationDone = false;

  //controllers for the room name and password
  final TextEditingController _RoomNameController = TextEditingController();
  final TextEditingController _RoomPasswordController = TextEditingController();

  @override
  dispose() {
    _RoomNameController.dispose();
    _RoomPasswordController.dispose();
    super.dispose();
  }

  drawProfilePicture() {
    return FutureBuilder(
      future: FirebaseFunctions.getFirstNameLastName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var names = snapshot.data;
          return ProfilePicture(
              name: "${names[0]} ${names[1]}", radius: 50, fontsize: 20);
        }
        return const CircularProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dice With Friends',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            )),
        actions: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: drawProfilePicture(),
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //need to bring the 2 starting room into the center of the screen
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),

              //THIS THE PLACE WHERE THE BUTTONS TO START A ROOM AND JOIN A ROOM WILL BE
              //THIS IS THE MAIN PART OF THE APP

              //Button For Starting a Room
              MyGameStart(
                text: "Start Game",
                colorBackground: Colors.blue[50],
                onTapFunction: showBottomScreenForStartingRoom,
              ),

              //Button for joining a Room
              const SizedBox(height: 20),
              MyGameStart(
                text: "Join Game",
                colorBackground: Colors.green[50],
                onTapFunction: showBottomScreenForJoiningRoom,
              ),
              //End Of the Buttons
            ],
          ),
        ),
      ),
      //THIS IS THE BOTTOM NAVIGATION BAR
      //THIS IS WHERE U CAN GO TO THE HOME PAGE AND THE SETTINGS PAGE
    );
  }

  //Bottom bar for the app
  //This will be used to navigate between the home page and the settings pagec

  void showBottomScreenForStartingRoom() {
    //clearing the text fields
    _RoomNameController.clear();
    _RoomPasswordController.clear();
    //showing the bottom sheet
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final modalContext = context;
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            var maxHeight = constraints.maxHeight;
            return SingleChildScrollView(
              child: SizedBox(
                height: maxHeight - 100,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  //THIS IS THE START OF THE BOTTOM SHEET
                  children: <Widget>[
                    const SizedBox(height: 10),
                    //THIS IS THE TITLE OF THE BOTTOM SHEET
                    const Text(
                      'Start Game',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    //THIS IS THE TEXTFIELD
                    StartRoomEntry(
                        textfieldController: _RoomNameController,
                        hintText: 'Enter a Room Name'),
                    const SizedBox(height: 20),
                    drawStartRoomButton(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showBottomScreenForJoiningRoom() {
    //clearing the text fields
    _RoomNameController.clear();
    _RoomPasswordController.clear();
    //showing the bottom sheet
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final modalContext = context;
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            var maxHeight = constraints.maxHeight;
            return SingleChildScrollView(
              child: SizedBox(
                height: maxHeight - 100,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  //THIS IS THE START OF THE BOTTOM SHEET
                  children: <Widget>[
                    const SizedBox(height: 10),
                    //THIS IS THE TITLE OF THE BOTTOM SHEET
                    const Text(
                      'Join Game',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    //THIS IS THE TEXTFIELD
                    JoinRoomEntry(
                        textfieldController: _RoomPasswordController,
                        hintText: 'Pin'),
                    const SizedBox(height: 20),
                    drawJoinRoomButton(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// This function will show a dialog asking the user if they are sure they want to sign out
  /// If the user clicks yes then they will be signed out
  /// If the user clicks no then they will not be signed out
  Future<dynamic> showExitDialog() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text(
                "Are You Sure You Want To Sign Out?",
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    signOutConfirm = true;
                    Navigator.pop(context);
                    FirebaseFunctions.signOut(prefs: widget.prefs);
                  },
                  child: const Text("Yes"),
                ),
                TextButton(
                  onPressed: () {
                    signOutConfirm = false;
                    Navigator.pop(context);
                  },
                  child: const Text("No"),
                ),
              ],
            ));
  }

  /// This function will sign the user out of the app
  /// It will also show a dialog asking the user if they are sure they want to sign out
  /// If the user clicks yes then they will be signed out
  /// If the user clicks no then they will not be signed out
  void signOut() async {
    //need to show a dialog asking if the user is sure they want to sign out
    showExitDialog();

    //checking if the user clicked yes or no
    if (!signOutConfirm) {
      return;
    }
  }

  //function to add the room to the firebase cloud
  Future<dynamic> addToFirebaseCloud() async {
    //add to firebase cloud
    var roomName = _RoomNameController.text.trim();
    var msg = await FirebaseFunctions.addInfoToFirebaseCloud(roomName);

    //error handling to make sure same copy of the room doesnt exist
    if (msg == "Room already exists") {
      //first need to close the bottom sheet
      Navigator.pop(context);
      //need to show a dialog saying that the room already exists
      roomCreationDone = false;
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "$roomName already exists",
            style: const TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Ok"),
            ),
          ],
        ),
      );
    }
    if (msg == "Room created") {
      //this means that the room was created
      roomCreationDone = true;
    }
  }

  drawStartRoomButton() {
    return MaterialButton(
      color: Colors.black,
      onPressed: () async {
        await addToFirebaseCloud();
        print("Room Creation Done: $roomCreationDone");
        if (roomCreationDone) {
          //need to get the password of the room
          String pinNumber = "";
          final _db = FirebaseFirestore.instance;
          //need to get the room password from the db
          await _db
              .collection("rooms")
              .doc(_RoomNameController.text.trim())
              .get()
              .then((value) {
            pinNumber = value.data()!['roomPassword'];
          });
          final route = MaterialPageRoute(
            builder: (context) => DicePage(
              prefs: widget.prefs,
              roomName: _RoomNameController.text.trim(),
              pinNumber: pinNumber,
            ),
          );
          Navigator.pushAndRemoveUntil(context, route, (route) => false);
        }
      },
      child: const Text('Start Room',
          style: TextStyle(color: Colors.white, fontSize: 20)),
    );
  }

  drawJoinRoomButton() {
    return MaterialButton(
      onPressed: () async {
        print("Join Room Button Pressed");
        await checkPassWithRoom();
      },
      color: Colors.black,
      child: const Text("Join Room",
          style: TextStyle(color: Colors.white, fontSize: 20)),
    );
  }

  Future<dynamic> checkPassWithRoom() async {
    var roomPassword = _RoomPasswordController.text.trim();
    var msg = await FirebaseFunctions.checkPassWithRoom(roomPassword);

    if (msg == "password is incorrect") {
      Navigator.pop(context);
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "$roomPassword is incorrect",
            style: const TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Ok"),
            ),
          ],
        ),
      );
    }
    if (msg == "password is correct") {
      print("Password is correct: $roomPassword");
      var roomName =
          await FirebaseFunctions.addUserToFirebaseCloud(roomPassword);
      //this means that the password is correct
      final route = MaterialPageRoute(
        builder: (context) => DicePage(
          prefs: widget.prefs,
          roomName: roomName,
          pinNumber: roomPassword,
        ),
      );
      Navigator.pushAndRemoveUntil(context, route, (route) => false);
    }
  }
}
