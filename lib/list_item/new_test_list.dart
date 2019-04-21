import 'package:ezquiz_flutter/bloc/bloc.dart';
import 'package:ezquiz_flutter/enum/filter_type.dart';
import 'package:ezquiz_flutter/list_item/test_item.dart';
import 'package:ezquiz_flutter/model/category.dart';
import 'package:ezquiz_flutter/model/test.dart';
import 'package:ezquiz_flutter/utils/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListTest extends StatelessWidget {
  final Category category;
  final FilterType filterType;
  final FilterTestBloc filterTestBloc = FilterTestBloc();

  ListTest({Key key, this.category, this.filterType});

  @override
  Widget build(BuildContext context) {
    filterTestBloc.dispatch(new FilterTestEvent(filterType, category.id));
    return BlocProvider(
      bloc: filterTestBloc,
      child: BlocBuilder(
          bloc: filterTestBloc,
          builder: (context, List<TestModel> listTest) {
            return ListView.builder(
              padding: SizeUtil.tinyPadding,
              itemCount: listTest == null ? 0 : listTest.length,
              itemBuilder: (BuildContext context, int index) {
                return TestItem(
                  testModel: listTest[index],
                );
              },
            );
          }),
    );
  }
}
