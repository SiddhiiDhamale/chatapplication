import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUserByUserName(String username) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where("name", isEqualTo: username)
        .get();
  }

  getUserByUserEmail(String useremail) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where("email", isEqualTo: useremail)
        .get();
  }

  //for signin fn

  //Upload the users name and email when they sign up to database i.e firestore,
  uploadUserInfo(
      userMap) //userMap is inbulit fn to Map the data generated during signUp.
  {
    //Using Firebase GUI we manually GOTO the firestore create a collection have n no of documents with field:value.
    //To do the same write a code inorder to automate it by creating a fn accepting name and email while creating the user

    //Create a collection using their inbuilt fn and
    //generate document id (default or sequential) and add the email and name fileds to the document
    FirebaseFirestore.instance.collection('users').add(userMap);
  }

  Future createchatRoom(String chatRoomId, chatRoomMap) async {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  //accept a msg
  //getConversationMessages(String chatRoomId,messageMap)
  Future<void> addConversationMessage(String chatRoomId, messageMap) async {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future getConversationMessage(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        // .where("message", isEqualTo:message)
        .orderBy('time')
        //    .get();
        .snapshots();
  }

// static Stream<List<Message>> getMessages(String idUser) =>
//       FirebaseFirestore.instance.collection("chatRoom")
//         .doc(chatRoomId)
//         .collection("chats")
//         // .where("message", isEqualTo:message)
//         .orderBy('time')
//         //    .get();
//         .snapshots();

}
