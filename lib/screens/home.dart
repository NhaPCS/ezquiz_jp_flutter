import 'package:ezquiz_flutter/list/new_test_list.dart';
import 'package:ezquiz_flutter/model/category.dart';
import 'package:ezquiz_flutter/utils/resources.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen> {
  List<Menu> _listMenu;
  List<Category> _listCategories;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _listMenu = getMenus();
    _listCategories = getCategories();
    return DefaultTabController(
      length: _listCategories.length,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: getAppBar(),
        drawer: getDrawer(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorUtil.primaryColor,
          onPressed: onFilterClick,
          child: Icon(Icons.filter_list),
        ),
        body: TabBarView(
            children: _listCategories.map<Widget>((Category _category) {
          return ListTest();
        }).toList()),
      ),
    );
  }

  void getListTest(String category) {}

  void onFilterClick() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      _scaffoldKey.currentState.showBottomSheet((BuildContext context) {
        return new SizedBox(
          width: double.infinity,
          child: Container(
            padding: Size.defaultPaddig,
            child: Wrap(
              spacing: Size.spaceDefault,
              children: <Widget>[
                WidgetUtil.getRoundedButton(context, "Most test rating", () {}),
                WidgetUtil.getRoundedButton(context, "Free", () {}),
                WidgetUtil.getRoundedButton(context, "Has fee", () {}),
                WidgetUtil.getRoundedButton(
                    context, "Best testing time", () {}),
                WidgetUtil.getRoundedButton(context, "Clear filter", () {}),
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
                padding: Size.smallPadding,
                color: Theme.of(context).primaryColorDark,
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.search,
                      color: Colors.white.withAlpha(60),
                    ),
                    Text(
                      "Enter the keyword...",
                      style: TextStyle(
                          color: Colors.white.withAlpha(60),
                          fontSize: Size.textSizeDefault),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: Size.textSizeDefault,
            ),
            getSubjectPopupWidget()
          ],
        ),
        bottom: TabBar(
            isScrollable: true,
            tabs: _listCategories.map<Tab>((Category _category) {
              return Tab(
                text: _category.title,
              );
            }).toList()));
  }

  PopupMenuButton getSubjectPopupWidget() {
    return new PopupMenuButton(
        child: Text(
          "Subject",
          style: TextStyle(fontSize: Size.textSizeDefault),
        ),
        itemBuilder: (_) => <PopupMenuItem<String>>[
              new PopupMenuItem<String>(
                  child: const Text('Doge'), value: 'Doge'),
              new PopupMenuItem<String>(
                  child: const Text('Lion'), value: 'Lion'),
            ],
        onSelected: (_) {});
  }

  Drawer getDrawer() {
    return Drawer(
      child: ListView.builder(
        itemCount: _listMenu.length,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Container(
              padding: Size.defaultPaddig,
              color: Theme.of(context).primaryColor,
              child: Row(
                children: <Widget>[
//                  WidgetUtil.getCircleImage(Size.avatarSize,
//                      "https://images.pexels.com/photos/638700/pexels-photo-638700.jpeg"),
                  Text(
                    "Nha Nha Nha \n \n 100pt",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            );
          } else {
            Menu menu = _listMenu[index - 1];
            return getMenuItem(menu);
          }
        },
      ),
    );
  }

  Widget getMenuItem(Menu menu) {
    return ListTile(
      leading: menu.icon,
      title: Text(
        menu.title,
        style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: Size.textSizeDefault),
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
    menus.add(Menu(WidgetUtil.getIcon(context, Icons.star), "Following"));
    menus.add(Menu(WidgetUtil.getIcon(context, Icons.chat), "Chat"));
    menus.add(
        Menu(WidgetUtil.getIcon(context, Icons.cloud_upload), "Create test"));
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

  List<Category> getCategories() {
    List<Category> list = List();
    list.add(new Category("New"));
    list.add(new Category("Animals"));
    list.add(new Category("Chapter 1"));
    list.add(new Category("Chapter 2"));
    list.add(new Category("For good one"));
    list.add(new Category("Saved"));
    list.add(new Category("Done"));
    return list;
  }

  @override
  bool get wantKeepAlive => true;

}

class Menu {
  Icon icon;
  String title;

  Menu(this.icon, this.title);
}
