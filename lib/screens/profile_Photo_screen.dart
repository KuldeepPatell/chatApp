import 'package:flutter/material.dart';

class ProfilePhotoScreen extends StatelessWidget {
  final String? userName;
  final String? profileUrl;

  const ProfilePhotoScreen({super.key, this.userName, this.profileUrl});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(userName.toString()),
        ),
        body: SafeArea(
          child: Container(
            child: Container(
              height: double.maxFinite,
              width: double.maxFinite,
              child: Image.network(
                profileUrl.toString(),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
