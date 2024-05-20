import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmEmailScreen extends StatelessWidget {
  ConfirmEmailScreen({super.key});

  TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        "Verify your email",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Verify your email",
                      ),
                    ],
                  ),
                  TextField(
                    controller: codeController,
                    decoration: InputDecoration(
                        labelText: "Please enter the code sent to the mail"),
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
                      // checkValues();
                    },
                    color: Theme.of(context).colorScheme.secondary,
                  )
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}
