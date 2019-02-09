import 'package:ezquiz_flutter/list_item/test_item.dart';
import 'package:ezquiz_flutter/model/test.dart';
import 'package:ezquiz_flutter/utils/resources.dart';
import 'package:flutter/material.dart';
import 'package:ezquiz_flutter/data/database.dart';
import 'package:firebase_admob/firebase_admob.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchState();
  }
}

class SearchState extends State<SearchScreen> {
  List<TestModel> _listTest = List();
  InterstitialAd _interstitialAd;

  TextEditingController _keywordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _interstitialAd?.dispose();
    _interstitialAd = createInterstitialAd()..load();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: Constant.ADS_INTERSTITIAL_ID_IOS,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event $event");
        if (event == MobileAdEvent.loaded) {
          _interstitialAd?.show();
        } else if (event == MobileAdEvent.failedToLoad) {
          RewardedVideoAd.instance.show();
        }
      },
    );
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
        title: TextField(
          controller: _keywordController,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
              hintText: "Enter anything you want to find...",
              fillColor: ColorUtil.primaryColor,
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.white.withAlpha(50)),
              filled: true,
              contentPadding: SizeUtil.defaultMargin),
          onSubmitted: (String key) {
            _search(key);
          },
          style: TextStyle(
              color: Colors.white,
              fontSize: SizeUtil.textSizeDefault),
        ),
      ),
      body: ListView.builder(
          itemCount: _listTest == null ? 0 : _listTest.length,
          itemBuilder: (context, index) {
            return TestItem(
              testModel: _listTest[index],
            );
          }),
    );
  }

  _search(String key) {
    if (key != null) {
      print("KEEYYY $key");
      DBProvider.db.searchTest(key.toLowerCase()).then((List<TestModel> list) {
        setState(() {
          _listTest = list;
        });
      });
    }
  }
}
