import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:untitled1/Pages/Account/AlreadyHaveanaccount.dart';
import 'package:untitled1/Pages/Account/register.dart';
import 'package:untitled1/Pages/Chat/MyUserList.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:http/http.dart' as http;
import 'package:untitled1/main.dart';
import 'dart:convert';


import '../../Constants.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String email = '', pass = '';
    FocusNode myFocusNode = new FocusNode();
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor:kPrimaryColor,
        body: SingleChildScrollView(
            child:Column(
            children:<Widget>[
            SizedBox(
            height: 200,
             child:Container(
             child: Center(
               child:AnimatedTextKit(
               animatedTexts: [
                 FadeAnimatedText(
                   'Do Talking',
                   textStyle: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold,color: Colors.white),
                 ),
                 ScaleAnimatedText(
                   'Then Scale',
                   textStyle: TextStyle(fontSize: 32.0, fontFamily: 'Canterbury',color: Colors.white),
                 ),
               ],
             )),
            )),
            Center(
            child: Card(
              color: Colors.white,
              child: SizedBox(
                  width: 300,
                  height: 350,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(left: 5, right: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 30, // <-- Your height
                                  //  signInWithGoogle();
                                ),
                                Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: kPrimaryLightColor,
                                          borderRadius: new BorderRadius.circular(30.0),
                                        ),
                                        child: Padding(
                                            padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                                            child: TextFormField(
                                                onChanged: (value) {
                                                  email = value;
                                                },
                                                focusNode: myFocusNode,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  labelText: 'Email',
                                                    hintText: "Enter the Email",
                                                    labelStyle: TextStyle(
                                                        color: myFocusNode.hasFocus ? Colors.blue : kPrimaryColor
                                                    ),
                                                    hintStyle: TextStyle(
                                                      color: myFocusNode.hasFocus ? Colors.blue : Colors.black
                                                    )
                                                ))))),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: kPrimaryLightColor,
                                      borderRadius: new BorderRadius.circular(30.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                                      child: TextField(
                                        onChanged: (value) {
                                          pass = value;
                                        },
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            labelText: 'Password',
                                              hintText: "Enter the password",
                                              labelStyle: TextStyle(
                                                  color: myFocusNode.hasFocus ? Colors.blue : kPrimaryColor
                                              ),
                                              hintStyle: TextStyle(
                                                  color: myFocusNode.hasFocus ? Colors.blue : Colors.black
                                              )
                                          ))))),

                                SizedBox(
                                  height: 10, // <-- Your height
                                  //  signInWithGoogle();
                                ),
                              Hero(
                                tag: "login_btn",
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: kPrimaryColor,
                                        elevation: 0,
                                        minimumSize: const Size(250,40),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        )
                                    ),
                                    onPressed: () async {

                                      try {
                                         await FirebaseAuth
                                            .instance
                                            .signInWithEmailAndPassword(
                                            email: email, password: pass);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const MyUserList()),
                                        );
                                         final FirebaseAuth auth = FirebaseAuth.instance;
                                         await Firebase.initializeApp();
                                         messaging = FirebaseMessaging.instance;
                                         final fcmToken = await messaging.getToken();
                                         print(fcmToken);
                                         final FirebaseAuth auth1 = FirebaseAuth.instance;
                                         final User? user = auth1.currentUser;
                                         final uid = user?.uid;
                                         // DatabaseReference dbReference = FirebaseDatabase.instance.ref()
                                         //     .child('User')
                                         //     .child(uid.toString());
                                         // dbReference.update({
                                         //   "token": fcmToken
                                         // });
                                      } on FirebaseAuthException catch (e) {
                                        if (e.code == 'user-not-found') {
                                          print('No user found for that email.');
                                        } else if (e.code == 'wrong-password') {
                                          print('Wrong password provided for that user.');
                                        }
                                      }
                                    },
                                    child: Text('Login')),
                                )
                              ],
                            ),
                          ),
                        ),

                       SizedBox(
                          height: 20, // <-- Your height
                          //  signInWithGoogle();
                        ),
                        AlreadyHaveAnAccountCheck(
                          login: false,
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return MyRegister();
                                },
                              ),
                            );
                          },
                        ),
                        SizedBox(
                            height: 40, // <-- Your height
                          //  signInWithGoogle();
                           ),

            ]
           ))),
        )])));
  }
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }


}
