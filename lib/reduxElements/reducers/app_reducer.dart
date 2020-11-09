import '../reducers/reducers.dart';
import '../models/models.dart';

import 'darkMode_reducer.dart';

AppState appReducer(AppState state, dynamic action) {
    return AppState(
      modeState: darkModeReducer(state.modeState,action),
      userState: userInfoReducer(state.userState,action),
      searchState:  searchReducer(state.searchState,action),
    );
}