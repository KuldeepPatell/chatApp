import 'package:chat_app/models/ui_helper.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  bool isTextFieldEnabled = true;
  bool isButtonEnabled = false;
  bool show = true;
  bool show2 = true;

  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String cpassword = cpasswordController.text.trim();
    String number = mobileNumberController.text.trim();
    String otp = otpController.text.trim();

    if (email == "" ||
        password == "" ||
        cpassword == "" ||
        number == "" ||
        otp == "") {
      // print("Please fill all the fields!");
      // UIHelper.showAlertDialog(
      //     context, "Incomplete Data", "Please fill all the fields");
      UIHelper.showSnackbar(context, "Please fill all the fields", "white");
    } else if (password != cpassword) {
      // print("Password do not match!");
      // UIHelper.showAlertDialog(context, "Password Mismatch",
      //     "The password you entered do not match!");
      UIHelper.showSnackbar(
          context, "The password you entered do not match!", "white");
    } else if (isButtonEnabled) {
      signUp(email, password, number);
    } else {
      UIHelper.showSnackbar(context, "OTP not verified", "red");
    }
  }

  void signUp(String email, String password, String number) async {
    UserCredential? credential;
    UIHelper.showLoadingDialog(context, "Creating new account...");

    try {
      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      Navigator.pop(context);
      // UIHelper.showAlertDialog(
      //     context, "An error occured", ex.message.toString());
      UIHelper.showSnackbar(context, ex.message.toString(), "red");
      // print(ex.code.toString());
    }

    if (credential != null) {
      String uid = credential.user!.uid;
      UserModel newUser = UserModel(
          uid: uid,
          email: email,
          mobileNumber: number,
          fullname: "",
          profilepic: "");
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
    UIHelper.showLoadingDialog(context, "Sending OTP");
    // emit(AuthLoadingState());
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      codeSent: (verificationId, forceResendingToken) {
        _verificationId = verificationId;
        // emit(AuthCodeSentState());
        Navigator.pop(context);
        UIHelper.showSnackbar(context, "OTP send successfully", "white");
      },
      verificationCompleted: (phoneAuthCredential) {
        // signInWithPhone(phoneAuthCredential);
        UIHelper.showSnackbar(
            context, "Phone number verified successfully", "green");
        onVariableChange(true);
      },
      verificationFailed: (error) {
        // emit(AuthErrorState(error.message.toString()));
        Navigator.pop(context);
        UIHelper.showSnackbar(context, "$error", "red");
        print("$error");
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
    print("send otp called");
    // UIHelper.showSnackbar(context, "OTP send successfully");
  }

  void verifyOTP(String otp) async {
    try {
      UIHelper.showLoadingDialog(context, "Verifying  OTP");
      // emit(AuthLoadingState());
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!, smsCode: otp);

      signInWithPhone(credential);
      print("verify otp called");
    } catch (ex) {
      Navigator.pop(context);
      (otp.toString() == "")
          ? UIHelper.showSnackbar(context, "Please enter  OTP", "white")
          : UIHelper.showSnackbar(context, "Invalid OTP", "red");
    }
  }

  void signInWithPhone(PhoneAuthCredential credential) async {
    try {
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        // emit(AuthLoggedInState(userCredential.user!));
        setState(() {
          isButtonEnabled = true;
        });

        Navigator.pop(context);
        UIHelper.showSnackbar(
            context, "Phone number verified successfully", "green");
        print("Phone number verified successfully");
      }
    } on FirebaseAuthException catch (ex) {
      // emit(AuthErrorState(ex.message.toString()));
      Navigator.pop(context);
      UIHelper.showSnackbar(context, "$ex", "red");
      print("$ex");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
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
                        fontSize: 45.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  SizedBox(
                    height: 10.h,
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
                    height: 10.h,
                  ),
                  TextField(
                    enabled: isTextFieldEnabled,
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
                    height: 10.h,
                  ),
                  TextField(
                    enabled: isTextFieldEnabled,
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
                    height: 10.h,
                  ),
                  Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: screenWidth * .5,
                              child: TextField(
                                enabled: isTextFieldEnabled,
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
                                  (isTextFieldEnabled && phoneNumber != "+91")
                                      ? sendOTP(phoneNumber)
                                      : (!isTextFieldEnabled)
                                          ? UIHelper.showSnackbar(
                                              context,
                                              "Please verify Email first",
                                              "red")
                                          : (isButtonEnabled &&
                                                  phoneNumber == "+91")
                                              ? UIHelper.showSnackbar(
                                                  context,
                                                  "Please enter mobile number",
                                                  "white")
                                              : UIHelper.showSnackbar(
                                                  context,
                                                  "Please enter mobile number",
                                                  "white");
                                },
                                child: Text("Send OTP")),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Column(
                    children: [
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: screenWidth * .5,
                              child: TextField(
                                enabled: isTextFieldEnabled,
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
                                onPressed: () {
                                  // verifyOTP(otpController.text);
                                  (isTextFieldEnabled)
                                      ? verifyOTP(otpController.text)
                                      : UIHelper.showSnackbar(context,
                                          "Please verify Email first", "red");
                                },
                                child: Text("Verify OTP")),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  CupertinoButton(
                    child: Text("Sign Up"),
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
        bottomNavigationBar: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already have an account?",
                style: TextStyle(fontSize: 16.sp),
              ),
              CupertinoButton(
                  child: Text(
                    "Log In",
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
