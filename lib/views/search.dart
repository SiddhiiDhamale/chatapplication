import 'package:chatapp/helper/constant.dart';
// import 'package:chatapp/helper/helperfunction.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/conversation_screen.dart';
import 'package:chatapp/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

//String _myName;

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();

  // getUserInfo() async {
  //   _myName = await HelperFunctions.getUserNameSharedPreference();
  //   setState(() {
  //     print("");
  //   });
  // }

  QuerySnapshot searchsnapshot;
//onTap start searching
  initiateSerach() {
    databaseMethods.getUserByUserName(searchTextEditingController.text).then(
      (val) {
        setState(() {
          //update the searchsnapshot
          //searchsnapshot=initally null
          searchsnapshot = val;
          print(searchsnapshot);
        });
      },
    );
  }

  TextEditingController searchTextEditingController =
      new TextEditingController();

  createchatroomandstartconvo(String userName) {
    //save data sharedPrefrence to store data locally insisde the phone,to access later on.

//Shared Preference to save the data from the cloud store...

    if (userName != Constants.myName) {
      //Pass it to ChatRoomMap
      List<String> users = [userName, Constants.myName];

      //TODO:Understand hoe sharedpref=DONE!! are saved and get and how " chatRoomId "is created..
      //userName ==  is when you search whatever you type!!
      //Constants.myName == Whatever is stored in shared prefrence coming from firestore!!

      //1.]
      String chatRoomId = getChatRoomId(userName, Constants.myName);

      //2.]
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatRoomId": chatRoomId,
      };

      //chatroom is created in firestore  ...
      databaseMethods.createchatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context,
          //TODO : send chatRoomId to conversationScreen()
          MaterialPageRoute(
              builder: (context) => ConversationScreen(chatRoomId)));
    } else {
      print("You Can't Send Message to yourself..");
    }
  }

  Widget searchTile({String userSearchName, String userSearchEmail}) {
    return Container(
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userSearchName,
                style: mediumTextFieldStyle(),
              ),
              Text(
                userSearchEmail,
                style: mediumTextFieldStyle(),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              //Call a function.
              createchatroomandstartconvo(userSearchName);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Text("Message"),
            ),
          ),
        ],
      ),
    );
  }

//Create a Widget for ListView
  Widget searchList() {
    return searchsnapshot != null
        ? ListView.builder(
            itemCount: searchsnapshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return searchTile(
                //To read a collection or document once, call the Query.get or DocumentReference.get methods.
                userSearchName: searchsnapshot.docs[index].get("name"),
                userSearchEmail: searchsnapshot.docs[index].get("email"),
              );
            })
        : Container(
            child: Text(
              "Search For The User By Name ",
              style: mediumTextFieldStyle(),
            ),
          );
  }

  //call constructor for super class.
  @override
  void initState() {
    // getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            //container for search...
            Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchTextEditingController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Serach for users..",
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  //Container for icon sizing
                  GestureDetector(
                    onTap: () {
                      initiateSerach();
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
                        Icons.search_off_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //Display the List...
            searchList(),
          ],
        ),
      ),
    );
  }
}

// class SearchTile extends StatelessWidget {
//   final String userSearchName;
//   final String userSearchEmail;

//   //before declaring the userName and email final create a Contructor.
//   SearchTile({this.userSearchName, this.userSearchEmail});

//   @override
//   Widget build(BuildContext context) {
//    /* return Container(
//       child: Row(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 userSearchName,
//                 style: mediumTextFieldStyle(),
//               ),
//               Text(
//                 userSearchEmail,
//                 style: mediumTextFieldStyle(),
//               ),
//             ],
//           ),
//           Spacer(),
//           GestureDetector(
//             onTap: () {
//               //Call a function.
//               createchatroomandstartconvo();
//             },
//             child: Container(
//               padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//                 borderRadius: BorderRadius.circular(13),
//               ),
//               child: Text("Message"),
//             ),
//           ),
//         ],
//       ),
//     );
//   }*/
// }

//TODO :Understand.what is codeUnitAt()??
getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
