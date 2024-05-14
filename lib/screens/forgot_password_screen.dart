import 'package:chat_app/models/ui_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();

  void checkValues() {
    String email = emailController.text.trim();

    if (email == "") {
      // UIHelper.showAlertDialog(
      //     context, "Incomplete Data", "Please fill all the fields");
      UIHelper.showSnackbar(context, "Please enter the Email");
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
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Chat App",
                  style: TextStyle(
                      fontSize: 45.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary),
                ),
                SizedBox(
                  height: 10.h,
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
                  height: 10.h,
                ),
                SizedBox(
                  height: 40.h,
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
