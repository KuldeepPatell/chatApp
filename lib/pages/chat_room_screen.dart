import 'dart:developer';

import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_room_model.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatRoomScreen extends StatefulWidget {
  final UserModel targetUser;
  final ChatRoomModel chatroom;
  final UserModel userModel;
  final User firebaseUser;
  const ChatRoomScreen(
      {Key? key,
      required this.targetUser,
      required this.chatroom,
      required this.userModel,
      required this.firebaseUser});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
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
          sender: widget.userModel.uid,
          createdon: Timestamp.now(),
          text: msg,
          seen: false);
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatroomid)
          .collection("messages")
          .doc(newMessage.messageid)
          .set(newMessage.toMap());

      widget.chatroom.lastMessage = msg;
      widget.chatroom.lastmessageon = Timestamp.now();
      // widget.chatroom.msgStatus = false;
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatroomid)
          .set(widget.chatroom.toMap());
      log("Message sent!");
      // status = true;

      // return true;
    }
    // return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage:
                  NetworkImage(widget.targetUser.profilepic.toString()),
            ),
            SizedBox(width: 10),
            Text(widget.targetUser.fullname.toString()),
          ],
        ),
      ),
      body: SafeArea(
          child: Container(
        child: Column(
          children: [
            Expanded(
                child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chatrooms")
                    .doc(widget.chatroom.chatroomid)
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
                            MessageModel currentMessage = MessageModel.fromMap(
                                dataSnapshot.docs[index].data()
                                    as Map<String, dynamic>);

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
                              crossAxisAlignment: (currentMessage.sender ==
                                      widget.userModel.uid)
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
                                  mainAxisAlignment: (currentMessage.sender ==
                                          widget.userModel.uid)
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  // mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                        margin: EdgeInsets.symmetric(
                                          vertical: 2,
                                        ),
                                        // padding: EdgeInsets.symmetric(
                                        //     vertical: 2, horizontal: 2),
                                        decoration: BoxDecoration(
                                            color: (currentMessage.sender ==
                                                    widget.userModel.uid)
                                                ? Colors.grey
                                                : Colors.blue,
                                            borderRadius:
                                                // BorderRadius.circular(5)
                                                (currentMessage.sender ==
                                                        widget.userModel.uid)
                                                    ? BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(10),
                                                        topRight:
                                                            Radius.circular(10),
                                                        bottomLeft:
                                                            Radius.circular(10))
                                                    : BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(10),
                                                        topLeft:
                                                            Radius.circular(10),
                                                        bottomRight:
                                                            Radius.circular(
                                                                10))),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 8,
                                                  bottom: 8,
                                                  left: 8,
                                                  right: 4),
                                              child: Text(
                                                currentMessage.text.toString(),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 2,
                                                  bottom: 3,
                                                  left: 3,
                                                  right: 8),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "${formattedTime}${(dateTime.hour > 12) ? " pm" : " am"}",
                                                    style:
                                                        TextStyle(fontSize: 10),
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
                                  height: 5,
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
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
    );
  }
}
