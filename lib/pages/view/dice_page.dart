// ignore_for_file: no_logic_in_create_state, must_be_immutable, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dice_pt2/components/firebase/firebase_functions.dart';
import 'package:dice_pt2/models/user_display_game.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:dice_pt2/widgets/dice.dart';
import 'dart:math';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:dice_pt2/ads/ad_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Main Page of the app
class DicePage extends StatefulWidget {
  final SharedPreferences prefs;
  String roomName = "";
  String pinNumber = "";

  DicePage(
      {super.key,
      required this.prefs,
      required this.roomName,
      required this.pinNumber});

  @override
  DicePageScreen createState() => DicePageScreen(prefs: prefs);
}

//implementing the main page
class DicePageScreen extends State<DicePage> {
  //this is so that the preferences can be used in the main page
  final SharedPreferences prefs; //shared preferences
  final user = FirebaseAuth.instance.currentUser;
  final _db = FirebaseFirestore.instance;

  String toRoll = "Tap Screen To Roll Dice";

  //constructor
  DicePageScreen({required this.prefs});

  //banner ad
  BannerAd? _banner;

  //list of dice numbers rn only 3 dice cuz its easier to implement

  List<int> diceNumber = [1, 1, 1];
  late int numOfDices = 1;
  @override
  void initState() {
    super.initState();
    numOfDices = prefs.getInt('numOfDices') ?? 1;
    updateDiceValues();
    _createBannerAd();
    listenToDiceChanges();
  }

  Future<int> getNumberOfUsers() async {
    return await FirebaseFunctions.getNumOfUsers(roomName: widget.roomName);
  }

  Future<String> getPinNumber() async {
    String pinNumber = "";
    final _db = FirebaseFirestore.instance;
    //need to get the room password from the db
    await _db.collection("rooms").doc(widget.roomName).get().then((value) {
      pinNumber = value.data()!['roomPassword'];
    });
    return pinNumber;
  }

