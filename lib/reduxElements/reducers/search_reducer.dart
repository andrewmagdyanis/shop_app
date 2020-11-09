import '../actions/actions.dart';
import '../actions/searchList_update.dart';
import '../models/models.dart';
import 'package:redux/redux.dart';

final searchReducer = TypedReducer<SearchState, dynamic>(_searchReducer);

SearchState _searchReducer(SearchState state, dynamic action) {
  if (action is SearchListUpdate) {
    //print(state);
    return  action.searchState;
  }
  return state;
}