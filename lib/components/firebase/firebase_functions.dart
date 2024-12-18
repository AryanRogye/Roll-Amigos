// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dice_pt2/components/utils/generate_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseFunctions {
  //_______________________________________________________________
  //FUNCTION TO SIGN OUT
  //_______________________________________________________________
  static Future<void> signOut({required SharedPreferences prefs}) async {
    await FirebaseAuth.instance.signOut();
    await prefs.clear();
  }

  //_______________________________________________________________
  //FUNCTION TO SIGN IN
  //_______________________________________________________________
  static Future<dynamic> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      return "error: $e";
    }
    return "Good To Go";
  }

  //_______________________________________________________________
  //FUNCTION TO SIGN UP
  //_______________________________________________________________
  static Future<dynamic> signUp(
      String email, String password, String firstName, String lastName) async {
    //MAKING A DB TO STORE THE USER INFO
    //? THINGS LIKE EMAIL, PASSWORD, FIRST NAME, LAST NAME
    final _db = FirebaseFirestore.instance;
    try {
      //creating the user
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      //RETURNS THE ERROR
      //SO THAT THE USER CAN SEE WHAT WENT WRONG
      return "error: $e";
    }
    //IF WE REACH HERE THE THING IS THAT THE USER WAS CREATED
    //NOW WE NEED TO CREATE A DB

    //NO NEED TO STORE THE PASSWORD IN THE DB
    Map<String, dynamic> data = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
    };

    DocumentSnapshot userDoc = await _db.collection("users").doc(email).get();
    if (!userDoc.exists) {
      _db.collection("users").doc(email).set(data);
      return "User created";
    } else {
      return "User already exists";
    }
  }

  //_______________________________________________________________
  //WHEN USER STARTS A ROOM ADD INFO TO FIREBASE CLOUD
  //_______________________________________________________________
  static Future<dynamic> addInfoToFirebaseCloud(String roomName) async {
    final _db = FirebaseFirestore.instance;

    //first before anything need to check if the room name already exists
    DocumentSnapshot roomSnapshot =
        await _db.collection("rooms").doc(roomName).get();
    //if the room already exists then we need to return a message saying that the room already exists
    if (roomSnapshot.exists) {
      print("Room already exists");
      return "Room already exists";
    }
    //now that we have the rooms name checked we can move on to the next step

    String email = FirebaseAuth.instance.currentUser!.email!;
    print("Email: $email");
    print("Room Name: $roomName");
    //up to this point we have the email and the roomName

    //now what I need to do is generate a password and how I can do that is by generating a random number
    int password = 0;
    bool passwordExists = true;

    while (passwordExists) {
      password = GeneratePassword.genPassword();
      QuerySnapshot snapshot = await _db
          .collection("rooms")
          .where("password", isEqualTo: password.toString())
          .get();
      if (snapshot.docs.isEmpty) {
        passwordExists = false;
      }
    }
    //now we have the password
    print("Password: $password");

    var user = await getFirstNameLastName();
    var firstName = await user[0];
    var lastName = await user[1];

    Map<String, dynamic> userData = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
    };

    //now we need to add the email, roomName and password to the firebase cloud
    //first we need to create a map of the data
    Map<String, dynamic> data = {
      "host_details": email,
      "roomPassword": password.toString().trim(),
      "diceNumber": [1, 1, 1],
      "rolling": false,
      "rollingOrder": [email],
      "RollingIndex": 0,
      "users": [userData],
      "Number of Dices": 1,
    };
    _db.collection("rooms").doc(roomName).set(data);
    return "Room created";
  }

  //_______________________________________________________________
  //GETTING THE NUMBER OF DICES
  //_______________________________________________________________
  static Future<dynamic> getNumOfDice({required String roomName}) async {
    final _db = FirebaseFirestore.instance;
    DocumentSnapshot roomDoc =
        await _db.collection("rooms").doc(roomName).get();
    var numOfDice = await roomDoc.get("Number of Dices");
    return numOfDice;
  }

  //_______________________________________________________________
  //CHANGE THE NUMBER OF DICES
  //_______________________________________________________________
  static Future<dynamic> changeNumOfDice(
      {required String roomName, required int numOfDice}) async {
    final _db = FirebaseFirestore.instance;
    Map<String, dynamic> data = {
      "Number of Dices": numOfDice,
    };
    await _db.collection("rooms").doc(roomName).update(data);
  }

  //_______________________________________________________________
  //CHECKING IF THE PASSWORD ENTERED MATCHES THE ROOM PASSWORD
  //_______________________________________________________________
  static Future<dynamic> checkPassWithRoom(String roomPassword) async {
    //TODO
    print("Check Pass With Room");
    final _db = FirebaseFirestore.instance;
    //first we need to make sure that the password that the user entered is correct
    QuerySnapshot querySnapshot = await _db.collection("rooms").get();
    var foundPassword = false;

    //itterating through all the rooms to make sure that the password matches with one of them
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      var storedPassword = await doc.get("roomPassword");
      if (storedPassword == roomPassword) {
        foundPassword = true;
        break;
      }
    }

    if (foundPassword) {
      return ("password is correct");
    } else {
      return ("password is incorrect");
    }
  }

  //_______________________________________________________________
  //ADDING THE USER TO THE ROOM
  //_______________________________________________________________
  static Future<dynamic> addUserToFirebaseCloud(String roomPassword) async {
    final _db = FirebaseFirestore.instance;
    try {
      // Get the name of the user
      var firstAndLast = await getFirstNameLastName();
      var firstName = firstAndLast[0];
      var lastName = firstAndLast[1];

      Map<String, dynamic> userData = {
        "email": FirebaseAuth.instance.currentUser!.email,
        "firstName": firstName,
        "lastName": lastName,
      };

      var roomName = "";
      print("REACHED HERE");
      QuerySnapshot querySnapshot = await _db.collection("rooms").get();
      print("DIDNT REACH HERE");
      var foundPassword = false;

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        var storedPassword = doc.get("roomPassword");
        if (storedPassword == roomPassword) {
          foundPassword = true;
          roomName = doc.id;

          // Check if user already exists in the room
          var roomDoc = await _db.collection("rooms").doc(doc.id).get();
          var users = roomDoc.get("users") as List<dynamic>;
          var rollingOrder = List<String>.from(roomDoc.get("rollingOrder"));

          bool userExists =
              users.any((user) => user["email"] == userData["email"]);

          if (!userExists) {
            print("The User does not exist in the room: $roomName");

            await _db.collection("rooms").doc(doc.id).update({
              "users": FieldValue.arrayUnion([userData]),
              "rollingOrder": FieldValue.arrayUnion(
                  [userData["email"]]) // Add user to rolling order
            });
            print("User added to room: $roomName");
          } else {
            print("User already exists in the room: $roomName");
          }

          break;
        }
      }

      if (!foundPassword) {
        throw Exception("Room with the provided password not found.");
      }

      return roomName;
    } catch (e) {
      print("Error adding user to room: $e");
      return "error: $e";
    }
  }

  //_______________________________________________________________
  //GET First Name Last Name
  //_______________________________________________________________
  static Future<dynamic> getFirstNameLastName() async {
    final _db = FirebaseFirestore.instance;
    String email = FirebaseAuth.instance.currentUser!.email!;
    DocumentSnapshot userDoc = await _db.collection("users").doc(email).get();
    var firstName = await userDoc.get("firstName");
    var lastName = await userDoc.get("lastName");
    return [firstName, lastName];
  }

  //_______________________________________________________________
  //GET Email
  //_______________________________________________________________
  static Future<dynamic> getEmail() async {
    return FirebaseAuth.instance.currentUser!.email;
  }

  //_______________________________________________________________
  //FORGOT PASSWORD SEND EMAIL
  //_______________________________________________________________
  static Future<dynamic> forgotPassword(
      {required String email, required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      print("Got Email -- $email");
      return "Good To Go";
    } on FirebaseAuthException catch (e) {
      print("Error: ${e.message}");
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        default:
          errorMessage = 'An unknown error occurred.';
      }
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              errorMessage,
              style: const TextStyle(color: Colors.black),
            ),
          );
        },
      );
    }
  }

  //_______________________________________________________________
  //Get All Users In Room
  //_______________________________________________________________
  static Future<dynamic> getAllUsersInRoom(String roomName) async {
    final _db = FirebaseFirestore.instance;
    DocumentSnapshot roomDoc =
        await _db.collection("rooms").doc(roomName).get();

    var users = await roomDoc.get("users");

    // Convert users to a List<Map> if it's not already
    List<Map<String, dynamic>> userList =
        List<Map<String, dynamic>>.from(users);

    return userList;
  }

  //_______________________________________________________________
  //GET NUM OF USERS
  //_______________________________________________________________
  static Stream<int> getNumOfUsers({required String roomName}) {
    final _db = FirebaseFirestore.instance;
    return _db.collection('rooms').doc(roomName).snapshots().map((snapshot) {
      if (snapshot.exists) {
        var users = snapshot.get('users') as List<dynamic>;
        return users.length;
      } else {
        return 0;
      }
    });
  }

  //_______________________________________________________________
  //GET HOST FIRST AND LAST NAME
  //_______________________________________________________________
  static Future<dynamic> getHostName({required String roomName}) async {
    final _db = FirebaseFirestore.instance;
    DocumentSnapshot roomDoc =
        await _db.collection("rooms").doc(roomName).get();
    var hostEmail = await roomDoc.get("host_details");
    //now that we have the host email we can get the first and last name from the users collection
    DocumentSnapshot userDoc =
        await _db.collection("users").doc(hostEmail).get();
    var firstName = await userDoc.get("firstName");
    var lastName = await userDoc.get("lastName");
    return [firstName, lastName];
  }

  //_______________________________________________________________
  //DELETE ROOM
  //_______________________________________________________________
  static void deleteRoom({required String roomName}) async {
    final _db = FirebaseFirestore.instance;
    await _db.collection("rooms").doc(roomName).delete();
  }

  //_______________________________________________________________
  //LEAVE ROOM
  //_______________________________________________________________
  static void leaveRoom(
      {required String roomName, required SharedPreferences prefs}) async {
    //This Function will delete the room from the rooms collection
    //check if the user is the host
    final _db = FirebaseFirestore.instance;
    String email = FirebaseAuth.instance.currentUser!.email!;
    DocumentSnapshot roomDoc =
        await _db.collection("rooms").doc(roomName).get();
    var hostEmail = await roomDoc.get("host_details");
    if (hostEmail == email) {
      //delete the room
      await _db.collection("rooms").doc(roomName).delete();
    } else {
      //need to get FirstName and LastName
      var firstAndLast = await getFirstNameLastName();
      var firstName = await firstAndLast[0];
      var lastName = await firstAndLast[1];
      //remove the user from the room
      Map<String, dynamic> data = {
        "users": FieldValue.arrayRemove([
          {
            "email": email,
            "firstName": firstName,
            "lastName": lastName,
          }
        ]),
      };
      //remove the user from the rolling order
      var rollingOrder = await roomDoc.get("rollingOrder");
      List<String> newRollingOrder = List<String>.from(rollingOrder);
      newRollingOrder.remove(email);
      data["rollingOrder"] = newRollingOrder;

      await _db.collection("rooms").doc(roomName).update(data);
    }
  }

  //_______________________________________________________________
  //CHECK IF ROOM EXISTS
  //_______________________________________________________________
  static Future<bool> checkIfRoomExists(String roomName) async {
    final _db = FirebaseFirestore.instance;
    DocumentSnapshot roomDoc =
        await _db.collection("rooms").doc(roomName).get();
    return roomDoc.exists;
  }

  //_______________________________________________________________
  //CHECK IF USER IS THE HOST
  //_______________________________________________________________
  static Future<bool> isHost({required roomName}) async {
    final _db = FirebaseFirestore.instance;
    String email = FirebaseAuth.instance.currentUser!.email!;
    DocumentSnapshot roomDoc =
        await _db.collection("rooms").doc(roomName).get();
    var hostEmail = await roomDoc.get("host_details");
    return hostEmail == email;
  }

  //_______________________________________________________________
  //GET ALL USER EMAILS
  //_______________________________________________________________
  static Future<dynamic> getAllUserEmails({required String roomName}) async {
    final _db = FirebaseFirestore.instance;
    DocumentSnapshot roomDoc =
        await _db.collection("rooms").doc(roomName).get();
    var users = await roomDoc.get("users");
    List<String> retEmails = [];
    for (var user in users) {
      print(user["email"]);
      retEmails.add(user["email"]);
    }
    return retEmails;
  }

  //_______________________________________________________________
  //GET ROLLING ORDER
  //_______________________________________________________________
  static Future<dynamic> getRollingOrder({required String roomName}) async {
    final _db = FirebaseFirestore.instance;
    DocumentSnapshot roomDoc =
        await _db.collection("rooms").doc(roomName).get();
    var rollingOrder = await roomDoc.get("rollingOrder");
    print("rolling order: $rollingOrder");
    List<String> retEmails = [];
    for (var email in rollingOrder) {
      retEmails.add(email);
    }
    return retEmails;
  }

  static void updateRollingOrder(
      {required String roomName, required List<String> newOrder}) {
    final _db = FirebaseFirestore.instance;
    _db.collection("rooms").doc(roomName).update({
      "rollingOrder": newOrder,
    });
  }
}
