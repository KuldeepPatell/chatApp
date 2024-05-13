import 'package:chat_app/models/ui_helper.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cpasswordController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  String? phoneNumber;
  String? _verificationId;

  bool isButtonEnabled = false;
  bool show = true;
  bool show2 = true;

  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String cpassword = cpasswordController.text.trim();
    String number = mobileNumberController.text.trim();

    if (email == "" || password == "" || cpassword == "" || number == "") {
      // print("Please fill all the fields!");
      // UIHelper.showAlertDialog(
      //     context, "Incomplete Data", "Please fill all the fields");
      UIHelper.showSnackbar(context, "Please fill all the fields");
    } else if (password != cpassword) {
      // print("Password do not match!");
      // UIHelper.showAlertDialog(context, "Password Mismatch",
      //     "The password you entered do not match!");
      UIHelper.showSnackbar(context, "The password you entered do not match!");
    } else {
      signUp(email, password);
    }
  }

  void signUp(String email, String password) async {
    UserCredential? credential;
    UIHelper.showLoadingDialog(context, "Creating new account...");
    try {
      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      Navigator.pop(context);
      // UIHelper.showAlertDialog(
      //     context, "An error occured", ex.message.toString());
      UIHelper.showSnackbar(context, ex.message.toString());
      // print(ex.code.toString());
    }

    if (credential != null) {
      String uid = credential.user!.uid;
      UserModel newUser =
          UserModel(uid: uid, email: email, fullname: "", profilepic: "");
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(newUser.toMap())
          .then((value) {
        print("New user created!");
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return ProfileScreen(
              userModel: newUser, firebaseUser: credential!.user!);
        }));
      });
    }
  }

  void onVariableChange(bool newValue) {
    setState(() {
      isButtonEnabled = newValue; // Update the state of the button
    });
  }

  void sendOTP(String phoneNumber) async {
    // emit(AuthLoadingState());
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      codeSent: (verificationId, forceResendingToken) {
        _verificationId = verificationId;
        // emit(AuthCodeSentState());
      },
      verificationCompleted: (phoneAuthCredential) {
        // signInWithPhone(phoneAuthCredential);
        UIHelper.showSnackbar(context, "Phone number verified successfully");
        onVariableChange(true);
      },
      verificationFailed: (error) {
        // emit(AuthErrorState(error.message.toString()));
        UIHelper.showSnackbar(context, "$error");
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  void verifyOTP(String otp) async {
    // emit(AuthLoadingState());
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!, smsCode: otp);

    signInWithPhone(credential);
  }

  void signInWithPhone(PhoneAuthCredential credential) async {
    try {
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        // emit(AuthLoggedInState(userCredential.user!));
      }
    } on FirebaseAuthException catch (ex) {
      // emit(AuthErrorState(ex.message.toString()));
    }
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
                  keyboardType: TextInputType.emailAddress,
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
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: passwordController,
                  obscureText: show,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.grey,
                      ),
                      labelText: "Password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          show ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            show = !show;
                          });
                        },
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: cpasswordController,
                  obscureText: show2,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.grey,
                      ),
                      labelText: "Confirm Password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          show2 ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            show2 = !show2;
                          });
                        },
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 325,
                          child: TextField(
                            keyboardType: TextInputType.phone,
                            controller: mobileNumberController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.phone,
                                color: Colors.grey,
                              ),
                              labelText: "Mobile Number",
                            ),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              String phoneNumber =
                                  '+91${mobileNumberController.text.trim()}'; // Format the phone number
                            },
                            child: Text("Send OTP")),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 325,
                            child: TextField(
                              controller: otpController,
                              maxLength: 6,
                              decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.password,
                                    color: Colors.grey,
                                  ),
                                  labelText: "6-Digit OTP",
                                  counterText: ""),
                            ),
                          ),
                          TextButton(
                              onPressed: () {}, child: Text("Verify OTP")),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                CupertinoButton(
                  child: Text("Sign Up"),
                  onPressed: isButtonEnabled
                      ? () {
                          checkValues();
                        }
                      : null,
                  color: Theme.of(context).colorScheme.secondary,
                )
              ],
            ),
          ),
        ),
      )),
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Already have an account?",
              style: TextStyle(fontSize: 16),
            ),
            CupertinoButton(
                child: Text(
                  "Log In",
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }
}