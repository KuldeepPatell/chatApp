import 'package:chat_app/models/ui_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController emailController = TextEditingController();

  void checkValues() {
    String email = emailController.text.trim();

    if (email == "") {
      // UIHelper.showAlertDialog(
      //     context, "Incomplete Data", "Please fill all the fields");
      UIHelper.showSnackbar(context, "Please fill all the fields");
      // setState(() {});
      // print("Please fill all the fields!");
    } else {
      resetPassword(email);
    }
  }

  void resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // Password reset email sent successfully
      UIHelper.showSnackbar(context, 'Password reset email sent successfully');
      print('Password reset email sent successfully');
      emailController.clear();
    } catch (error) {
      // Handle errors such as invalid email, user not found, etc.
      UIHelper.showSnackbar(
          context, 'Error sending password reset email: $error');
      print('Error sending password reset email: $error');
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Chat App",
                  style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Colors.grey,
                      ),
                      labelText: "Email Address"),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 40,
                ),
                CupertinoButton(
                  child: Text("Reset Password"),
                  onPressed: () {
                    checkValues();
                  },
                  color: Theme.of(context).colorScheme.secondary,
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
