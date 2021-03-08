import 'package:chatapp/helper/authenticate.dart';
import 'package:chatapp/helper/helperfunction.dart';
import 'package:chatapp/views/chatroomScreen.dart';
// import 'package:chatapp/views/signin.dart';
//import 'package:chatapp/views/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/rendering.dart';

//import 'package:chatapp/views/signin.dart';
//import 'package:chatapp/views/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp();
  MyApp.ensureIntialized();
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  _MyAppState();
  bool userIsLoggedIn;
  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((val) {
      setState(() {
        userIsLoggedIn = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[900],
        primaryColor: Color(0xff145C9E),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: userIsLoggedIn != null
          ? userIsLoggedIn
              ? ChatRoom()
              : Authenticate()
          : Authenticate(),
    );
  }
}
