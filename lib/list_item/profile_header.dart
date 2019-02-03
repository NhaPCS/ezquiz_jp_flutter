import 'package:flutter/material.dart';
import 'package:ezquiz_flutter/model/user.dart';
import 'package:ezquiz_flutter/data/shared_value.dart';
import 'package:ezquiz_flutter/utils/resources.dart';
import 'package:ezquiz_flutter/screens/login.dart';

class ProfileHeader extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<ProfileHeader> {
  User _user;

  @override
  void initState() {
    ShareValueProvider.shareValueProvider.getUserProfile().then((User user) {
      setState(() {
        _user = user;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_user != null) {
      return Container(
        padding: SizeUtil.defaultMargin,
        color: Theme.of(context).primaryColor,
        child: Row(
          children: <Widget>[
            WidgetUtil.getCircleImage(SizeUtil.avatarSize, _user.avatar_url),
            Container(
              width: SizeUtil.spaceBig,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _user.display_name == null
                        ? _user.email
                        : _user.display_name,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: SizeUtil.spaceDefault,
                  ),
                  Text(
                    "${_user.coin} coin",
                    style: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )
          ],
        ),
      );
    } else {
      return Container(
          padding: EdgeInsets.only(
              left: SizeUtil.spaceHuge,
              right: SizeUtil.spaceHuge,
              top: SizeUtil.spaceBig,
              bottom: SizeUtil.spaceBig),
          color: Theme.of(context).primaryColor,
          child: RaisedButton(
            padding: SizeUtil.defaultPadding,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => LoginScreen()));
            },
            child: Text(
              "Login",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeUtil.smallRadius)),
            color: ColorUtil.primaryColorDark,
          ));
    }
  }
}
