// import 'dart:html';

import 'package:chatapp/helper/authenticate.dart';
import 'package:chatapp/helper/helperfunction.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/chatroomScreen.dart';
import 'package:chatapp/views/forgotpassword.dart';
// import 'package:chatapp/views/signup.dart';
import 'package:chatapp/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  _SignInState();
  bool isLoading = false;

  //create object of class auth
  AuthMethod authSigInObj = new AuthMethod();

  //
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final _formKey = GlobalKey<FormState>();
  TextEditingController emailsignInTextEditingController =
      new TextEditingController();
  TextEditingController passwordsignInTextEditingController =
      new TextEditingController();

  //Create QuerySnapShot
  QuerySnapshot snapshotUserInfo;

  signValidateAndUserIn() async {
    if (_formKey.currentState.validate()) {
      //setState(() async {
      isLoading = true;
      final FirebaseAuth _auth = FirebaseAuth.instance;

      // Map<String, String> userInfoMapSignIn = {
      //   "email": emailsignInTextEditingController.text,
      //   "password": passwordsignInTextEditingController.text,
      // };
      HelperFunctions.saveUserEmailSharedPreference(
          emailsignInTextEditingController.text);

      databaseMethods
          .getUserByUserEmail(emailsignInTextEditingController.text)
          .then(
        (val) {
          snapshotUserInfo = val;
          print(snapshotUserInfo);
          HelperFunctions.saveUserNameSharedPreference(
              snapshotUserInfo.docs[10].get("name"));
          print("${snapshotUserInfo.docs[10].get("name")}");
        },
      );

      try {
        // UserCredential userCredential =
        await _auth.signInWithEmailAndPassword(
          email: emailsignInTextEditingController.text,
          password: passwordsignInTextEditingController.text,
        );
        HelperFunctions.saveUserLoggedInSharedPreference(true);

        return Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChatRoom()),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
        // return Text("Email Address Already Exists.");

        return Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Authenticate()),
        );
      }
      // });
    }
  }

//Build UI.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              //Todo-Adjust height
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val)
                                  ? null
                                  : "Please Provide A Valid User Email";
                            },

                            controller: emailsignInTextEditingController,
                            //modularization
                            decoration: textFieldInputDecoration("email"),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            obscureText: true,
                            validator: (val) {
                              return val.length > 6
                                  ? null
                                  : "Please Provide A Password of 6+ characters.";
                            },
                            controller: passwordsignInTextEditingController,
                            decoration: textFieldInputDecoration("password"),
                          ),
                        ],
                      ),
                    ),
                    //To create a vertical space use sized Box after password field for displaying forgotpassword? ..
                    SizedBox(height: 8),

                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPassword()),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text("Forgot Password?",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                            )),
                      ),
                    ),

                    SizedBox(height: 5.1),

                    GestureDetector(
                      onTap: () {
                        signValidateAndUserIn();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text("SignIn",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                            )),
                      ),
                    ),

                    SizedBox(height: 8),

                    GestureDetector(
                      onTap: () {
                        //signValidateAndUserIn();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            const Color(0xff007ef4),
                            const Color(0xff2A75BC)
                          ]),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text("SignInWithGoogle",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                            )),
                      ),
                    ),

                    //SizedBox(height: 8),

                    SizedBox(
                      height: 10,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't Have An Account? ",
                            style: mediumTextFieldStyle()),

                        GestureDetector(
                          onTap: () {
                            widget.toggle();
                            //Land Me to SignUp()//hence toggle is intially true it will become false and display SignUp
                            //In SignUp on calling Authenticate() toggle 'was' false and it will become true and signIn will be called.
                          },
                          child: Container(
                            // children: [
                            child: Text(
                              " Register Now!",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  decoration: TextDecoration.underline),
                            ),
                            //],
                          ),
                        ),

                        //SizedBox for spacing after column ends..
                        SizedBox(height: 68),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
