import 'package:flutter/material.dart';
import 'package:ezquiz_flutter/utils/resources.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<ProfileScreen> {
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
            padding: SizeUtil.defaultMargin,
            color: ColorUtil.primaryColor,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  WidgetUtil.getCircleImage(SizeUtil.avatarSizeBig,
                      "https://images.pexels.com/photos/638700/pexels-photo-638700.jpeg"),
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
                        "95 coins",
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
                          left: SizeUtil.spaceBig,
                          right: SizeUtil.spaceBig),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text("Display name"),
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
                              Text("Email"),
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
                    child: WidgetUtil.getRoundedButtonWhite(
                        context, "Done", () {
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
