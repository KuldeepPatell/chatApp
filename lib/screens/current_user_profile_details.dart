import 'package:chat_app/models/ui_helper.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CurrentUserDetailScreen extends StatelessWidget {
  final UserModel currentUser;
  final User firebaseUser;

  const CurrentUserDetailScreen(
      {super.key, required this.currentUser, required this.firebaseUser});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: screenWidth * .42,
          leading: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back)),
            ],
          ),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  UIHelper.showImageDialog(
                      context,
                      currentUser.fullname.toString(),
                      currentUser.profilepic.toString());
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  backgroundImage:
                      NetworkImage(currentUser.profilepic.toString()),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                currentUser.fullname.toString(),
                style: TextStyle(fontSize: 18.sp),
              ),
              SizedBox(height: 2.h),
              Text(
                "+91 " + currentUser.mobileNumber.toString(),
                style: TextStyle(fontSize: 16.sp),
              ),
              SizedBox(height: 1.h),
            ],
          ),
          centerTitle: true,
          // actions: [
          //   Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
          //     ],
          //   )
          // ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                width: double.maxFinite,
                height: 50.h, // Thin height to resemble a divider
                decoration: BoxDecoration(
                  color: Colors.white, // Base color of the divider
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, 2), // Position the shadow
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Text(
                      "Hey there! I am using Chatapp",
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                width: double.maxFinite,
                // height: 250.h, // Thin height to resemble a divider
                decoration: BoxDecoration(
                  color: Colors.white, // Base color of the divider
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, 2), // Position the shadow
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(Icons.email),
                      title: Text(currentUser.email.toString()),
                    ),
                    ListTile(
                      leading: Icon(Icons.cake),
                      title: Text("Birth date"),
                    ),
                    ListTile(
                      leading: Icon(Icons.home),
                      title: Text("Address"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
