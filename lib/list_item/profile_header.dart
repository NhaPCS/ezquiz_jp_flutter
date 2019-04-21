import 'package:ezquiz_flutter/bloc/bloc.dart';
import 'package:ezquiz_flutter/screens/login.dart';
import 'package:ezquiz_flutter/screens/profile.dart';
import 'package:ezquiz_flutter/utils/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ezquiz_flutter/model/user.dart';

class ProfileHeader extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileHeaderState();
  }
}

class _ProfileHeaderState extends State<ProfileHeader> {
  final GetProfileBloc getProfileBloc = GetProfileBloc();

  @override
  void initState() {
    super.initState();
    getProfileBloc.dispatch(new GetProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: getProfileBloc,
      child: BlocBuilder(
          bloc: getProfileBloc,
          builder: (context, User user) {
            print("AAA ${user.email}");
            if (user.email != null) {
              return GestureDetector(
                child: Container(
                  padding: SizeUtil.defaultMargin,
                  color: Theme.of(context).primaryColor,
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        "icons/logo.png",
                        width: SizeUtil.avatarSize,
                        height: SizeUtil.avatarSize,
                      ),
                      Container(
                        width: SizeUtil.spaceBig,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              user.display_name == null
                                  ? user.email
                                  : user.display_name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Container(
                              height: SizeUtil.spaceDefault,
                            ),
                            Text(
                              "${user.coin} coin",
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
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
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(SizeUtil.smallRadius)),
                    color: ColorUtil.primaryColorDark,
                  ));
            }
          }),
    );
  }
}
