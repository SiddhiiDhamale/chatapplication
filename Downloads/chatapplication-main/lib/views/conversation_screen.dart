import 'package:chatapp/helper/constant.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Conversation_screen extends StatefulWidget {
  final String chatroomid;

  Conversation_screen({this.chatroomid});

  @override
  _Conversation_screenState createState() => _Conversation_screenState();
}

class _Conversation_screenState extends State<Conversation_screen> {
  TextEditingController messagecontroler = TextEditingController();
  Stream<QuerySnapshot> chatMessageStream;
  Widget ChatMessageList() {
    return StreamBuilder(
        stream: chatMessageStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                        message:
                            snapshot.data.documents[index].data()["message"],
                        isSendByMe: Constants.myName ==
                            snapshot.data.documents[index].data()["sendBy"]);
                  })
              : Container();
        });
  }

  sendMessages() {
    if (messagecontroler.text.isNotEmpty) {
      Map<String, dynamic> messagemap = {
        "message": messagecontroler.text,
        "sendby": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      DatabaseMethods().addConversationMessage(widget.chatroomid, messagemap);
      messagecontroler.text = "";
    }
  }

  @override
  void initState() {
    DatabaseMethods().getConversationMessage(widget.chatroomid).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          child: Stack(
        children: <Widget>[
          ChatMessageList(),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Color(0x54ffffff),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Row(children: [
                Expanded(
                  child: TextField(
                      controller: messagecontroler,
                      style: simpleTextFieldStyle(),
                      decoration: InputDecoration(
                          hintText: "Message",
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none)),
                ),
                GestureDetector(
                  onTap: () {
                    sendMessages();
                    print("fghj");
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          const Color(0xff007EF4),
                          const Color(0xff2A75BC)
                        ]),
                        borderRadius: BorderRadius.circular(40)),
                    padding: EdgeInsets.all(12),
                    child: Image.asset("assets/images/send.png", height: 48),
                  ),
                )
              ]),
            ),
          ),
        ],
      )),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  const MessageTile({this.message, this.isSendByMe});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: isSendByMe ? 0 : 25, right: isSendByMe ? 25 : 0),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
          margin: EdgeInsets.all(6),
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: isSendByMe
                      ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                      : [const Color(0x1Affffff), const Color(0x2Affffff)]),
              borderRadius: isSendByMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                      bottomLeft: Radius.circular(25))
                  : BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                      bottomRight: Radius.circular(25))),
          child: Text(
            message,
            style: mediumTextFieldStyle(),
          )),
    );
  }
}


// // import 'dart:html';

// // import 'dart:convert';

// import 'package:chatapp/helper/constant.dart';
// // import 'package:chatapp/modal/user.dart';
// import 'package:chatapp/services/database.dart';
// // import 'package:chatapp/views/chatroomScreen.dart';
// import 'package:chatapp/widget/widget.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// // import 'package:http/http.dart';

// class ConversationScreen extends StatefulWidget {
//   final String chatRoomId;
//   ConversationScreen(this.chatRoomId);

//   @override
//   _ConversationScreenState createState() => _ConversationScreenState();
// }

// class _ConversationScreenState extends State<ConversationScreen> {
//   TextEditingController messageTextEditingController =
//       new TextEditingController();
//   DatabaseMethods databaseMethods = new DatabaseMethods();

//   QuerySnapshot snapshot;
//   Stream chatStream;
//   CollectionReference chatroom =
//       FirebaseFirestore.instance.collection('chatRoom');

//   Widget chatMessageList() {
//     //return StreamBuilder<QuerySnapshot>(
//     return StreamBuilder(
//       stream: FirebaseFirestore.instance
//           .collection("chatRoom")
//           .doc(widget.chatRoomId)
//           .collection("chats")
//           // .where("message",  isEqualTo:message)
//           .orderBy('time')
//           .orderBy("asc")

//           //    .get();
//           .snapshots(),
//       //FirebaseFirestore.instance.collection('chatRoom').snapshots(),
//       builder: (context, AsyncSnapshot snapshot) {
//         return snapshot.hasData
//             ? ListView.builder(
//                 itemCount: snapshot.data.docs.length,
//                 shrinkWrap: true,
//                 itemBuilder: (context, index) {
//                   DocumentSnapshot ds = snapshot.data.docs[index];
//                   print(" HEY!! I am ds[message] : " + ds["message"]);
//                   return Text(
//                       //To read a collection or document once, call the Query.get or DocumentReference.get methods.
//                       // snapshot.data.doc[index].get("message"),
//                       // userSearchEmail: searchsnapshot.docs[index].get("email"),

//                       // ds.toString(),
//                       ds["message"]
//                       //  messageTextEditingController.text
//                       );
//                 },
//               )
//             : Container(
//                 child: Center(
//                   child: CircularProgressIndicator(),
//                 ),
//               );
//       },
//     );
//   }

//   sendMessage() {
//     if (messageTextEditingController.text.isNotEmpty) {
//       Map<String, String> messageMap = {
//         "message": messageTextEditingController.text,
//         "sendBy": Constants.myName,
//       };
//       print(".........controller " + messageTextEditingController.text);

//       databaseMethods.addConversationMessage(widget.chatRoomId, messageMap);
//       print(" From messageMap  $messageMap");
//       messageTextEditingController.text = "";
//     }
//   }

//   getAndSetMessage() async {
//     chatStream =
//         await databaseMethods.getConversationMessage(widget.chatRoomId);
//     print(" Hi this getandsetmessage() function starting. ");
//     print("This is chatroom id: " + widget.chatRoomId);

//     setState(() {
//       print("Value of chatstream $chatStream");
//       print(snapshot);
//     });
//   }

//   // dothisOnLaunch() {
//   //   getAndSetMessage();
//   //   print("I am getmsg " + getAndSetMessage());
//   // }

//   void initState() {
//     super.initState();
//     // sendMessage();
//     //dothisOnLaunch();
//     getAndSetMessage();
//   }

//   @override
//   Widget build(BuildContext buildContext) {
//     return Scaffold(
//       appBar: appBarMain(context),
//       body: Container(
//           child: Stack(
//         children: [
//           chatMessageList(),
//           Container(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               color: Color(0x54FFFFFF),
//               padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: messageTextEditingController,
//                       style: TextStyle(color: Colors.white),
//                       decoration: InputDecoration(
//                         hintText: "tpye a message......",
//                         hintStyle: TextStyle(color: Colors.white54),
//                         border: InputBorder.none,
//                       ),
//                     ),
//                   ),
//                   //Container for icon sizing
//                   GestureDetector(
//                     onTap: () {
//                       sendMessage();
//                     },
//                     child: Container(
//                       padding: EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             const Color(0x36FFFFFF),
//                             const Color(0x0FFFFFF),
//                           ],
//                         ),
//                         borderRadius: BorderRadius.circular(40),
//                       ),
//                       child: Icon(
//                         Icons.send_outlined,
//                         color: Colors.white,
//                         size: 22,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       )),
//     );
//   }
// }

// class MessageTile extends StatefulWidget {
//   final String message;
//   MessageTile(this.message);

//   @override
//   _MessageTileState createState() => _MessageTileState();
// }

// class _MessageTileState extends State<MessageTile> {
//   String a = 'Hey';

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.amber,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(5),
//       ),
//       child: Text(widget.message, style: mediumTextFieldStyle()),
//     );
//     // ignore: dead_code
//   }
// }
