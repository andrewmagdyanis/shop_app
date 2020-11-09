import 'package:redux/redux.dart';

import '../actions/actions.dart';
import '../models/models.dart';

final userInfoReducer = TypedReducer<UserState, dynamic>(_userInfoReducer);

UserState _userInfoReducer(UserState state, dynamic action) {
  if(action is UserInfoUpdate){
    return action.userState;
  }
  if(action is UserInfoDeletion) {
    return state;
  }

  return state;
}