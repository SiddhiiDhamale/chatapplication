// import 'dart:html';

// import 'dart:convert';

import 'package:chatapp/helper/constant.dart';
// import 'package:chatapp/modal/user.dart';
import 'package:chatapp/services/database.dart';
// import 'package:chatapp/views/chatroomScreen.dart';
import 'package:chatapp/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen(this.chatRoomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController messageTextEditingController =
      new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  QuerySnapshot snapshot;
  Stream chatStream;
  CollectionReference chatroom =
      FirebaseFirestore.instance.collection('chatRoom');

  Widget chatMessageList() {
    //return StreamBuilder<QuerySnapshot>(
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("chatRoom")
          .doc(widget.chatRoomId)
          .collection("chats")
          // .where("message",  isEqualTo:message)
          .orderBy('time')
          .orderBy("asc")

          //    .get();
          .snapshots(),
      //FirebaseFirestore.instance.collection('chatRoom').snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  print(" HEY!! I am ds[message] : " + ds["message"]);
                  return Text(
                      //To read a collection or document once, call the Query.get or DocumentReference.get methods.
                      // snapshot.data.doc[index].get("message"),
                      // userSearchEmail: searchsnapshot.docs[index].get("email"),

                      // ds.toString(),
                      ds["message"]
                      //  messageTextEditingController.text
                      );
                },
              )
            : Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
      },
    );
  }

  sendMessage() {
    if (messageTextEditingController.text.isNotEmpty) {
      Map<String, String> messageMap = {
        "message": messageTextEditingController.text,
        "sendBy": Constants.myName,
      };
      print(".........controller " + messageTextEditingController.text);

      databaseMethods.addConversationMessage(widget.chatRoomId, messageMap);
      print(" From messageMap  $messageMap");
      messageTextEditingController.text = "";
    }
  }

  getAndSetMessage() async {
    chatStream =
        await databaseMethods.getConversationMessage(widget.chatRoomId);
    print(" Hi this getandsetmessage() function starting. ");
    print("This is chatroom id: " + widget.chatRoomId);

    setState(() {
      print("Value of chatstream $chatStream");
      print(snapshot);
    });
  }

  // dothisOnLaunch() {
  //   getAndSetMessage();
  //   print("I am getmsg " + getAndSetMessage());
  // }

  void initState() {
    super.initState();
    // sendMessage();
    //dothisOnLaunch();
    getAndSetMessage();
  }

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
          child: Stack(
        children: [
          chatMessageList(),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageTextEditingController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "tpye a message......",
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  //Container for icon sizing
                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0x36FFFFFF),
                            const Color(0x0FFFFFF),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Icon(
                        Icons.send_outlined,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}

class MessageTile extends StatefulWidget {
  final String message;
  MessageTile(this.message);

  @override
  _MessageTileState createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  String a = 'Hey';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(widget.message, style: mediumTextFieldStyle()),
    );
    // ignore: dead_code
  }
}
