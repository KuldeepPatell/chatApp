import 'package:chat_app/screens/profile_Photo_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UIHelper {
  static void showLoadingDialog(BuildContext context, String title) {
    AlertDialog loadingDialog = AlertDialog(
      content: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 30.h),
            Text(
              title,
              style: TextStyle(fontSize: 16.sp),
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return loadingDialog;
        });
  }

  static void showImageDialog(
      BuildContext context, String userName, String url) {
    Dialog imageDialog = Dialog(
      child: InkWell(
        onTap: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: ((context) => ProfilePhotoScreen(
                        userName: userName,
                        profileUrl: url,
                      ))));
        },
        child: Stack(children: [
          // Positioned(
          //     top: 0.h,
          //     left: 0.w,
          //     child: Container(
          //       color: Colors.black45,
          //       width: 300.w,
          //       child: Padding(
          //         padding:
          //             EdgeInsets.symmetric(vertical: 5.h, horizontal: 25.w),
          //         child: Text(
          //           userName,
          //           style: TextStyle(fontSize: 20.sp, color: Colors.white),
          //         ),
          //       ),
          //     )),
          Container(
            height: 300.h,
            width: 300.w,
            child: Column(
              children: [
                Container(
                  color: Colors.black,
                  width: 300.w,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 5.h, horizontal: 25.w),
                    child: Text(
                      userName,
                      style: TextStyle(fontSize: 20.sp, color: Colors.white),
                    ),
                  ),
                ),
                Image.network(
                  url,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ]),
      ),
    );
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return imageDialog;
        });
  }
  // static void showAlertDialog(
  //     BuildContext context, String title, String content) {
  //   AlertDialog alertDialog = AlertDialog(
  //     title: Text(title),
  //     content: Text(content),
  //     actions: [
  //       TextButton(
  //         onPressed: () {
  //           Navigator.pop(context);
  //         },
  //         child: Text("Ok"),
  //       )
  //     ],
  //   );
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return alertDialog;
  //       });
  // }

  //For calling------> UIHelper.showSnackbar(context, "This is a Snackbar message.");
  static void showSnackbar(BuildContext context, String message, String color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: (color == "green")
                ? Colors.lightGreen
                : (color == "red")
                    ? Colors.red
                    : Colors.white,
          ),
        ),
        duration: Duration(seconds: 2), // Adjust the duration as needed
        action: SnackBarAction(label: 'Dismiss', onPressed: () {}),
      ),
    );
  }
}
