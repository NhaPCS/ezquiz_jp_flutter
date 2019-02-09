import 'package:ezquiz_flutter/screens/home.dart';
import 'package:ezquiz_flutter/model/category.dart';

abstract class HomeViewModel {
  Stream<List<Menu>> _listMenu;
  Stream<List<Category>> _listCategories;
}

class HomeViewModelImpl extends HomeViewModel {
  @override
  Stream<List<Menu>> get _listMenu => super._listMenu;
}
