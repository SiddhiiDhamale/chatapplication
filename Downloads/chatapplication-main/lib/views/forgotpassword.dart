import 'package:chatapp/helper/authenticate.dart';
// import 'package:chatapp/views/signin.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/widget/widget.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool isLoading = false;

  //create object of class auth
  AuthMethod authSigInObj = new AuthMethod();

  final _formKey = GlobalKey<FormState>();
  TextEditingController emailForgotPasswordTextEditingController =
      new TextEditingController();
  TextEditingController passwordForgotPasswordTextEditingController =
      new TextEditingController();

  callForgotPassword() {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;

        authSigInObj.forgotPassword(
          emailForgotPasswordTextEditingController.text,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Authenticate()),
        );
      });
    }
  }

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

                            controller:
                                emailForgotPasswordTextEditingController,
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
                            controller:
                                passwordForgotPasswordTextEditingController,
                            decoration:
                                textFieldInputDecoration("New password"),
                          ),
                        ],
                      ),
                    ),
                    //To create a vertical space use sized Box after password field for displaying forgotpassword? ..
                    SizedBox(height: 14),
                    GestureDetector(
                      onTap: () {
                        callForgotPassword();
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
                          // color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text("Reset Password",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                            )),
                      ),
                    ),

                    SizedBox(height: 8),
                  ],
                ),
              ),
            ),
    );
  }
}
