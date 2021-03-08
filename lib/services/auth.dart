import 'package:chatapp/modal/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';

class AuthMethod {
  AuthMethod();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFireBase(User user) {
    return user != null ? Users(userId: user.uid) : false;
  }

  Future signInMethod(String email, String password) async {
    UserCredential userCredential;
    try {
      userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User fireBaseUser = userCredential.user;
      return _userFromFireBase(fireBaseUser);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }

    return userCredential.user;

    // return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future signUpMethod(String email, String password) async {
    //return _auth.createUserWithEmailAndPassword(email:email,password:password);
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User user = FirebaseAuth.instance.currentUser;

      if (!user.emailVerified) {
        await user.sendEmailVerification();

        return userCredential;
      }

      //  Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => SignIn()),
      //   );
      //  User firebaseuser = userCredential.user;
      //return _userFromFireBase(firebaseuser);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future signOutMethod() async {
    await FirebaseAuth.instance.signOut();
  }

  /* Future signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  // Create a new credential
  final GoogleAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}*/

  Future forgotPassword(String email) async {
    try {
      return _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      // An error happened.
      print(e.toString());
      return null;
    }
  }
}
