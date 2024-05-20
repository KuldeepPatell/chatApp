import 'package:chat_app/models/ui_helper.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screens/current_user_profile_details.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class NavBar extends StatelessWidget {
  final UserModel currentUser;
  final User firebaseUser;

  NavBar({super.key, required this.currentUser, required this.firebaseUser});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Drawer(
        width: screenWidth * .6,
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                color: Theme.of(context).colorScheme.secondary,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 8.h,
                      ),
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
                      SizedBox(height: 5.h),
                      Text(currentUser.fullname.toString(),
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.white)),
                      SizedBox(height: 1.h),
                      // Text(widget.currentUser.email.toString(),
                      //     style:
                      //         TextStyle(fontSize: 14.sp, color: Colors.white)),
                      // Text("+91 " + widget.currentUser.mobileNumber.toString(),
                      //     style:
                      //         TextStyle(fontSize: 13.sp, color: Colors.white)),
                    ],
                  ),
                ),
              ),
              // UserAccountsDrawerHeader(
              //   accountName: Text(widget.currentUser.fullname.toString(),
              //       style: TextStyle(fontSize: 13.sp)),
              //   accountEmail: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(widget.currentUser.email.toString(),
              //           style: TextStyle(fontSize: 13.sp)),
              //       Text("+91 " + widget.currentUser.mobileNumber.toString(),
              //           style: TextStyle(fontSize: 13.sp)),
              //     ],
              //   ),
              //   currentAccountPicture: CircleAvatar(
              //     backgroundColor: Colors.grey,
              //     backgroundImage:
              //         NetworkImage(widget.currentUser.profilepic.toString()),
              //   ),
              // ),
              // SizedBox(
              //   height: arrIcons.length * 50,
              //   child: ListView.builder(
              //     itemBuilder: ((context, index) {
              //       return ListTile(
              //         leading: arrIcons[index],
              //         title: Text(
              //           "${arrTitle[index]}",
              //           style: TextStyle(fontSize: 16.sp),
              //         ),
              //         onTap: () => null,
              //       );
              //     }),
              //     itemCount: arrIcons.length,
              //   ),
              // ),
              // Divider(),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Profile"),
                trailing: Icon(
                  Icons.play_arrow,
                  size: 15.sp,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CurrentUserDetailScreen(
                            currentUser: currentUser,
                            firebaseUser: firebaseUser),
                      ));
                },
              ),
              // SizedBox(
              //   height: arrIcons2.length * 45,
              //   child: ListView.builder(
              //     itemBuilder: ((context, index) {
              //       return ListTile(
              //         leading: arrIcons2[index],
              //         title: Text(
              //           "${arrTitle2[index]}",
              //           style: TextStyle(fontSize: 16.sp),
              //         ),
              //         onTap: () => null,
              //       );
              //     }),
              //     itemCount: arrIcons2.length,
              //   ),
              // ),
              Divider(),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text(
                  'LogOut',
                  style: TextStyle(fontSize: 16.sp),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                        title: Text(
                          'Want to exit',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('No',
                                  style: TextStyle(fontSize: 15.sp))),
                          TextButton(
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                                Navigator.popUntil(
                                    context, (route) => route.isFirst);
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return LogInScreen();
                                }));
                              },
                              child: Text('Yes',
                                  style: TextStyle(fontSize: 15.sp))),
                        ]),
                  );
                },
                trailing: Icon(
                  Icons.play_arrow,
                  size: 15.sp,
                ),
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
