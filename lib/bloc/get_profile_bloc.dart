import 'package:bloc/bloc.dart';
import 'package:ezquiz_flutter/model/user.dart';
import 'package:ezquiz_flutter/data/service.dart';
import 'package:ezquiz_flutter/data/shared_value.dart';

class GetProfileBloc extends Bloc<GetProfileEvent, User> {
  @override
  User get initialState => User();

  @override
  Stream<User> mapEventToState(
      User currentState, GetProfileEvent event) async* {
    User user = await ShareValueProvider.shareValueProvider.getUserProfile();
    if (user == null) {
      user = await getUserProfile();
      ShareValueProvider.shareValueProvider.saveUserProfile(user);
    }
    yield user;
  }
}

class GetProfileEvent {
  GetProfileEvent();
}
