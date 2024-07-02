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
        ElevatedButton(
          onPressed: () {},
          child: const Text("Send Email"),
        )
      ],
    );
  }

  void sendForgotPwEmail() {
    
  }

}
