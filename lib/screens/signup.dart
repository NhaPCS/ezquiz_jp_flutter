import 'package:ezquiz_flutter/utils/resources.dart';
import 'package:flutter/material.dart';
import 'package:ezquiz_flutter/data/service.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUpScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: double.infinity,
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("icons/bg_intro.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            padding: SizeUtil.defaultMargin,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 30,
                ),
                GestureDetector(
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                Container(
                  height: 30,
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
                          hintText: StringUtil.hintPassword,
                          border: InputBorder.none,
                          fillColor: Colors.white,
                          filled: true,
                          hintStyle: TextStyle(color: ColorUtil.hintColor),
                          contentPadding: SizeUtil.defaultMargin),
                    ),
                    Container(
                      height: SizeUtil.lineSize,
                      color: ColorUtil.background,
                    ),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.vpn_key),
                          hintText: StringUtil.hintConfirmPassword,
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
                          StringUtil.signUp,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onPressed: () {
                        createUser(context, _emailController.text,
                                _passController.text)
                            .then((success) {
                          if (success) {
                            Navigator.popUntil(
                                context, ModalRoute.withName("home"));
                          } else {
                            WidgetUtil.showMessageDialog(context, "Error",
                                "Signup failed. Please check and try again!");
                          }
                        });
                      },
                    ),
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
          )),
    );
  }
}
