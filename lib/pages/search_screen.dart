import 'package:chat_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const SearchScreen(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Search"),
      ),
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: "Email Address"),
            ),
            SizedBox(
              height: 20,
            ),
            CupertinoButton(
              child: Text("Search"),
              onPressed: () {},
              color: Theme.of(context).colorScheme.secondary,
            ),
            SizedBox(
              height: 20,
            ),
            // StreamBuilder(stream: stream, builder: builder)
          ],
        ),
      )),
    );
  }
}
