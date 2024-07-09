// ignore_for_file: no_logic_in_create_state, use_build_context_synchronously

import 'package:dice_pt2/components/firebase/firebase_functions.dart';
import 'package:dice_pt2/models/my_button.dart';
import 'package:dice_pt2/models/my_name_entry.dart';
import 'package:dice_pt2/models/my_textfield.dart';
import 'package:dice_pt2/pages/auth/home_page.dart';
import 'package:dice_pt2/themes/const_themes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  final SharedPreferences prefs;
  final VoidCallback showRegisterPage;
  const RegisterPage(
      {super.key, required this.showRegisterPage, required this.prefs});

  @override
  State<RegisterPage> createState() => _RegisterPageState(
        showRegisterPage: showRegisterPage,
        prefs: prefs,
      );
}

class _RegisterPageState extends State<RegisterPage> {
  final VoidCallback showRegisterPage;
  final SharedPreferences prefs;
  _RegisterPageState({required this.showRegisterPage, required this.prefs});

  //controller for the page view so we know which page we are on

  //controller for sign in button
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /**
           * This is the sign in page
           * this is where the user will sign in no matter what
           * the reason why is because the account has to be associated with someone
           */

          Container(
            decoration: BoxDecoration(
              gradient: constThemes.linGrad,
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //printing the Welcome Back to the dice app
                  printWelcomeToDiceApp(),

                  const SizedBox(height: 20),

                  //printing the sign in with your email or phone number
                  printSignInWithEmailOrPhoneNumber(),

                  const SizedBox(height: 20),

                  printNameAndLastNameSignIn(),

                  const SizedBox(height: 20),

                  //this is where the user will enter their email

                  emailSignIn(),

                  const SizedBox(height: 20),
                  //this is where the user will enter their password
                  passwordSignIn(),

                  const SizedBox(height: 20),
                  //this is where the user will press the sign in button
                  signUpButton(),

                  const SizedBox(height: 10),
                  goBackToSignInPage(),
                  //Register Button
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  printWelcomeToDiceApp() {
    return Text(
      'Hello There',
      style: constThemes.getWorkSansFont(
        Colors.white,
        22,
        FontWeight.bold,
      ),
    );
  }

  printSignInWithEmailOrPhoneNumber() {
    return Text(
      'Register Below With Your Email',
      style: constThemes.getWorkSansFont(
        Colors.white,
        18,
        FontWeight.w500,
      ),
    );
  }

  emailSignIn() {
    return MyTextfield(
      textfieldController: _emailController,
      hintText: "Email",
      obscureText: false,
      isPassword: false,
    );
  }

  passwordSignIn() {
    return MyTextfield(
      textfieldController: _passwordController,
      hintText: "Password",
      obscureText: true,
      isPassword: true,
    );
  }

  signUpButton() {
    return MyButton(
      func: signUp,
      text: "Sign Up",
    );
  }

  goBackToSignInPage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Go Back To',
          style: TextStyle(
              color: Color.fromARGB(255, 185, 185, 185), fontSize: 16),
        ),
        GestureDetector(
          onTap: () => goBackToSignInPageButton(),
          child: const Text(
            ' Sign In Page',
            style: TextStyle(color: Colors.blue, fontSize: 16),
          ),
        ),
      ],
    );
  }

  void goBackToSignInPageButton() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(prefs: prefs),
      ),
    );
  }

  Future<dynamic> signUp() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();

    String errorMessage = "";
    bool error = false;
    //need to check lengths first
    if (email.isEmpty) {
      errorMessage = "Email cannot be empty";
      error = true;
    }
    if (password.length < 6 || password.isEmpty) {
      errorMessage = "password must be at least 6 characters";
      error = true;
    }
    if (firstName.isEmpty) {
      errorMessage = "First Name cannot be empty";
      error = true;
    }
    if (lastName.isEmpty) {
      errorMessage = "Last Name cannot be empty";
      error = true;
    }

    if (!error) {
      var msg =
          await FirebaseFunctions.signUp(email, password, firstName, lastName);
      if (msg == "User Created") {
        print("worked");
        return;
      } else {
        if (errorMessage == "User already exists") {
          errorMessage = "User already exists";
        } else {
          errorMessage = msg;
        }
      }
    }

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error", style: TextStyle(color: Colors.black)),
          content: Text(errorMessage,
              style: const TextStyle(fontSize: 20, color: Colors.black)),
          actions: <Widget>[
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  printNameAndLastNameSignIn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            Expanded(
              child: MyNameEntry(
                textfieldController: _firstNameController,
                hintText: "First Name",
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MyNameEntry(
                textfieldController: _lastNameController,
                hintText: "Last Name",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
