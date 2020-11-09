import '../actions/actions.dart';
import '../models/models.dart';
import 'package:redux/redux.dart';

final darkModeReducer = TypedReducer<ModeState, dynamic>(_darkModeReducer);

ModeState _darkModeReducer(ModeState state, dynamic action) {
  if (action is DarkModeUpdate) {
    return  action.modeState;
  }
  return state;
}