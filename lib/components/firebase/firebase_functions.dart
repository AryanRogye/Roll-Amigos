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

    //now we need to add the email, roomName and password to the firebase cloud
    //first we need to create a map of the data
    Map<String, dynamic> data = {
      "host_details": email,
      "roomPassword": password.toString().trim(),
      "diceNumber": [1, 1, 1],
      "rolling": false,
    };
    _db.collection("rooms").doc(roomName).set(data);
    return "Room created";
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
    //TODO
    print("Add User To Firebase Cloud");
    final _db = FirebaseFirestore.instance;

    Map<String, dynamic> data = {
      "users":
          FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.email]),
    };
    var roomName = "";
    QuerySnapshot querySnapshot = await _db.collection("rooms").get();
    var foundPassword = false;
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      var storedPassword = await doc.get("roomPassword");

      if (storedPassword == roomPassword) {
        foundPassword = true;
        await _db.collection("rooms").doc(doc.id).update(data);
        roomName = doc.id;
        print("Room Name: $roomName");
        break;
      }
    }
    return roomName;
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
}
