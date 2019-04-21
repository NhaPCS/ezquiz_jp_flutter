import 'package:bloc/bloc.dart';
import 'package:ezquiz_flutter/model/test.dart';
import 'package:ezquiz_flutter/enum/filter_type.dart';
import 'package:ezquiz_flutter/data/database.dart';

class FilterTestBloc extends Bloc<FilterTestEvent, List<TestModel>> {
  @override
  List<TestModel> get initialState => List();

  @override
  Stream<List<TestModel>> mapEventToState(
      List<TestModel> currentState, FilterTestEvent event) async* {
    switch (event.filterType) {
      case FilterType.most_rate:
        yield await DBProvider.db.getMostVoteTest(event.categoryId);
        break;
      case FilterType.free:
        yield await DBProvider.db.getFreeTest(event.categoryId);
        break;
      case FilterType.hasFee:
        yield await DBProvider.db.getHasFreeTest(event.categoryId);
        break;
      case FilterType.most_done:
        yield await DBProvider.db.getMostDoneTest(event.categoryId);
        break;
      case FilterType.none:
      default:
        yield await DBProvider.db.getTestByCate(event.categoryId);
        break;
    }
  }
}

class FilterTestEvent {
  final FilterType filterType;
  final String categoryId;

  FilterTestEvent(this.filterType, this.categoryId);
}
