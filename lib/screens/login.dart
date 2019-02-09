import 'package:ezquiz_flutter/screens/signup.dart';
import 'package:ezquiz_flutter/utils/resources.dart';
import 'package:flutter/material.dart';
import 'package:ezquiz_flutter/data/service.dart';
import 'package:ezquiz_flutter/utils/resources.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'dart:convert' show json;
import 'package:firebase_auth/firebase_auth.dart';

import "package:http/http.dart" as http;

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _handleSignIn() async {
    bool isSignIn = await _googleSignIn.isSignedIn();
    if (isSignIn) _googleSignIn.signOut();
    try {
      GoogleSignInAccount acc = await _googleSignIn.signIn();
      print("GOOGLE   ${acc.email}, ${acc.displayName}, ${acc.id}");
      GoogleSignInAuthentication authentication = await acc.authentication;
      FirebaseUser firebaseUser = await FirebaseAuth.instance.signInWithGoogle(
          idToken: authentication.idToken,
          accessToken: authentication.accessToken);
      saveUserIfNeed(firebaseUser.uid, acc.email, acc.displayName);
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Login success! Wellcome ${acc.email}")));
      Navigator.pop(context);
      print("LOGIN success ${firebaseUser.uid}");
    } catch (error) {
      print(error);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _googleSignIn.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: double.infinity,
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("icons/bg_intro.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: SizeUtil.defaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 30,
              ),
              GestureDetector(
                child: Container(
                  padding: SizeUtil.smallPadding,
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    StringUtil.appName,
                    style: TextStyle(
                        fontSize: SizeUtil.textSizeHuge,
                        color: Colors.white,
                        shadows: WidgetUtil.getTextShadow()),
                  ),
                  Container(
                    height: 30,
                  ),
                  Text(
                    StringUtil.appSlogan,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        shadows: WidgetUtil.getTextShadow()),
                  ),
                  Container(
                    height: 80,
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.account_circle),
                        hintText: StringUtil.hintEmail,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: ColorUtil.hintColor),
                        filled: true,
                        contentPadding: SizeUtil.defaultMargin),
                  ),
                  Container(
                    height: SizeUtil.lineSize,
                    color: ColorUtil.background,
                  ),
                  TextField(
                    controller: _passController,
                    obscureText: true,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.vpn_key),
                        hintText: StringUtil.hintEmail,
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        filled: true,
                        hintStyle: TextStyle(color: ColorUtil.hintColor),
                        contentPadding: SizeUtil.defaultMargin),
                  ),
                  Container(
                    height: 10,
                  ),
                  MaterialButton(
                    color: ColorUtil.primaryColor,
                    padding: SizeUtil.defaultPadding,
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        StringUtil.signIn,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onPressed: () {
                      sigIn(_emailController.text, _passController.text)
                          .then((success) {
                        if (success) {
                          Navigator.pop(context);
                        } else {
                          WidgetUtil.showMessageDialog(context, "Error",
                              "Login failed. Please check and try again!");
                        }
                      });
                    },
                  ),
                  Container(
                    height: SizeUtil.spaceSmall,
                  ),
                  MaterialButton(
                    color: ColorUtil.red,
                    padding: SizeUtil.defaultPadding,
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        StringUtil.signInByGoogle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onPressed: () {
                      _handleSignIn();
                    },
                  ),
                  Container(
                    height: 10,
                  ),
                  GestureDetector(
                    child: Text(
                      StringUtil.notHaveAccSignIn,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          shadows: WidgetUtil.getTextShadow(),
                          decoration: TextDecoration.underline),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()));
                    },
                  )
                ],
              ),
              Container(
                height: SizeUtil.spaceBig,
              ),
              SizedBox(
                width: double.infinity,
                child: Text(
                  StringUtil.copyRight,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    shadows: WidgetUtil.getTextShadow(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
