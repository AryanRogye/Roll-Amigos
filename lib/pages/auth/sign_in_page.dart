// ignore_for_file: no_logic_in_create_state, library_private_types_in_public_api
import 'package:dice_pt2/components/firebase/firebase_functions.dart';
import 'package:dice_pt2/models/my_button.dart';
import 'package:dice_pt2/models/my_textfield.dart';
import 'package:dice_pt2/pages/auth/forgot_pw.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SignInPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const SignInPage({super.key, required this.showRegisterPage});

  @override
  _SignInPageState createState() => _SignInPageState(
        showRegisterPage: showRegisterPage,
      );
}

class _SignInPageState extends State<SignInPage> {
  final VoidCallback showRegisterPage;
  _SignInPageState({required this.showRegisterPage});

  //controller for the page view so we know which page we are on
  final PageController _controller = PageController();

  //controller for sign in button
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            children: [
              //this is where the intro page will be
              //will describe the app and what it does
              Container(
                //TODO
                child: SafeArea(
                  child: Column(
                    // * this is the column for the intro page
                    //! this is where I'm going to have a welcome screen to talk about the app
                    children: <Widget>[
                      const Text("Welcome to the Dice App",
                          style: TextStyle(fontSize: 20)),
                      Image.asset("assets/gif/DiceRollingAnimation.gif"),
                    ],
                  ),
                ),
              ),
              /**
               * This is the sign in page
               * this is where the user will sign in no matter what
               * the reason why is because the account has to be associated with someone
               */

              Container(
                  color: const Color.fromARGB(255, 85, 100, 80),
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

                        //this is where the user will enter their email

                        emailSignIn(),

                        const SizedBox(height: 20),
                        //this is where the user will enter their password
                        passwordSignIn(),

                        const SizedBox(height: 20),
                        //this is where the user will press the sign in button
                        signInButton(),

                        const SizedBox(height: 10),
                        //Register Button
                        registerButton(),

                        const SizedBox(height: 10),
                        forgotPasswordButton(),
                      ],
                    ),
                  )),
            ],
          ),

          //adding the dot indicators
          SafeArea(
            child: Container(
              alignment: Alignment.bottomCenter,
              child: SmoothPageIndicator(controller: _controller, count: 2),
            ),
          ),
        ],
      ),
    );
  }

  //DRAWING THE WELCOME BACK TO THE DICE APP AND SIGN IN WITH YOUR EMAIL OR PHONE NUMBER
  printWelcomeToDiceApp() {
    return const Text(
      'Welcome Back To The Dice App',
      style: TextStyle(
          fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
    );
  }

  printSignInWithEmailOrPhoneNumber() {
    return const Text('Sign In With Your Email or PhoneNumber',
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white));
  }
  //END OF THE DRAWING THE WELCOME BACK TO THE DICE APP AND SIGN IN WITH YOUR EMAIL OR PHONE NUMBER

  //DRAWING THE EMAIL, PASSWORD AND SIGN IN BUTTON
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

  signInButton() {
    return MyButton(func: SignIn, text: "Sign In");
  }
  //END OF THE DRAWING OF THE EMAIL, PASSWORD AND SIGN IN BUTTON

  registerButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Don\'t have an account?',
          style: TextStyle(
              color: Color.fromARGB(255, 185, 185, 185), fontSize: 16),
        ),
        GestureDetector(
          onTap: () => showRegisterPage(),
          child: const Text(
            'Register',
            style: TextStyle(color: Colors.blue, fontSize: 16),
          ),
        ),
      ],
    );
  }

  convertToJson() {
    return {
      "email": _emailController.text.trim(),
      "password": _passwordController.text.trim(),
    };
  }

  Future SignIn() async {
    var email = _emailController.text.trim();
    var password = _passwordController.text.trim();

    var errorMessage = "";
    var goodToGo = true;
    if (password.isEmpty || password.length < 6) {
      errorMessage = "Password must be at least 6 characters";
      goodToGo = false;
    }
    if (email.isEmpty) {
      errorMessage = "Email cannot be empty";
      goodToGo = false;
    }

    if (goodToGo) {
      var msg = await FirebaseFunctions.signIn(email, password);
      if (msg != "Good To Go") {
        errorMessage = msg;
      } else {
        return;
      }
    }

    if (errorMessage.isNotEmpty) {
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
  }

  forgotPasswordButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Dont Remember Your Password?",
            style: TextStyle(
              color: Color.fromARGB(255, 185, 185, 185),
            ),
          ),
          GestureDetector(
            onTap: () {
              print("Forgot Password");
              //go back to the forgotpw page
              //but give the option to go back as well
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ForgotPw(),
                ),
              );
            },
            child: const Text(
              "Click Here",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
