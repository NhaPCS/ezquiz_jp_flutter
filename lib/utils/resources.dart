import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ezquiz_flutter/screens/login.dart';
import 'package:ezquiz_flutter/model/test.dart';
import 'package:ezquiz_flutter/data/service.dart';
import 'package:ezquiz_flutter/data/response.dart';
import 'package:ezquiz_flutter/screens/testing.dart';
import 'package:ezquiz_flutter/list_item/new_test_list.dart';

class SizeUtil {
  static const EdgeInsets defaultMargin = EdgeInsets.all(20);
  static const EdgeInsets bigMargin = EdgeInsets.all(40);
  static const EdgeInsets defaultPadding = EdgeInsets.all(15);
  static const EdgeInsets smallPadding = EdgeInsets.all(8);
  static const EdgeInsets tinyPadding = EdgeInsets.all(5);

  static const double avatarSize = 90;
  static const double avatarSizeBig = 150;
  static const double avatarSizeSmall = 40;
  static const double iconSize = 32;
  static const double iconSizeTiny = 13;

  static const double textSizeDefault = 18;
  static const double textSizeSmall = 13;
  static const double textSizeTiny = 10;
  static const double textSizeBig = 35;
  static const double textSizeHuge = 50;
  static const double textSizeSuperHuge = 70;

  static const double elevationDefault = 3;
  static const double elevationBig = 6;

  static const double spaceDefault = 10;
  static const double defaultRadius = 20;
  static const double bigRadius = 30;
  static const double smallRadius = 10;
  static const double spaceBig = 20;
  static const double spaceHuge = 35;
  static const double spaceSmall = 5;

  static const double lineSize = 1;
}

class Constant {
  static const String ADS_REWARD_ID_IOS = "ca-app-pub-9000513260892268/3210837108";
  static const String ADS_REWARD_ID_ANDROID = "ca-app-pub-9000513260892268/8052766522";
  static const String ADS_APP_ID_IOS = "ca-app-pub-9000513260892268~3215416978";
  static const String ADS_APP_ID_ANDROID = "ca-app-pub-9000513260892268~5481777220";
}

class WidgetUtil {
  static Icon getIcon(BuildContext context, IconData icon) {
    return Icon(
      icon,
      color: Theme.of(context).primaryColor,
    );
  }

  static Widget getCircleImage(double size, String url) {
    return new Container(
        width: size,
        height: size,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
                fit: BoxFit.cover,
                image: new CachedNetworkImageProvider(url))));
  }

  static Widget getCircleImageWithMargin(double size, String url, double marg) {
    return new Container(
        margin: EdgeInsets.all(marg),
        width: size,
        height: size,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
                fit: BoxFit.fill, image: new CachedNetworkImageProvider(url))));
  }

  static Widget getRoundedButton(
      BuildContext context, String text, VoidCallback callback) {
    return RaisedButton(
      onPressed: callback,
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      color: Theme.of(context).primaryColor,
    );
  }

  static Widget getRoundedButtonWhite(
      BuildContext context, String text, VoidCallback callback) {
    return RaisedButton(
      onPressed: callback,
      child: Text(
        text,
        style: TextStyle(
            color: ColorUtil.primaryColor, fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      color: Colors.white,
    );
  }

  static List<Shadow> getTextShadow() {
    List<Shadow> rs = List();
    rs.add(Shadow(
      offset: Offset(4.0, 4.0),
      blurRadius: 5.0,
      color: Color.fromARGB(100, 0, 0, 0),
    ));
    return rs;
  }

  static Widget getPrimaryIcon(BuildContext context, IconData icon) {
    return Icon(
      icon,
      color: Theme.of(context).primaryColor,
      size: SizeUtil.iconSize,
    );
  }

  static Widget getPrimaryIconWithColor(
      BuildContext context, IconData icon, Color color) {
    return Icon(
      icon,
      color: color,
      size: SizeUtil.iconSize,
    );
  }

  static showMessageDialog(BuildContext context, String title, String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              title,
              style: TextStyle(
                  color: ColorUtil.primaryColor, fontWeight: FontWeight.bold),
            ),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(
                        color: ColorUtil.primaryColor,
                        fontWeight: FontWeight.bold),
                  ))
            ],
          );
        });
  }

  static showErrorDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Notice",
              style:
                  TextStyle(color: ColorUtil.red, fontWeight: FontWeight.bold),
            ),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(
                        color: ColorUtil.red, fontWeight: FontWeight.bold),
                  ))
            ],
          );
        });
  }

  static showLoading(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            child: CircularProgressIndicator(),
          );
        });
  }

  static showAlertDialog(BuildContext context, String title, String message,
      String positive, VoidCallback positiveClick) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              title,
              style: TextStyle(
                  color: ColorUtil.primaryColor, fontWeight: FontWeight.bold),
            ),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                  onPressed: positiveClick,
                  child: Text(
                    positive,
                    style: TextStyle(
                        color: ColorUtil.primaryColor,
                        fontWeight: FontWeight.bold),
                  ))
            ],
          );
        });
  }

  static showBuyTestDialog(ListTest listTest, BuildContext context,
      TestModel test, VoidCallback onBuyCallback) {
    showDialog(
        context: context,
        builder: (BuildContext contextBuilder) {
          return AlertDialog(
            title: Text(
              test.testName,
              style: TextStyle(
                  color: ColorUtil.primaryColor, fontWeight: FontWeight.bold),
            ),
            content: Text(
                "Do you want to buy ${test.testName} by ${test.coin} coins?"),
            actions: <Widget>[
              FlatButton(
                  onPressed: onBuyCallback,
                  child: Text(
                    "Yes",
                    style: TextStyle(
                        color: ColorUtil.primaryColor,
                        fontWeight: FontWeight.bold),
                  ))
            ],
          );
        });
  }

  static showLoginDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Login Request"),
            content: Text("Please login to continue."),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Text("Login"))
            ],
          );
        });
  }
}

class ColorUtil {
  static const Color background = Color(0xFFF4F4F4);
  static const Color lineColor = Color(0xFFE2E2E2);
  static const Color hintColor = Color(0xFFDBDBDB);
  static const Color primaryColor = Color(0xFF015C04);
  static const Color primaryColorDark = Color(0xFF014504);
  static const Color red = Color(0xFFa71022);
  static const Color textGray = Color(0xFF949494);
  static const Color textColor = Color(0xFF383838);
}

class StringUtil {
  static const String appName = "EzQuiz - Japanese";
  static const String appSlogan =
      "A place to make students and teachers closer. \nLet's discover together!";
  static const String hintEmail = "Enter your email";
  static const String hintPassword = "Enter your password";
  static const String hintConfirmPassword = "Confirm your password";
  static const String signIn = "Sign in";
  static const String signUp = "Sign up";
  static const String signInByGoogle = "Sign in by Google";
  static const String notHaveAccSignIn = "Not have account? Sign up now!";
  static const String copyRight = "Copy right 2017, ezquiz.com";
}
