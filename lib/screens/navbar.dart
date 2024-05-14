import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NavBar extends StatefulWidget {
  final UserModel currentUser;
  final User firebaseUser;

  const NavBar(
      {super.key, required this.currentUser, required this.firebaseUser});

  @override
  State<NavBar> createState() => _NavBar();
}

class _NavBar extends State<NavBar> {
  var arrIcons = [
    Icon(Icons.favorite),
    Icon(Icons.people),
    Icon(Icons.share),
    Icon(Icons.notifications)
  ];

  var arrIcons2 = [
    Icon(Icons.settings),
    Icon(Icons.description),
  ];

  var arrTitle = ['Favorites', 'Freinds', 'Share', 'Requests'];
  var arrTitle2 = [
    'Settings',
    'Policies',
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Drawer(
      width: screenWidth * .7,
      child: Center(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(widget.currentUser.fullname.toString(),
                  style: TextStyle(fontSize: 15.sp)),
              accountEmail: Text(
                  widget.currentUser.email.toString() +
                      "\n+91 " +
                      widget.currentUser.mobileNumber.toString(),
                  style: TextStyle(fontSize: 15.sp)),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage:
                    NetworkImage(widget.currentUser.profilepic.toString()),
              ),
            ),
            SizedBox(
              height: arrIcons.length * 50,
              child: ListView.builder(
                itemBuilder: ((context, index) {
                  return ListTile(
                    leading: arrIcons[index],
                    title: Text(
                      "${arrTitle[index]}",
                      style: TextStyle(fontSize: 20.sp),
                    ),
                    onTap: () => null,
                  );
                }),
                itemCount: arrIcons.length,
              ),
            ),
            Divider(),
            SizedBox(
              height: arrIcons2.length * 50,
              child: ListView.builder(
                itemBuilder: ((context, index) {
                  return ListTile(
                    leading: arrIcons2[index],
                    title: Text(
                      "${arrTitle2[index]}",
                      style: TextStyle(fontSize: 20.sp),
                    ),
                    onTap: () => null,
                  );
                }),
                itemCount: arrIcons2.length,
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(
                'LogOut',
                style: TextStyle(fontSize: 20.sp),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                      title: Text(
                        'Want to exit',
                        style: TextStyle(fontSize: 25.sp),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child:
                                Text('No', style: TextStyle(fontSize: 20.sp))),
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
                            child:
                                Text('Yes', style: TextStyle(fontSize: 20.sp))),
                      ]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
