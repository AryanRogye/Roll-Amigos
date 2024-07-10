import 'package:dice_pt2/components/firebase/firebase_functions.dart';
import 'package:dice_pt2/themes/const_themes.dart';
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(""),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: showForgotPw(),
    );
  }

  showForgotPw() {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        gradient: constThemes.linGrad,
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: Text(
                "Forgot Your Password?",
                style: constThemes.getWorkSansFont(
                  Colors.white,
                  24,
                  FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: Text(
                "Enter your email and we will send you a",
                style: constThemes.getWorkSansFont(
                  Colors.white,
                  16,
                  FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: Text(
                "link to reset your password",
                style: constThemes.getWorkSansFont(
                  Colors.white,
                  16,
                  FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                decoration: constThemes.myBoxDecoration,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    cursorColor: const Color.fromARGB(255, 255, 255, 255),
                    controller: _emailController,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255)),
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      hintStyle: constThemes.hintTextTheme,
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: constThemes.myBoxDecoration,
              width: 200,
              child: MaterialButton(
                onPressed: () {
                  sendForgotPwEmail();
                },
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  "Send Email",
                  style: constThemes.getWorkSansFont(
                      Colors.white, 16, FontWeight.normal),
                ),
              ),
            )
          ],
        ),
      ),
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
