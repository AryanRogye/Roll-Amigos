import 'package:dice_pt2/components/firebase/firebase_functions.dart';
import 'package:flutter/material.dart';

class ForgotPw extends StatefulWidget {
  const ForgotPw({super.key});

  @override
  State<ForgotPw> createState() => _ForgotPwState();
}

class _ForgotPwState extends State<ForgotPw> {
  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: showForgotPw(),
    );
  }

  showForgotPw() {
    return Column(
      children: [
        const SizedBox(height: 50),
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          child: const Text(
            "Forgot Your Password",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          child: const Text(
            "Enter your email and we will send you a link to",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          child: const Text(
            "reset your password",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                cursorColor: Colors.black,
                controller: _emailController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: 200,
          child: MaterialButton(
            color: Colors.grey[50],
            onPressed: () {
              sendForgotPwEmail();
            },
            child: const Text("Send Email"),
          ),
        )
      ],
    );
  }

  void sendForgotPwEmail() async {
    var email = _emailController.text.trim();
    var msg =
        await FirebaseFunctions.forgotPassword(email: email, context: context);
    if (msg == "Good To Go") {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              "Email sent to $email",
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          );
        },
      );
    }
  }
}