  void listenToDiceChanges() {
    _db
        .collection('rooms')
        .doc(widget.roomName)
        .snapshots()
        .listen((documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          diceNumber = List<int>.from(documentSnapshot.data()!['diceNumber']);
          if (documentSnapshot.data()!['rolling'] == true) {
            startRollingAnimation();
          }
        });
      }
    });
  }

  void startRollingAnimation() async {
    setState(() {
      toRoll = 'Rolling Dice....';
    });
    getRand(diceNumber, 1, 6);
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() {
      toRoll = 'Rolling Dice...';
    });
    getRand(diceNumber, 1, 6);
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() {
      toRoll = 'Rolling Dice..';
    });
    getRand(diceNumber, 1, 6);
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() {
      toRoll = 'Rolling Dice.';
    });
    getRand(diceNumber, 1, 6);
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() {
      toRoll = 'Tap Screen To Roll Dice';
    });

    // Fetch the final dice values from Firestore
    final documentSnapshot =
        await _db.collection("rooms").doc(widget.roomName).get();
    if (documentSnapshot.exists) {
      setState(() {
        diceNumber = List<int>.from(documentSnapshot.data()!['diceNumber']);
      });
    }
  }

  //creating the banner ad
  void _createBannerAd() {
    _banner = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdState.bannerAdUnitId!,
      listener: AdState.bannerListener,
      request: const AdRequest(),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    //brightness of the screen
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    //screen width and height
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => setState(() {
        //on tap play the sound and roll the dice which is rand number between 1 and 6
        getRandNumber(diceNumber, 1, 6);
      }),
      child: Scaffold(
        appBar: AppBar(
          title: Text("${widget.roomName}\nPin: ${widget.pinNumber}",
              style: const TextStyle(fontSize: 15)),
          actions: <Widget>[
            IconButton(
              onPressed: () => showPopUpScreen(
                context,
                brightness == Brightness.dark ? true : false,
              ),
              icon: const Icon(Icons.settings),
            )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
                future: getNumberOfUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error.toString()}");
                  } else if (snapshot.hasData) {
                    return Text("Users: ${snapshot.data}");
                  } else {
                    return const Text("No Data");
                  }
                }),
            Center(
              child: brightness == Brightness.dark
                  ? DiceWidget(
                      diceNumber: diceNumber,
                      isWhite: true,
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      numOfDices: numOfDices,
                    )
                  : DiceWidget(
                      diceNumber: diceNumber,
                      isWhite: false,
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      numOfDices: numOfDices,
                    ),
            ),
            const SizedBox(height: 40),
            Text(
              toRoll,
              style: const TextStyle(fontSize: 22),
            ),
          ],
        ),
        bottomNavigationBar: _banner == null
            ? Container()
            : Container(
                margin: const EdgeInsets.only(bottom: 12),
                height: 52,
                child: AdWidget(ad: _banner!),
              ),
      ),
    );
  }

  Future showPopUpScreen(BuildContext context, bool isWhite) async {
    String pinNumber = await getPinNumber();

    //TODO
    //NEED TO IMPLEMENT A WAY FOR THE USER TO SEE THE PEOPLE IN THE ROOM
    return showModalBottomSheet(
      backgroundColor:
          isWhite ? const Color.fromARGB(255, 48, 48, 48) : Colors.white,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 40),
                SizedBox(child: Text("Pin: $pinNumber")),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40,
                      child: Text(
                        'Number Of Dices',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                  ],
                ),
                DropdownMenu(
                  width: 200,
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(value: 1, label: '1'),
                    DropdownMenuEntry(value: 2, label: '2'),
                    DropdownMenuEntry(value: 3, label: '3'),
                  ],
                  onSelected: (value) {
                    setState(() {
                      numOfDices = value!;
                      prefs.setInt('numOfDices', numOfDices);
                      updateDiceValues();
                    });
                  },
                ),
                const SizedBox(height: 20),
                Text("Signed In As: ${user!.email!}"),
                const SizedBox(height: 20),
                //need to show the users in the room here
                getUsersInRoom(),
              ],
            ),
          ),
        );
      },
    );
  }

  void getRand(List<int> diceNumbers, int min, int max) {
    for (int i = 0; i < numOfDices; i++) {
      setState(() {
        diceNumber[i] = Random().nextInt(max - min + 1) + min;
      });
    }
  }

  void getRandNumber(List<int> diceNumbers, int min, int max) async {
    // Start rolling animation
    _db.collection('rooms').doc(widget.roomName).update({'rolling': true});

    for (int i = 0; i < 4; i++) {
      setState(() {
        toRoll = 'Rolling Dice${'.' * (i + 1)}';
      });
      getRand(diceNumbers, min, max);
      await Future.delayed(const Duration(milliseconds: 100));
    }

    // Generate final dice values
    getRand(diceNumbers, min, max);

    // Save final dice values to Firestore
    updateDiceInFirestore();

    // Stop rolling animation
    _db.collection('rooms').doc(widget.roomName).update({'rolling': false});

    setState(() {
      toRoll = 'Tap Screen To Roll Dice';
    });
  }

  void saveDiceValues() {
    for (int i = 0; i < numOfDices; i++) {
      prefs.setInt('dice${i + 1}', diceNumber[i]);
    }
  }

  void updateDiceValues() {
    for (int i = 0; i < numOfDices; i++) {
      diceNumber[i] = prefs.getInt('dice${i + 1}') ?? 1;
    }
  }

  void updateDiceInFirestore() {
    _db
        .collection('rooms')
        .doc(widget.roomName)
        .update({'diceNumber': diceNumber}).then((_) {
      print("Dice numbers updated in Firestore");
    }).catchError((error) {
      print("Failed to update dice numbers in Firestore: $error");
    });
  }

  getUsersInRoom() {
    return FutureBuilder(
      future: FirebaseFunctions.getAllUsersInRoom(widget.roomName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data != null) {
            List<dynamic> users = snapshot.data;
            List<Widget> userWidgets = [];
            for (var user in users) {
              var firstName = user['firstName'];
              var lastName = user['lastName'];
              userWidgets.add(
                  UserDisplayGame(firstName: firstName, lastName: lastName));
            }
            return userWidgets.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: userWidgets,
                    ),
                  )
                : const Text("No Users In Room");
          } else {
            return const Text("No Users In Room");
          }
        } else {
          print("NOT DONE");
          return CircularProgressIndicator();
        }
      },
    );
  }
}
