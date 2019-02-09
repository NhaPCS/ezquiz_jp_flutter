import 'package:ezquiz_flutter/data/database.dart';
import 'package:ezquiz_flutter/data/service.dart';
import 'package:ezquiz_flutter/data/shared_value.dart';
import 'package:ezquiz_flutter/list_item/new_test_list.dart';
import 'package:ezquiz_flutter/list_item/profile_header.dart';
import 'package:ezquiz_flutter/model/category.dart';
import 'package:ezquiz_flutter/screens/history.dart';
import 'package:ezquiz_flutter/screens/payment.dart';
import 'package:ezquiz_flutter/screens/profile.dart';
import 'package:ezquiz_flutter/utils/resources.dart';
import 'package:flutter/material.dart';
import 'package:ezquiz_flutter/screens/search.dart';

enum FilterType { most_rate, free, hasFee, most_done, none }

class HomeScreen extends StatefulWidget {
  final List<Category> _listCategories;

  HomeScreen(this._listCategories);

  @override
  State<StatefulWidget> createState() {
    return _HomeState(_listCategories);
  }
}

class _HomeState extends State<HomeScreen>
    with TickerProviderStateMixin<HomeScreen> {
  List<Menu> _listMenu;
  List<Category> _listCategories;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TabController _tabController;
  List<String> _levels = List();
  String _selectedLevel;
  FilterType _filterType = FilterType.none;

  _HomeState(this._listCategories);

  @override
  void initState() {
    ShareValueProvider.shareValueProvider.getCurrentLevel().then((level) {
      setState(() {
        _selectedLevel = level.toLowerCase();
      });
    });
    DBProvider.db.getLevels().then((List<String> levels) {
      setState(() {
        _levels = levels;
        print("Level $_levels");
      });
    });
    super.initState();
    _tabController = new TabController(
        vsync: this, length: _listCategories.length, initialIndex: 0);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _listMenu = getMenus();
    return Scaffold(
      key: _scaffoldKey,
      appBar: getAppBar(),
      drawer: getDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorUtil.primaryColor,
        onPressed: onFilterClick,
        child: Icon(Icons.filter_list),
      ),
      body: TabBarView(
          controller: _tabController,
          children: _listCategories.map<Widget>((Category _category) {
            return ListTest(
              category: _category,
              filterType: _filterType,
            );
          }).toList()),
    );
  }

  void onFilterClick() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      _scaffoldKey.currentState.showBottomSheet((BuildContext context) {
        return new SizedBox(
          width: double.infinity,
          child: Container(
            color: ColorUtil.primaryColor,
            padding: EdgeInsets.only(
                left: SizeUtil.spaceDefault,
                right: SizeUtil.spaceDefault,
                top: SizeUtil.spaceBig,
                bottom: SizeUtil.spaceBig),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              spacing: SizeUtil.spaceDefault,
              children: <Widget>[
                WidgetUtil.getRoundedButtonWhite(context, "Most rating count",
                    () {
                  Navigator.pop(context);
                  setState(() {
                    _filterType = FilterType.most_rate;
                  });
                }),
                WidgetUtil.getRoundedButtonWhite(context, "Free", () {
                  Navigator.pop(context);
                  setState(() {
                    _filterType = FilterType.free;
                  });
                }),
                WidgetUtil.getRoundedButtonWhite(context, "Has fee", () {
                  Navigator.pop(context);
                  setState(() {
                    _filterType = FilterType.hasFee;
                  });
                }),
                WidgetUtil.getRoundedButtonWhite(context, "Most done count",
                    () {
                  Navigator.pop(context);
                  setState(() {
                    _filterType = FilterType.most_done;
                  });
                }),
                WidgetUtil.getRoundedButtonWhite(context, "Clear filter", () {
                  Navigator.pop(context);
                  setState(() {
                    _filterType = FilterType.none;
                  });
                }),
              ],
            ),
          ),
        );
      });
    }
  }

  AppBar getAppBar() {
    return AppBar(
        title: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: SizeUtil.smallPadding,
                color: Theme.of(context).primaryColorDark,
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.search,
                      color: Colors.white.withAlpha(60),
                    ),
                    Expanded(
                      child: GestureDetector(
                        child: Text(
                          "Enter anything you want to find...",
                          style: TextStyle(
                              color: Colors.white.withAlpha(60),
                              fontSize: SizeUtil.textSizeDefault),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchScreen()));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: SizeUtil.textSizeDefault,
            ),
            getSubjectPopupWidget()
          ],
        ),
        bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            isScrollable: true,
            tabs: _listCategories.map<Tab>((Category _category) {
              return Tab(
                text: _category.title,
              );
            }).toList()));
  }

  PopupMenuButton getSubjectPopupWidget() {
    return new PopupMenuButton<String>(
        child: Text(
          _selectedLevel == null ? "" : _selectedLevel.toUpperCase(),
          style: TextStyle(
              fontSize: SizeUtil.textSizeDefault, fontWeight: FontWeight.bold),
        ),
        itemBuilder: (BuildContext context) {
          return _levels.map((String level) {
            return PopupMenuItem<String>(
              child: Text(
                level.toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              value: level,
            );
          }).toList();
        },
        onSelected: (String value) {
          ShareValueProvider.shareValueProvider.saveCurrentLevel(value);
          setState(() {
            _selectedLevel = value;
            changeLevel(context, _selectedLevel);
          });
        });
  }

  Drawer getDrawer() {
    return Drawer(
      child: ListView.builder(
        itemCount: _listMenu.length,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return ProfileHeader();
          } else {
            Menu menu = _listMenu[index - 1];
            return getMenuItem(menu, index);
          }
        },
      ),
    );
  }

  Widget getMenuItem(Menu menu, int index) {
    return ListTile(
      onTap: () {
        switch (index) {
          case 1:
            break;
          case 2:
            Navigator.of(context).pop();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HistoryScreen()));
            break;
          case 3:
            Navigator.of(context).pop();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfileScreen()));
            break;
          case 4:
            Navigator.of(context).pop();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PaymentScreen()));
            break;
          case 6:
          case 7:
            break;
          case 4:
            Navigator.of(context).pop();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PaymentScreen()));
            break;
          case 4:
            Navigator.of(context).pop();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PaymentScreen()));
            break;
        }
      },
      leading: menu.icon,
      title: Text(
        menu.title,
        style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: SizeUtil.textSizeDefault),
      ),
    );
  }

  List<Menu> getMenus() {
    List<Menu> menus = List();
    menus.add(Menu(WidgetUtil.getIcon(context, Icons.home), " Home"));
    menus.add(Menu(WidgetUtil.getIcon(context, Icons.history), "History"));
    menus.add(Menu(WidgetUtil.getIcon(context, Icons.person), " Profile"));
    menus
        .add(Menu(WidgetUtil.getIcon(context, Icons.attach_money), " Getcoin"));
    menus.add(Menu(null, "Other"));
    menus.add(
        Menu(WidgetUtil.getIcon(context, Icons.rate_review), "Rate this app"));
    menus.add(Menu(WidgetUtil.getIcon(context, Icons.cloud_download),
        "Update new version"));
    menus.add(Menu(WidgetUtil.getIcon(context, Icons.share), "Share"));
    menus.add(Menu(WidgetUtil.getIcon(context, Icons.email), "Send feedback"));
    menus.add(
        Menu(WidgetUtil.getIcon(context, Icons.assignment), "Term and policy"));
    menus.add(Menu(WidgetUtil.getIcon(context, Icons.call_missed), "Logout"));
    return menus;
  }
}

class Menu {
  Icon icon;
  String title;

  Menu(this.icon, this.title);
}
