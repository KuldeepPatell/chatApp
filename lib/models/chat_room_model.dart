import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  String? chatroomid;
  Map<String, dynamic>? participants;
  String? lastMessage;
  List<dynamic>? users;
  Timestamp? createdon;
  Timestamp? lastmessageon;

  ChatRoomModel(
      {this.chatroomid,
      this.participants,
      this.lastMessage,
      this.users,
      this.createdon,
      this.lastmessageon});

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatroomid = map["chatroomid"];
    participants = map["participants"];
    lastMessage = map["lastmessage"];
    users = map["users"];
    createdon = map["createdon"];
    lastmessageon = map["lastmessageon"];
  }

  Map<String, dynamic> toMap() {
    return {
      "chatroomid": chatroomid,
      "participants": participants,
      "lastmessage": lastMessage,
      "users": users,
      "createdon": createdon,
      "lastmessageon": lastmessageon
    };
  }
}
