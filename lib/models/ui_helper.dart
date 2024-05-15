import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UIHelper {
  static void showLoadingDialog(BuildContext context, String title) {
    AlertDialog loadingDialog = AlertDialog(
      content: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 30),
            Text(title),
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

  static void showImageDialog(BuildContext context, String url) {
    Dialog imageDialog = Dialog(
      child: Container(
        height: 250,
        width: 250,
        child: Image.network(url),
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
