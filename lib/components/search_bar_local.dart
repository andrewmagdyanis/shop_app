import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../logic/sizes_helpers.dart';
import '../reduxElements/actions/actions.dart';
import '../reduxElements/models/models.dart';
import '../services/filtering_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class SearchBarLocal extends StatefulWidget {
  final List<dynamic> objectList;
  final double height;

  SearchBarLocal({
    this.objectList,
    this.height,
  });

  @override
  _SearchBarLocalState createState() {
    return _SearchBarLocalState();
  }
}

class _SearchBarLocalState extends State<SearchBarLocal> {
  List _list = [];
  List<dynamic> myFilteredList = [];
  bool returnAll = false;

  bool ignoreChangeFlag = false;
  int ignoreChangeCount = 0;
  Icon actionIcon = Icon(Icons.search);
  Widget searchTitle = Expanded(
      child: Text(
    "Search",
    style: TextStyle(fontSize: 20),
  ));
  String filter = "";
  SearchState searchState = SearchState(filter: '', filteredList: [], list: []);
  FilteringService filteringService = FilteringService();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    //print('objectList: ' + widget.objectList.toString());
    //List myList = StoreProvider.of<AppState>(context).state.searchState.list;
    setState(() {
      _list = widget.objectList;
      myFilteredList = _list;
      returnAll = false;
    });
    super.initState();
  }

  void filtering(BuildContext context) {
    Type r;
    try {
      //filter = StoreProvider.of<AppState>(context).state.searchState.filter;
      //_list = StoreProvider.of<AppState>(context).state.searchState.list;
      r = _list[0].runtimeType;
    } catch (e) {
      print(e);
    }
    if (filter != null) {
      if ((filter.isNotEmpty)) {
        List<dynamic> tmpList = new List<dynamic>();
        print('<searchBar> ' + 'type: ' + r.toString());
        if (r.toString() == "DocumentSnapshot") {
          print('<searchBar> ' + r.toString() + ' entered');
          for (int i = 0; i < _list.length; i++) {
            DocumentSnapshot d = _list[i];
            Map<String, dynamic> m = d.data;
            if ((d.documentID + m.toString()).toLowerCase().contains(filter.toLowerCase())) {
              tmpList.add(_list[i]);
            }
          }
        } else if (r.toString() == '_InternalLinkedHashMap<String, dynamic>') {
          print('<searchBar> ' + r.toString() + ' entered');
          for (int i = 0; i < _list.length; i++) {
            Map<String, dynamic> m = _list[i];
            m.forEach((key, value) {
              if ((key.toString() + value.toString()).contains(filter)) {
                tmpList.add(_list[i]);
              }
            });
          }
        } else if (r.toString() == '_InternalLinkedHashMap<String, Map<String, dynamic>>') {
          print('<searchBar> ' + r.toString() + ' entered');
          for (int i = 0; i < _list.length; i++) {
            Map<String, dynamic> m = _list[i];
            m.forEach((key, value) {
              List filterElemnts = filter.split(' ');
              print('filter elements: ' + filterElemnts.toString());
              bool filterFound = true;
              for (int j = 0; j < filterElemnts.length; j++) {
                if (!(key.toString() + value.toString()).contains(filterElemnts[j])) {
                  filterFound = false;
                }
              }
              if (filterFound) {
                tmpList.add(_list[i]);
              }
            });
          }
        } else {
          print('some error');
        }

        myFilteredList = tmpList;

        print('myFilteredList length: ' + myFilteredList.length.toString());
        // print('myFilteredList : ' + myfilteredList.toString());

        SearchState s = StoreProvider.of<AppState>(context).state.searchState;
        StoreProvider.of<AppState>(context)
            .dispatch(SearchListUpdate(searchState: s.copyWith(filteredList: myFilteredList)));
      } else if (returnAll) {
        SearchState s = StoreProvider.of<AppState>(context).state.searchState;
        StoreProvider.of<AppState>(context)
            .dispatch(SearchListUpdate(searchState: SearchState().copyWith(filter: '0')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (ignoreChangeCount <= 50) {
      print('filter ' + ignoreChangeCount.toString());
      filtering(context);
    }
    return Container(
        padding: EdgeInsets.all(5),
        height: widget.height,
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colors.transparent),
        ),
        child: StoreConnector<AppState, SearchState>(
            converter: (Store<AppState> store) => store.state.searchState,
            onDidChange: (newState) {
              print('Did changed');
              filter = newState.filter;
              _list = newState.list;
              myFilteredList = newState.filteredList;
              returnAll = newState.returnAll;
              ignoreChangeCount = 0;
              print(returnAll);
              //SearchState s = StoreProvider.of<AppState>(context).state.searchState;
              StoreProvider.of<AppState>(context).dispatch(SearchListUpdate(
                  searchState: newState.copyWith(
                      filter: filter,
                      list: _list,
                      filteredList: myFilteredList,
                      returnALl: returnAll)));
            },
            rebuildOnChange: true,
            ignoreChange: (appState) {
              // print('check if filter changed?: ' + (appState.searchState.filter == filter)
              //  .toString());
              ignoreChangeFlag = appState.searchState.filter == filter;
              ignoreChangeCount++;
              return appState.searchState.filter == filter;
            },
            builder: (BuildContext context, SearchState searchState) {
              bool darkMode = StoreProvider.of<AppState>(context).state.modeState.enableDarkMode;
              print('search build');
              return Row(
                children: [
                  Spacer(),
                  Flexible(
                    flex: 14,
                    child: Container(
                      decoration: BoxDecoration(
                          color: darkMode ? Colors.grey[800] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(displayHeight(context) * 0.07),
                          border: Border.all(width: 2, color: Colors.greenAccent)),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (this.actionIcon.icon == Icons.search) {
                              this.actionIcon = new Icon(Icons.arrow_back);
                              this.searchTitle = Expanded(
                                child: new TextFormField(
                                  textDirection: TextDirection.rtl,
                                  textInputAction: TextInputAction.go,
                                  onFieldSubmitted: (text) {
                                    ignoreChangeCount = 0;
                                    if (text.isEmpty) {
                                      setState(() {
                                        filter = '';
                                        //myfilteredList = _list;
                                      });
                                      SearchState s =
                                          StoreProvider.of<AppState>(context).state.searchState;
                                      StoreProvider.of<AppState>(context).dispatch(SearchListUpdate(
                                          searchState: s.copyWith(
                                              filter: '',
                                              filteredList: myFilteredList,
                                              list: _list)));
                                    } else {
                                      setState(() {
                                        filter = text;
                                      });
                                      SearchState s =
                                          StoreProvider.of<AppState>(context).state.searchState;
                                      StoreProvider.of<AppState>(context).dispatch(
                                          SearchListUpdate(searchState: s.copyWith(filter: text)));

                                      print('filter: "' + filter + ' "');
                                    }
                                  },
                                  onChanged: (text) {
                                    ignoreChangeCount = 0;

                                    if (text.isEmpty) {
                                      setState(() {
                                        filter = '';
                                        myFilteredList = _list;
                                      });
                                      SearchState s =
                                          StoreProvider.of<AppState>(context).state.searchState;
                                      StoreProvider.of<AppState>(context).dispatch(SearchListUpdate(
                                          searchState: s.copyWith(
                                              filter: '',
                                              filteredList: myFilteredList,
                                              list: _list)));
                                    } else {
                                      setState(() {
                                        filter = text;
                                      });
                                      SearchState s =
                                          StoreProvider.of<AppState>(context).state.searchState;
                                      StoreProvider.of<AppState>(context).dispatch(
                                          SearchListUpdate(searchState: s.copyWith(filter: text)));

                                      print('filter: "' + filter + ' "');
                                    }
                                  },
                                  decoration: new InputDecoration(
                                    prefixIcon: new Icon(
                                      Icons.search,
                                    ),
                                    hintText: "Search...",
                                  ),
                                  autofocus: true,
                                  cursorColor: Colors.blue[800],
                                ),
                              );
                            } else {
                              this.actionIcon = new Icon(Icons.search);
                              this.searchTitle = Expanded(
                                child: new Text(
                                  "Search",
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              );
                              // SearchState s = StoreProvider.of<AppState>(context).state.searchState;
                              //_list = s.list;

                              StoreProvider.of<AppState>(context).dispatch(SearchListUpdate(
                                  searchState: searchState.copyWith(
                                      filter: '', filteredList: _list, list: _list)));
                              setState(() {
                                filter = '';
                                //myfilteredList = _list;
                              });
                              // controller.clear();
                            }
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new IconButton(
                              icon: actionIcon,
                              onPressed: () {
                                setState(() {
                                  if (this.actionIcon.icon == Icons.search) {
                                    this.actionIcon = new Icon(Icons.arrow_back);
                                    this.searchTitle = Expanded(
                                      child: new TextFormField(
                                        textDirection: TextDirection.rtl,
                                        textInputAction: TextInputAction.go,
                                        onFieldSubmitted: (text) {
                                          ignoreChangeCount = 0;
                                          if (text.isEmpty) {
                                            setState(() {
                                              filter = '';
                                              //myfilteredList = _list;
                                            });
                                            SearchState s = StoreProvider.of<AppState>(context)
                                                .state
                                                .searchState;
                                            StoreProvider.of<AppState>(context).dispatch(
                                                SearchListUpdate(
                                                    searchState: s.copyWith(
                                                        filter: '',
                                                        filteredList: myFilteredList,
                                                        list: _list)));
                                          } else {
                                            setState(() {
                                              filter = text;
                                            });
                                            SearchState s = StoreProvider.of<AppState>(context)
                                                .state
                                                .searchState;
                                            StoreProvider.of<AppState>(context).dispatch(
                                                SearchListUpdate(
                                                    searchState: s.copyWith(filter: text)));

                                            print('filter: "' + filter + ' "');
                                          }
                                        },
                                        onChanged: (text) {
                                          print('onChanged entered');
                                          ignoreChangeCount = 0;

                                          if (text.isEmpty) {
                                            setState(() {
                                              filter = '';
                                              myFilteredList = _list;
                                            });
                                            SearchState s = StoreProvider.of<AppState>(context)
                                                .state
                                                .searchState;
                                            StoreProvider.of<AppState>(context).dispatch(
                                                SearchListUpdate(
                                                    searchState: s.copyWith(
                                                        filter: '',
                                                        filteredList: myFilteredList,
                                                        list: _list)));
                                          } else {
                                            setState(() {
                                              filter = text;
                                            });
                                            SearchState s = StoreProvider.of<AppState>(context)
                                                .state
                                                .searchState;
                                            StoreProvider.of<AppState>(context).dispatch(
                                                SearchListUpdate(
                                                    searchState: s.copyWith(filter: text)));

                                            print('filter: "' + filter + ' "');
                                          }
                                        },
                                        decoration: new InputDecoration(
                                          prefixIcon: new Icon(
                                            Icons.search,
                                          ),
                                          hintText: "Search...",
                                        ),
                                        autofocus: true,
                                        cursorColor: Colors.blue[800],
                                      ),
                                    );
                                  } else {
                                    this.actionIcon = new Icon(Icons.search);
                                    this.searchTitle = Expanded(
                                      child: new Text(
                                        "Search",
                                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                                    );
                                    // SearchState s = StoreProvider.of<AppState>(context).state.searchState;
                                    //_list = s.list;
                                    print('List length form searchbar: ' + _list.length.toString());
                                    print('myFilteredList length form searchbar: ' +
                                        myFilteredList.length.toString());
                                    StoreProvider.of<AppState>(context).dispatch(SearchListUpdate(
                                        searchState: searchState.copyWith(
                                            filter: '', filteredList: _list, list: _list)));
                                    setState(() {
                                      filter = '';
                                      //myfilteredList = _list;
                                    });
                                    // controller.clear();
                                  }
                                });
                              },
                            ),
                            searchTitle,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                          color: darkMode ? Colors.grey[800] : Colors.grey[200],
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 2,
                            color: Colors.greenAccent,
                          )),
                      padding: EdgeInsets.all(displayHeight(context) * 0.01),
                      child: Center(
                        child: Text(
                          "${searchState.filteredList.length}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }));
  }
}
