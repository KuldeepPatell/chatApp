import 'package:chat_app/models/chat_room_model.dart';
import 'package:chat_app/models/firebase_helper.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/pages/chat_room_screen.dart';
import 'package:chat_app/pages/login_screen.dart';
import 'package:chat_app/pages/search_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const HomeScreen(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Chat App"),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return LogInScreen();
                }));
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: SafeArea(
          child: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("chatrooms")
              .where(
                  // "participants.${widget.userModel.uid}", isEqualTo: true
                  "users",
                  arrayContains: widget.userModel.uid)
              .orderBy("lastmessageon", descending: true)
              // .where("chatrooms", arrayContains: widget.userModel.uid)
              // .orderBy("createdon", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                QuerySnapshot chatRoomSnapshot = snapshot.data as QuerySnapshot;
                return ListView.builder(
                  itemCount: chatRoomSnapshot.docs.length,
                  itemBuilder: (context, index) {
                    ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                        chatRoomSnapshot.docs[index].data()
                            as Map<String, dynamic>);

                    Map<String, dynamic> participants =
                        chatRoomModel.participants!;

                    DateTime dateTime = chatRoomModel.lastmessageon!.toDate();
                    String formattedDate =
                        '${dateTime.day}/${dateTime.month}/${dateTime.year}';

                    String formattedTime =
                        '${(dateTime.hour > 12) ? dateTime.hour - 12 : dateTime.hour}:${dateTime.minute}';
//      -------->   last message time
                    DateTime now = DateTime.now();
                    Duration difference = now.difference(dateTime);

                    // bool msgStatus = chatRoomModel.msgStatus!;

                    List<String> participantKeys = participants.keys.toList();
                    participantKeys.remove(widget.userModel.uid);
                    return FutureBuilder(
                        future:
                            FirebaseHelper.getUserModelById(participantKeys[0]),
                        builder: (context, userData) {
                          if (userData.connectionState ==
                              ConnectionState.done) {
                            if (userData.data != null) {
                              UserModel targetUser = userData.data as UserModel;
                              return ListTile(
                                  onTap: () {
                                    // setState(() {
                                    //   chatRoomModel.msgStatus = true;
                                    // });
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ChatRoomScreen(
                                          targetUser: targetUser,
                                          chatroom: chatRoomModel,
                                          userModel: widget.userModel,
                                          firebaseUser: widget.firebaseUser);
                                    }));
                                  },
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        targetUser.profilepic.toString()),
                                  ),
                                  title: Text(targetUser.fullname.toString()),
                                  subtitle: (chatRoomModel.lastMessage
                                              .toString() !=
                                          "")
                                      ? Text(
                                          chatRoomModel.lastMessage.toString())
                                      : Text(
                                          "Say hi to your new friend!",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                        ),
                                  trailing:
                                      // (difference.inSeconds < 1)
                                      //     ? Text("now")
                                      //     : (difference.inSeconds >= 1 &&
                                      //             difference.inSeconds < 60)
                                      //         ? Text(
                                      //             "${difference.inSeconds} seconds")
                                      //         : (difference.inMinutes >= 1 &&
                                      //                 difference.inMinutes < 60)
                                      //             ? Text(
                                      //                 "${difference.inMinutes} minutes")
                                      //             :
                                      (difference.inHours < 24)
                                          ? Text(
                                              "${formattedTime}${(dateTime.hour > 12) ? " pm" : " am"}")
                                          : (difference.inDays >= 1 &&
                                                  difference.inDays < 2)
                                              ? Text("yesterday")
                                              : Text(formattedDate.toString()));
                            } else {
                              return Container();
                            }
                          } else {
                            return Container();
                          }
                        });
                  },
                );
              } else if (snapshot.hasError) {
                print(snapshot.error.toString());
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else {
                return Center(
                  child: Text("No Chats"),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return SearchScreen(
                userModel: widget.userModel, firebaseUser: widget.firebaseUser);
          }));
        },
        child: Icon(Icons.search),
      ),
    );
  }
}
