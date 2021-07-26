import 'package:chatapp/views/signin.dart';
import 'package:chatapp/views/signup.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView);
    } else {
      //this i.e == return signUp(toggleView) will be get passed into the constructor of class SignUp.And the contructor has SignUp(this.toggle);final Function toggle();
      //Since toggleview cant be accessed in signIn and signUp class as it belongs to Authenticate pass it in the constructor of it as a variable with return type as fn
      //passing it in a constructor will help us to create a toggle effect between widgets of signIn() and signUp()
      //what will toggleView do is decide wheather to display signUp or signIn screen onTap RegisterNow!!
      return SignUp(toggleView);
    }
  }

  // SignIn newMethod() => SignIn();
}
