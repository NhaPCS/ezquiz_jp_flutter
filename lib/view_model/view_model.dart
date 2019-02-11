import 'package:ezquiz_flutter/screens/home.dart';
import 'package:ezquiz_flutter/model/category.dart';
import 'dart:async';
import 'package:flutter/material.dart';

abstract class HomeViewModel {
  Sink get _listMenu;

  Sink get _listCategories;

  Stream<List<Menu>> _getListMenu;
  Stream<List<Category>> _getListCategories;

  void dispose();
}

class HomeViewModelImpl extends HomeViewModel {
  final StreamController<List<Menu>> _listMenuController =
      StreamController.broadcast();
  final StreamController<List<Category>> _listCategoriesController =
      StreamController.broadcast();

  @override
  // TODO: implement _listCategories
  Sink get _listCategories => _listCategoriesController;

  @override
  // TODO: implement _listMenu
  Sink get _listMenu => _listMenuController;

  @override
  void dispose() {
    _listMenuController.close();
    _listCategoriesController.close();
  }

  @override
  // TODO: implement _getListMenu
  Stream<List<Menu>> get _getListMenu => _listMenuController.stream;

  @override
  // TODO: implement _getListCategories
  Stream<List<Category>> get _getListCategories =>
      _listCategoriesController.stream;
}
