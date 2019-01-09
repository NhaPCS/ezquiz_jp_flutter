import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SizeUtil {
  static const EdgeInsets defaultMargin = EdgeInsets.all(20);
  static const EdgeInsets defaultPaddig = EdgeInsets.all(15);
  static const EdgeInsets smallPadding = EdgeInsets.all(8);
  static const EdgeInsets tinyPadding = EdgeInsets.all(5);

  static const double avatarSize = 90;
  static const double avatarSizeSmall = 40;
  static const double iconSize = 32;
  static const double iconSizeTiny = 13;

  static const double textSizeDefault = 18;
  static const double textSizeSmall = 13;
  static const double textSizeBig = 35;
  static const double textSizeHuge = 50;

  static const double elevationDefault = 3;
  static const double elevationBig = 6;

  static const double spaceDefault = 10;
  static const double defaultRadius = 20;
  static const double smallRadius = 10;
  static const double spaceBig = 20;

  static const double lineSize = 1;
}

class Constant {}

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
                fit: BoxFit.cover, image: new CachedNetworkImageProvider(url))));
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
}

class ColorUtil {
  static const Color background = Color(0xFFF4F4F4);
  static const Color hintColor = Color(0xFFDBDBDB);
  static const Color primaryColor = Color(0xFF015C04);
  static const Color primaryColorDark = Color(0xFF014504);
  static const Color red = Color(0xFFa71022);
  static const Color textGray = Color(0xFF949494);
}

class StringUtil {
  static const String appName = "EzQuiz - Japanese";
  static const String appSlogan =
      "A place to make students and teachers closer. \nLet's discover together!";
  static const String hintEmail = "Enter your email";
  static const String hintPassword = "Enter your password";
  static const String hintConfirmPassword = "Confirm your password";
  static const String signIn = "Sign in";
  static const String signInByGoogle = "Sign in by Google";
  static const String notHaveAccSignIn = "Not have account? Sign up now!";
  static const String copyRight = "Copy right 2017, ezquiz.com";
}
