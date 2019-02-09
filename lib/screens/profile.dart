import 'package:flutter/material.dart';
import 'package:ezquiz_flutter/utils/resources.dart';
import 'package:ezquiz_flutter/model/user.dart';
import 'package:ezquiz_flutter/data/shared_value.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<ProfileScreen> {
  User _user;
  TextEditingController _displayNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _levelController = TextEditingController();

  @override
  void initState() {
    ShareValueProvider.shareValueProvider.getUserProfile().then((User user) {
      setState(() {
        _user = user;
        if (_user != null) {
          _displayNameController.text = _user.display_name;
          _emailController.text = _user.email;
          _levelController.text = _user.level_id.toUpperCase();
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: GestureDetector(
            child: WidgetUtil.getPrimaryIconWithColor(
                context, Icons.close, Colors.white),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            "Profile",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Container(
            color: ColorUtil.primaryColor,
            child: SingleChildScrollView(
              padding: SizeUtil.defaultMargin,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "icons/logo.png",
                    width: SizeUtil.avatarSizeBig,
                    height: SizeUtil.avatarSizeBig,
                  ),
                  Container(
                    height: SizeUtil.spaceBig,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.monetization_on, color: Colors.orange),
                      Container(
                        width: SizeUtil.spaceDefault,
                      ),
                      Text(
                        "${_user == null ? "0" : _user.coin} coins",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.orange, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Container(
                    height: SizeUtil.spaceDefault,
                  ),
                  Text(
                    "Please choose your level now! We will automatically filter all tests that availabe for you!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontSize: SizeUtil.textSizeSmall),
                  ),
                  Container(
                    height: SizeUtil.spaceBig,
                  ),
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(SizeUtil.smallRadius),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: SizeUtil.spaceBig),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text("Display name"),
                              Expanded(
                                child: TextField(
                                  controller: _displayNameController,
                                  textAlign: TextAlign.end,
                                  decoration: InputDecoration(
                                    contentPadding: SizeUtil.defaultMargin,
                                    border: InputBorder.none,
                                  ),
                                  style:
                                      TextStyle(color: ColorUtil.primaryColor),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text("Email"),
                              Expanded(
                                child: TextField(
                                  controller: _emailController,
                                  textAlign: TextAlign.end,
                                  decoration: InputDecoration(
                                    contentPadding: SizeUtil.defaultMargin,
                                    border: InputBorder.none,
                                  ),
                                  style:
                                      TextStyle(color: ColorUtil.primaryColor),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text("Birthday"),
                              Expanded(
                                child: TextField(
                                  textAlign: TextAlign.end,
                                  decoration: InputDecoration(
                                    contentPadding: SizeUtil.defaultMargin,
                                    border: InputBorder.none,
                                  ),
                                  style:
                                      TextStyle(color: ColorUtil.primaryColor),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text("Level"),
                              Expanded(
                                child: TextField(
                                  controller: _levelController,
                                  textAlign: TextAlign.end,
                                  decoration: InputDecoration(
                                    contentPadding: SizeUtil.defaultMargin,
                                    border: InputBorder.none,
                                  ),
                                  style:
                                      TextStyle(color: ColorUtil.primaryColor),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text("Something about me"),
                              Expanded(
                                child: TextField(
                                  textAlign: TextAlign.end,
                                  decoration: InputDecoration(
                                    contentPadding: SizeUtil.defaultMargin,
                                    border: InputBorder.none,
                                  ),
                                  style:
                                      TextStyle(color: ColorUtil.primaryColor),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: SizeUtil.defaultMargin,
                    child:
                        WidgetUtil.getRoundedButtonWhite(context, "Done", () {
                      Navigator.of(context).pop();
                    }),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
