import 'dart:developer';

import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_room_model.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screens/target_user_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class ChatRoomScreen extends StatelessWidget {
  final UserModel targetUser;
  final ChatRoomModel chatroom;
  final UserModel userModel;
  final User firebaseUser;
  ChatRoomScreen(
      {Key? key,
      required this.targetUser,
      required this.chatroom,
      required this.userModel,
      required this.firebaseUser});

  TextEditingController messageController = TextEditingController();

  // bool? status;
  void sendMessage() async {
    String msg = messageController.text.trim();
    // bool? status = widget.chatroom.msgStatus;
    messageController.clear();
    if (msg != "") {
      // Send Message
      MessageModel newMessage = MessageModel(
          messageid: uuid.v1(),
          sender: userModel.uid,
          createdon: Timestamp.now(),
          text: msg,
          seen: false);
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatroom.chatroomid)
          .collection("messages")
          .doc(newMessage.messageid)
          .set(newMessage.toMap());

      chatroom.lastMessage = msg;
      chatroom.lastmessageon = Timestamp.now();
      // widget.chatroom.msgStatus = false;
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatroom.chatroomid)
          .set(chatroom.toMap());
      log("Message sent!");
      // status = true;

      // return true;
    }
    // return false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => UserDetailScreen(
                          targetUser: targetUser,
                          firebaseUser: firebaseUser,
                        )))),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage:
                      NetworkImage(targetUser.profilepic.toString()),
                ),
                SizedBox(width: 10.w),
                Text(targetUser.fullname.toString()),
              ],
            ),
          ),
        ),
        body: SafeArea(
            child: Container(
          child: Column(
            children: [
              Expanded(
                  child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("chatrooms")
                      .doc(chatroom.chatroomid)
                      .collection("messages")
                      .orderBy("createdon", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot dataSnapshot =
                            snapshot.data as QuerySnapshot;
                        return ListView.builder(
                            reverse: true,
                            itemCount: dataSnapshot.docs.length,
                            itemBuilder: (context, index) {
                              // print(
                              //     "--------dataSnapshot ${dataSnapshot.docs[0].data()}");
                              MessageModel currentMessage =
                                  MessageModel.fromMap(dataSnapshot.docs[index]
                                      .data() as Map<String, dynamic>);

                              DateTime dateTime =
                                  currentMessage.createdon!.toDate();
                              // String formattedDate =
                              //     '${dateTime.day}/${dateTime.month}/${dateTime.year}';

                              String formattedTime =
                                  '${(dateTime.hour > 12) ? dateTime.hour - 12 : dateTime.hour}:${dateTime.minute}';
                              //      -------->   last message time
                              // DateTime now = DateTime.now();
                              // Duration difference = now.difference(dateTime);
                              // // bool? status = widget.chatroom.msgStatus;

                              // // bool isSend = (status!) ? true : false;
                              // // bool isSend = status!;
                              // bool isSend = true;

                              return Column(
                                crossAxisAlignment:
                                    (currentMessage.sender == userModel.uid)
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                children: [
                                  // (difference.inHours < 24)
                                  //     ? Center(
                                  //         child: Container(
                                  //           child: Row(
                                  //             children: [Text("Today")],
                                  //           ),
                                  //         ),
                                  //       )
                                  //     : (difference.inHours >= 24 &&
                                  //             difference.inDays < 2)
                                  //         ? Center(
                                  //             child: Container(
                                  //               child: Row(
                                  //                 children: [Text("Yesterday")],
                                  //               ),
                                  //             ),
                                  //           )
                                  //         : Center(
                                  //             child: Container(
                                  //               child: Row(
                                  //                 children: [
                                  //                   Text("${formattedDate}")
                                  //                 ],
                                  //               ),
                                  //             ),
                                  //           ),
                                  Row(
                                    mainAxisAlignment:
                                        (currentMessage.sender == userModel.uid)
                                            ? MainAxisAlignment.end
                                            : MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    // mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                          margin: EdgeInsets.symmetric(
                                            vertical: 2.w,
                                          ),
                                          // padding: EdgeInsets.symmetric(
                                          //     vertical: 2, horizontal: 2),
                                          decoration: BoxDecoration(
                                              color: (currentMessage.sender ==
                                                      userModel.uid)
                                                  ? Colors.grey
                                                  : Colors.blue,
                                              borderRadius:
                                                  // BorderRadius.circular(5)
                                                  (currentMessage.sender ==
                                                          userModel.uid)
                                                      ? BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10))
                                                      : BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(10))),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: 8.h,
                                                    bottom: 8.h,
                                                    left: 8.w,
                                                    right: 4.w),
                                                child: Text(
                                                  currentMessage.text
                                                      .toString(),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: 2.h,
                                                    bottom: 3.h,
                                                    left: 3.w,
                                                    right: 8.w),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "${formattedTime}${(dateTime.hour > 12) ? " pm" : " am"}",
                                                      style: TextStyle(
                                                          fontSize: 10),
                                                    ),
                                                    // SizedBox(width: 3),
                                                    // (currentMessage.sender ==
                                                    //         widget.userModel.uid)
                                                    //     ? (isSend)
                                                    //         ? Icon(
                                                    //             Icons.done,
                                                    //             size: 12,
                                                    //           )
                                                    //         : Icon(
                                                    //             Icons.access_time,
                                                    //             size: 12)
                                                    //     : SizedBox(),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                  // Text(
                                  //   "${formattedTime}${(dateTime.hour > 12) ? " pm" : " am"}",
                                  //   style: TextStyle(fontSize: 9),
                                  // ),
                                  SizedBox(
                                    height: 5.sp,
                                  )
                                ],
                              );
                            });
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                              "An error occured ! Please check your internet connection."),
                        );
                      } else {
                        return Center(
                          child: Text("Say hi to your new friend"),
                        );
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              )),
              Container(
                color: Colors.grey[200],
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                child: Row(
                  children: [
                    Flexible(
                        child: TextField(
                      maxLines: null,
                      controller: messageController,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "Enter message"),
                    )),
                    IconButton(
                        onPressed: () {
                          sendMessage();
                        },
                        icon: Icon(
                          Icons.send,
                          color: Theme.of(context).colorScheme.secondary,
                        )),
                  ],
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
