import '../models/models.dart';

class AppUpdate {//user defined type
  final ModeState modeState;//action payload
  final UserState userState;
  final SearchState searchState;
  AppUpdate({
    this.modeState,
    this.userState,
    this.searchState,

  });

}