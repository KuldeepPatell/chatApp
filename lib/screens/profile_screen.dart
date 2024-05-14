import 'dart:developer';
import 'dart:typed_data';

import 'package:chat_app/models/ui_helper.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const ProfileScreen(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Uint8List? imageFile;

  TextEditingController fullNameController = TextEditingController();

  void selectImage(ImageSource source) async {
    Uint8List img = await pickImage(source);
    setState(() {
      imageFile = img;
    });
  }

  pickImage(ImageSource source) async {
    log("selectImage");
    final ImagePicker _imagePicker = ImagePicker();
    XFile? pickedFile = await _imagePicker.pickImage(source: source);

    if (pickedFile != null) {
      return cropImage(pickedFile);
      // return await pickedFile.readAsBytes();
    }
    print("No image selecetd");
  }

  cropImage(XFile file) async {
    log("cropImage");
    print("---------crop image->" + file.path.toString());
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 20);
    if (croppedImage != null) {
      return await croppedImage.readAsBytes();
    }
    print("Not Cropped");
    // print("---------crop image->" + croppedImage!.path.toString());
    // if (croppedImage != null) {
    //   setState(() {
    //     imageFile = croppedImage;
    //   });
    // } else {
    //   print("-------not working--->");
    // }
  }

  void showPhotosOptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Upload Profile Picture"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.gallery);
                  },
                  leading: Icon(Icons.photo_album),
                  title: Text("Select from Gallery"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.camera);
                  },
                  leading: Icon(Icons.camera_alt),
                  title: Text("Take a photo"),
                )
              ],
            ),
          );
        });
  }

  void checkValues() {
    String fullname = fullNameController.text.trim();

    if (fullname == "" || imageFile == null) {
      // print("Please fill all the fields");
      // UIHelper.showAlertDialog(
      //     context, "Incomplete Data", "Please fill all the fields");
      UIHelper.showSnackbar(context, "Please fill all the fields");
    } else {
      uploadData();
      // log("uploading data...");
    }
  }

  void uploadData() async {
    UIHelper.showLoadingDialog(context, "Please wait...!");
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("profilepictures")
        .child(widget.userModel.uid.toString())
        .putData(imageFile!);

    TaskSnapshot snapshot = await uploadTask;

    String? imageUrl = await snapshot.ref.getDownloadURL();
    String? fullname = fullNameController.text.trim();

    widget.userModel.fullname = fullname;
    widget.userModel.profilepic = imageUrl;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMap())
        .then((value) {
      log("Data uploaded!");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: ((context) => HomeScreen(
                  userModel: widget.userModel,
                  firebaseUser: widget.firebaseUser))));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("Complete Profile"),
      ),
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: ListView(
          children: [
            SizedBox(
              height: 20.h,
            ),
            CupertinoButton(
              onPressed: () {
                showPhotosOptions();
              },
              padding: EdgeInsets.all(0),
              child: CircleAvatar(
                radius: 60,
                backgroundImage:
                    (imageFile != null) ? MemoryImage(imageFile!) : null,
                child: (imageFile == null)
                    ? Icon(Icons.person, size: 60.sp)
                    : null,
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            TextField(
              controller: fullNameController,
              decoration: InputDecoration(labelText: "Full Name"),
            ),
            SizedBox(
              height: 20.h,
            ),
            CupertinoButton(
              child: Text("Submit"),
              onPressed: () {
                checkValues();
              },
              color: Theme.of(context).colorScheme.secondary,
            )
          ],
        ),
      )),
    );
  }
}
