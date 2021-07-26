// import 'package:chatapp/modal/user.dart';
// import 'package:chatapp/modal/user.dart';
import 'package:chatapp/helper/authenticate.dart';
import 'package:chatapp/helper/helperfunction.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
// import 'package:chatapp/views/chatroomScreen.dart';
import 'package:chatapp/widget/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:chatapp/views/chatroomScreen.dart';
// import 'package:chatapp/views/signin.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //Loading option
  bool isLoading = false;

  //create object of class AuthMethods to access all the functions inside it.
  AuthMethod authMethods = AuthMethod();

  //Object of database class
  DatabaseMethods databaseMethods = new DatabaseMethods();

  //helperfunction

  //AuthMethod newMethod() => new AuthMethod();

  //Creating formkey for form() widget to vaidate all the textformfield inside the form widget
  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController =
      new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  //Function for onTap()
  signMeUp() async {
    //if all textfield are validated then
    if (formKey.currentState.validate()) {
      setState(() async {
        //set isLoading True...Show CircularprogressionIndicator in the body widget by using conditional operator Condition?Ture:False

        // if (isLoading = true)

        //Map The name and email in the userInfoMap Fn in UpdateUserInfo()
        Map<String, String> userInfoMap = {
          "name": userNameTextEditingController.text,
          "email": emailTextEditingController.text,
        };
        databaseMethods.uploadUserInfo(userInfoMap);

        HelperFunctions.saveUserEmailSharedPreference(
            emailTextEditingController.text);
        HelperFunctions.saveUserNameSharedPreference(
            userNameTextEditingController.text);

        //Verify using firebase..
        final FirebaseAuth _auth = FirebaseAuth.instance;

        try {
          // UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
            email: emailTextEditingController.text,
            password: passwordTextEditingController.text,
          );

          User user = FirebaseAuth.instance.currentUser;

          if (!user.emailVerified) {
            await user.sendEmailVerification();
          }

          return Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Authenticate()),
          );
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            print('No user found for that email.');
          } else if (e.code == 'wrong-password') {
            print('Wrong password provided for that user.');
          }
          return Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Authenticate()),
          );
        }
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
            ))
          : Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  //Will Not Consume Whole Vertiacl Space..
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //Form for name email password TextField (input)
                    Form(
                      key: formKey,

                      //Column for textField
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),

                            //To check correct Name is typed.
                            validator: (val) {
                              print(val);
                              return val.isEmpty || val.length < 3
                                  ? "Name Must Be Greater Than 3 Characters."
                                  : null;
                            },

                            controller: userNameTextEditingController,
                            //modularization
                            decoration: textFieldInputDecoration("name"),
                          ),
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
                                  : "Please Provide A Valid User Name";
                            },
                            controller: emailTextEditingController,
                            decoration: textFieldInputDecoration("email"),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),

                            //Hide Password.
                            obscureText: true,
                            validator: (val) {
                              return val.length > 6
                                  ? null
                                  : "Please Provide Password Of 6+ charachters.";
                            },
                            controller: passwordTextEditingController,
                            decoration: textFieldInputDecoration("password"),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    //SignUp button

                    GestureDetector(
                      onTap: () {
                        signMeUp();
                      },
                      child: Container(
                        //Provide width and padding(vertical) alignment to the container
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20),

                        //Decorate the container BoxDecoration
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            const Color(0xff007ef4),
                            const Color(0xff2A75BC)
                          ]),
                          borderRadius: BorderRadius.circular(30),
                        ),

                        //Provide a Text to the Container
                        child: Text("SignUp",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                            )),
                      ),
                    ),

                    //SizedBox For Vertical spacing from top of the given height
                    SizedBox(height: 8),

                    //Button for SignUpWithGoogle using Container
                    GestureDetector(
                      onTap: () {
                        signMeUp();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text("SignUpWithGoogle",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                            )),
                      ),
                    ),

                    SizedBox(
                      height: 12.5,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already Have A Account? ",
                            style: mediumTextFieldStyle()),

                        GestureDetector(
                          onTap: () {
                            widget.toggle();
                          },
                          child: Column(
                            children: [
                              Text(" SignIn Now!",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      decoration: TextDecoration.underline)),
                            ],
                          ),
                        ),

                        //SizedBox for spacing after column ends..
                        SizedBox(height: 50),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
