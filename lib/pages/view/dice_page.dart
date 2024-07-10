// ignore_for_file: no_logic_in_create_state, must_be_immutable, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dice_pt2/components/firebase/firebase_functions.dart';
import 'package:dice_pt2/models/display_users.dart';
import 'package:dice_pt2/models/user_display_game.dart';
import 'package:dice_pt2/pages/view/rolling_order.dart';
import 'package:dice_pt2/pages/view/screen_navigation.dart';
import 'package:dice_pt2/themes/const_themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dice_pt2/widgets/dice.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
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
  var LeaveRoomButtonColor = const Color.fromARGB(255, 227, 227, 227);
  //this is so that the preferences can be used in the main page
  final SharedPreferences prefs; //shared preferences
  final user = FirebaseAuth.instance.currentUser;
  final _db = FirebaseFirestore.instance;
  late bool isHost;
  late List<String> rollingOrder = [];
  late int currIndex = 0;
  String users = "";

  String toRoll = "";

  //constructor
  DicePageScreen({required this.prefs});

  //banner ad
  BannerAd? _banner;

  //list of dice numbers rn only 3 dice cuz its easier to implement
  List<int> diceNumber = [1, 1, 1];
  late int numOfDices = 1;
  bool isRolling = false;
  @override
  void initState() {
    super.initState();
    numOfDices = prefs.getInt('numOfDices') ?? 1;
    isUserHost();
    setRollingOrder();
    checkNumOfDices();
    updateDiceValues();
    _createBannerAd();
    listenToDiceChanges();
    listenToRoomExistence();
    listenToDiceNumChanges();
    listenToDiceRollingOrderChanges();
    listenToUserCount();
  }

  void listenToUserCount() {
    FirebaseFunctions.getNumOfUsers(roomName: widget.roomName).listen((event) {
      setState(() {
        users = event.toString();
      });
    });
  }

  void listenToDiceRollingOrderChanges() {
    _db
        .collection('rooms')
        .doc(widget.roomName)
        .snapshots()
        .listen((documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          rollingOrder =
              List<String>.from(documentSnapshot.data()?['rollingOrder']);
          currIndex = documentSnapshot.data()?['RollingIndex'];
          if (currIndex >= rollingOrder.length) {
            currIndex = 0;
          }
          print("Rolling Order: $rollingOrder");
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  //_______________________________________________________________
  //FUNCTION TO SET THE ROLLING ORDER
  //_______________________________________________________________
  void setRollingOrder() async {
    List<String> order =
        await FirebaseFunctions.getRollingOrder(roomName: widget.roomName);
    setState(() {
      rollingOrder = order;
      print("Rolling Order: $rollingOrder");
    });
  }

  //_______________________________________________________________
  //FUNCTION TO UPDATE THE ROLLING ORDER
  //_______________________________________________________________
  void updateRollingOrder(List<String> newOrder) {
    print("Old Order: $rollingOrder");
    //need to change the order in the database
    FirebaseFunctions.updateRollingOrder(
        roomName: widget.roomName, newOrder: newOrder);
  }

  //_______________________________________________________________
  //FUNCTION TO CHECK IF THE USER IS THE HOST
  //_______________________________________________________________
  Future<bool> isUserHost() async {
    if (await FirebaseFunctions.isHost(roomName: widget.roomName)) {
      setState(() {
        isHost = true;
      });
      return true;
    } else {
      setState(() {
        isHost = false;
      });
      return false;
    }
  }

  //_______________________________________________________________
  //FUNCTION TO LISTEN TO THE NUMBER OF DICE CHANGES
  //_______________________________________________________________
  void listenToDiceNumChanges() {
    _db
        .collection('rooms')
        .doc(widget.roomName)
        .snapshots()
        .listen((documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          numOfDices = documentSnapshot.data()!['Number of Dices'];
          updateDiceValues();
        });
      }
    });
  }

  //_______________________________________________________________
  //FUNCTION TO CHECK THE NUMBER OF DICES
  //_______________________________________________________________
  checkNumOfDices() async {
    var diceNum =
        await FirebaseFunctions.getNumOfDice(roomName: widget.roomName);
    setState(() {
      numOfDices = diceNum;
    });
  }

  //_______________________________________________________________
  //FUNCTION TO LISTEN TO THE ROOMS EXISTENCE
  //_______________________________________________________________
  void listenToRoomExistence() {
    _db
        .collection('rooms')
        .doc(widget.roomName)
        .snapshots()
        .listen((documentSnapshot) {
      if (!documentSnapshot.exists) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => ScreenNavigation(prefs: prefs),
          ),
          (route) => false,
        );
      }
    });
  }

  //_______________________________________________________________
  //FUNCTION TO GET THE PIN NUMBER
  //_______________________________________________________________
  Future<String> getPinNumber() async {
    String pinNumber = "";
    final _db = FirebaseFirestore.instance;
    //need to get the room password from the db
    await _db.collection("rooms").doc(widget.roomName).get().then((value) {
      pinNumber = value.data()!['roomPassword'];
    });
    return pinNumber;
  }

  //_______________________________________________________________
  //FUNCTION TO LISTEN TO THE DICE CHANGES
  //_______________________________________________________________
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

  //_______________________________________________________________
  //FUNCTION TO SHOW THE ROLLING ANIMATION
  //_______________________________________________________________
  void startRollingAnimation() async {
    setState(() {
      getRand(diceNumber, 1, 6);
    });

    await Future.delayed(const Duration(milliseconds: 100));
    setState(() {
      // toRoll = 'Rolling Dice...';
    });
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() {
      getRand(diceNumber, 1, 6);
    });
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() {
      getRand(diceNumber, 1, 6);
    });
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() {
      getRand(diceNumber, 1, 6);
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

  //_______________________________________________________________
  //FUNCTION TO CREATE THE BANNER AD
  //_______________________________________________________________
  void _createBannerAd() {
    _banner = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdState.bannerAdUnitId!,
      listener: AdState.bannerListener,
      request: const AdRequest(),
    )..load();
  }

  //_______________________________________________________________
  //FUNCTION TO DRAW THE APP BAR
  //_______________________________________________________________
  drawAppBar() {
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    return AppBar(
      toolbarHeight: 100,
      backgroundColor: Colors.transparent,
      title: Text("${widget.roomName}\nPin: ${widget.pinNumber}\nUsers: $users",
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
    );
  }

  //_______________________________________________________________
  //FUNCTION TO DRAW THE DICE
  //_______________________________________________________________
  drawDice() {
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Center(
      child: DiceWidget(
        diceNumber: diceNumber,
        isWhite: true,
        screenWidth: screenWidth,
        screenHeight: screenHeight,
        numOfDices: numOfDices,
      ),
    );
  }

  void rollDiceContinuously() async {
    while (isRolling) {
      setState(() {
        getRand(diceNumber, 1, 6);
      });

      // Update Firestore with current dice values
      _db
          .collection('rooms')
          .doc(widget.roomName)
          .update({'diceNumber': diceNumber}).then((_) {
        print("Dice numbers updated in Firestore");
      }).catchError((error) {
        print("Failed to update dice numbers in Firestore: $error");
      });

      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  void startRolling() async {
    var roomDoc = await _db.collection('rooms').doc(widget.roomName).get();
    //getting the rolling order
    rollingOrder = List<String>.from(roomDoc.get("rollingOrder"));
    //the currentIndex of the rolling order
    int currentIndex = roomDoc.get("RollingIndex");
    //making sure that the rolling order is not empty

    if (rollingOrder.isEmpty) {
      print('Rolling order is empty.');
      return;
    }

    // Ensure the user is the one in the rolling order
    if (rollingOrder[currentIndex] != user!.email) {
      print('Not your turn: it\'s ${rollingOrder[currentIndex]}\'s turn');
      return;
    }

    if (!isRolling) {
      isRolling = true;
      await _db
          .collection('rooms')
          .doc(widget.roomName)
          .update({'rolling': true});
      rollDiceContinuously();
    }
  }

  void stopRolling() async {
    // only works if the user is the one in the rolling order
    if (isRolling) {
      isRolling = false;
      int currentIndex = (currIndex + 1) % rollingOrder.length;

      // Generate final dice values
      getRand(diceNumber, 1, 6);

      // Save final dice values to Firestore
      updateDiceInFirestore();

      // Stop rolling animation and update index
      await _db.collection('rooms').doc(widget.roomName).update({
        'rolling': false,
        'RollingIndex': currentIndex,
      });

      setState(() {
        currIndex = currentIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //brightness of the screen
    //screen width and height

    return GestureDetector(
      onLongPressStart: (_) => startRolling(),
      onLongPressEnd: (_) => stopRolling(),
      // onTap: () => getRandNumber(diceNumber, 1, 6),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: drawAppBar(),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: constThemes.linGrad,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //need to draw the dice
              Center(child: drawDice()),
            ],
          ),
        ),
        // Column(
        //   children: [
        //     const SizedBox(height: 30),
        //     displayStats(),
        //     SizedBox(height: MediaQuery.of(context).size.height * 0.2),
        //     drawDice(),
        //     const SizedBox(height: 40),
        //   ],
        // ),
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
                //need to draw the leave room here
                leaveRoomButton(),
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
                //this option should only be available to the host
                //first need to check if the user is the host
                isHost
                    ? DropdownMenu(
                        width: 200,
                        dropdownMenuEntries: const [
                          DropdownMenuEntry(value: 1, label: '1'),
                          DropdownMenuEntry(value: 2, label: '2'),
                          DropdownMenuEntry(value: 3, label: '3'),
                        ],
                        onSelected: (value) async {
                          FirebaseFunctions.changeNumOfDice(
                            roomName: widget.roomName,
                            numOfDice: value!,
                          );
                          setState(() {
                            numOfDices = value;
                            prefs.setInt('numOfDices', numOfDices);
                            updateDiceValues();
                          });
                        },
                      )
                    : const SizedBox(),
                const SizedBox(height: 20),
                Text("Signed In As: ${user!.email!}"),
                const SizedBox(height: 20),
                //need to let the user route to a different page here
                isHost ? rollingOrderButton() : const SizedBox(),
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
    // Fetch the latest rolling order and current index from Firestore
    var roomDoc = await _db.collection('rooms').doc(widget.roomName).get();
    rollingOrder = List<String>.from(roomDoc.get("rollingOrder"));
    int currentIndex = roomDoc.get("RollingIndex");

    // Ensure the rolling order is not empty
    if (rollingOrder.isEmpty) {
      print('Rolling order is empty.');
      return;
    }

    // Ensure the user is the one in the rolling order
    if (rollingOrder[currentIndex] != user!.email) {
      print('Not your turn: it\'s ${rollingOrder[currentIndex]}\'s turn');
      return;
    }

    // Update the current index for the next turn
    int nextIndex = (currentIndex + 1) % rollingOrder.length;

    // Start rolling animation
    await _db
        .collection('rooms')
        .doc(widget.roomName)
        .update({'rolling': true});

    for (int i = 0; i < 4; i++) {
      setState(() {
        // toRoll = 'Rolling Dice${'.' * (i + 1)}';
      });
      getRand(diceNumbers, min, max);
      await Future.delayed(const Duration(milliseconds: 100));
    }

    // Generate final dice values
    getRand(diceNumbers, min, max);

    // Save final dice values to Firestore
    updateDiceInFirestore();

    // Stop rolling animation
    print("next index: $nextIndex");
    await _db.collection('rooms').doc(widget.roomName).update({
      'rolling': false,
      'RollingIndex': nextIndex, // Update the current index in Firestore
    });

    setState(() {
      currIndex = nextIndex;
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

  getHostName() async {
    return await FirebaseFunctions.getHostName(roomName: widget.roomName);
  }

  getUsersInRoom() {
    return FutureBuilder(
      future: FirebaseFunctions.getAllUsersInRoom(widget.roomName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            List<dynamic> users = snapshot.data;

            List<Widget> userWidgets = [];
            for (var user in users) {
              var firstName = user['firstName'];
              var lastName = user['lastName'];

              print("firebase user: $firstName $lastName");

              userWidgets.add(
                UserDisplayGame(
                  firstName: firstName,
                  lastName: lastName,
                ),
              );
            }

            return userWidgets.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: userWidgets,
                    ),
                  )
                : const Text("No Users In Room here");
          } else {
            return const Text("No Users In Room here ");
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  getUsers() {
    return StreamBuilder<int>(
        stream: FirebaseFunctions.getNumOfUsers(roomName: widget.roomName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text(
              "Error: ${snapshot.error.toString()}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          } else if (snapshot.hasData) {
            setState(() {
              users = snapshot.data.toString();
            });
            return Text(
              "Users: ${snapshot.data}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          } else {
            return const Text(
              "No Data",
              style: TextStyle(
                color: Colors.white,
              ),
            );
          }
        });
  }

  // In the displayStats method, use the new UserCountWidget
  displayStats() {
    return Container(
      alignment: Alignment.center,
      color: Colors.black,
      height: MediaQuery.of(context).size.height * 0.2,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UserCountWidget(roomName: widget.roomName),
            ],
          ),
          Flexible(
            child: Text(
              "Rolling Order: $rollingOrder",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Flexible(
            child: Text(
              "Current Roll User: ${rollingOrder.isNotEmpty ? rollingOrder[currIndex] : 'None'}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  showAreYouSureDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Are you sure you want to leave the room?",
          style: TextStyle(color: Colors.black),
        ),
        content: const Text(
          "If You Leave The Room The Room Will be Deleted",
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              print("No");
              Navigator.pop(context);
            },
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              //only need to delet the room if the user is the host
              FirebaseFunctions.leaveRoom(
                  roomName: widget.roomName, prefs: prefs);
              //now need to check if the room exists if the room doesnt exist then the user should be taken to the home page
              final route = MaterialPageRoute(
                builder: (context) => ScreenNavigation(
                  prefs: prefs,
                ),
              );
              Navigator.pushAndRemoveUntil(context, route, (route) => false);
            },
            child: const Text("Yes", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  leaveRoomButton() {
    return GestureDetector(
      onTap: () async {
        print("pressed");
        Navigator.pop(context);
        //need to show a dialog box to confirm if the user wants to leave the room
        showAreYouSureDialog();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          height: 70,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: LeaveRoomButtonColor,
          ),
          alignment: Alignment.center,
          child: const Text("Leave Room",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
        ),
      ),
    );
  }

  rollingOrderChange() {
    final route = MaterialPageRoute(
      builder: (context) => RollOrderPage(
        roomName: widget.roomName,
        onOrderChanged: updateRollingOrder,
      ),
    );
    Navigator.push(context, route);
  }

  rollingOrderButton() {
    return GestureDetector(
      onTap: () => rollingOrderChange(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: LeaveRoomButtonColor,
          ),
          height: 70,
          width: double.infinity,
          alignment: Alignment.center,
          child: const Text("Rolling Order",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              )),
        ),
      ),
    );
  }
}
