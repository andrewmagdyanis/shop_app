/*
import 'dart:io';
import 'package:comicer/reduxElements/actions/actions.dart';
import 'package:comicer/reduxElements/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';

class SearchBar extends StatefulWidget {
  final List<dynamic> objectList;

  SearchBar({
    this.objectList,
  });

  @override
  _SearchBarState createState() {
    return _SearchBarState();
  }
}

class _SearchBarState extends State<SearchBar> {
  List<dynamic> _list = [];
  List<dynamic> myfilteredList = [];
  TextEditingController controller = new TextEditingController();
  Icon actionIcon = new Icon(Icons.search);
  Widget searchTitle = new Text(
    "Search",
    style: TextStyle(fontSize: 20),
  );
  String filter = "";

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _list = widget.objectList;
      myfilteredList = _list;
    });
    controller.addListener(() {
      if (controller.text.isEmpty) {
        setState(() {
          filter = '';
          myfilteredList = _list;
          StoreProvider.of<AppState>(context).dispatch(SearchListUpdate(
              searchState: SearchState().copyWith(filter: '', filteredList: myfilteredList)));
        });
      } else {
        setState(() {
          filter = controller.text;
          StoreProvider.of<AppState>(context).dispatch(
              SearchListUpdate(searchState: SearchState().copyWith(filter: controller.text)));
        });
        print('filter: '+filter);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // String f = StoreProvider.of<AppState>(context).state.searchState.filter;
    try {
      filter = StoreProvider.of<AppState>(context).state.searchState.filter;
    } catch (e) {
      print(e);
    }
    if (filter != null) {
      if ((filter.isNotEmpty)) {
        List<dynamic> tmpList = new List<dynamic>();
        for (int i = 0; i < _list.length; i++) {
          Map<String, dynamic> m = _list[i];
          m.forEach((key, value) {
            if ((key.toString() ).contains(filter)) {
              tmpList.add(_list[i]);
            }
          });
        }
        myfilteredList = tmpList;
        //print('myFilteredList length: ' + myfilteredList.length.toString());
        //print('myFilteredList : ' + myfilteredList.toString());

        StoreProvider.of<AppState>(context).dispatch(
            SearchListUpdate(searchState: SearchState().copyWith(filteredList: myfilteredList)));
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Center(
            child: Text(
              "No. of filtered elements is ${myfilteredList.length}",
              style: TextStyle(fontSize: 18,color: Colors.blue[800],fontWeight: FontWeight.bold),
            ),
          ),
        ),
        searchTitle,
        new IconButton(
          icon: actionIcon,
          onPressed: () {
            setState(() {
              if (this.actionIcon.icon == Icons.search) {
                this.actionIcon = new Icon(Icons.close);
                this.searchTitle = Expanded(
                  child: new TextField(
                    controller: controller,
                    decoration: new InputDecoration(
                      prefixIcon: new Icon(
                        Icons.search,
                      ),
                      hintText: "Search...",
                      hintStyle: new TextStyle(color: Colors.black),
                    ),
                    autofocus: true,
                    cursorColor: Colors.blue[800],
                  ),
                );
              } else {
                this.actionIcon = new Icon(Icons.search);
                this.searchTitle = new Text(
                  "Search",
                  style: TextStyle(fontSize: 20,color: Colors.blue[800],
                      fontWeight: FontWeight.bold),

                );

                myfilteredList = _list;
                StoreProvider.of<AppState>(context).dispatch(SearchListUpdate(
                    searchState: SearchState().copyWith(filteredList: myfilteredList)));
                controller.clear();
              }
            });
          },
        ),
      ],
    );
  }
}
*/

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../reduxElements/actions/actions.dart';
import '../reduxElements/models/models.dart';
import '../services/filtering_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:shop_app/reduxElements/actions/searchList_update.dart';
import 'package:shop_app/reduxElements/models/app_state.dart';
import 'package:shop_app/reduxElements/models/search_state.dart';
import 'package:shop_app/services/filtering_services.dart';

class SearchBar extends StatefulWidget {
  List<dynamic> objectList;

  SearchBar({
    this.objectList,
  });

  @override
  _SearchBarState createState() {
    return _SearchBarState();
  }
}

class _SearchBarState extends State<SearchBar> {
  List _list = [];
  List<dynamic> myfilteredList = [];
  bool returnAll = false;

  //TextEditingController controller = new TextEditingController();

  bool ignoreChangeFlag = false;
  int ignoreChangeCount = 0;
  Icon actionIcon =  Icon(Icons.search);
  Widget searchTitle =  Expanded(child:Text(
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
/*
  @override
  void initState() {
    print('objectList: ' + widget.objectList.toString());
    List myList = StoreProvider.of<AppState>(context).state.searchState.list;
    setState(() {
      _list = myList;
      myfilteredList = _list;
      returnAll =false;
    });
    // controller.addListener(() {
    //print('_list'+_list.toString());
    // if (controller.text.isEmpty) {
    //   setState(() {
    //    filter = '';
    //    myfilteredList = _list;
    //    SearchState s = StoreProvider.of<AppState>(context).state.searchState;
    //    StoreProvider.of<AppState>(context).dispatch(SearchListUpdate(
    //       searchState: s.copyWith(filter: '', filteredList: myfilteredList, list: _list)));

    //  });
    //    } else {
    //  setState(() {
    //  filter = controller.text;
    //  SearchState s = StoreProvider.of<AppState>(context).state.searchState;
    //  StoreProvider.of<AppState>(context)
    //      .dispatch(SearchListUpdate(searchState: s.copyWith(filter: controller.text)));

    // });

    // print('filter: ' + filter);
    // }
    // });
    super.initState();
  }


 */

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

        myfilteredList = tmpList;

        print('myFilteredList length: ' + myfilteredList.length.toString());
        // print('myFilteredList : ' + myfilteredList.toString());

        SearchState s = StoreProvider.of<AppState>(context).state.searchState;
        StoreProvider.of<AppState>(context)
            .dispatch(SearchListUpdate(searchState: s.copyWith(filteredList: myfilteredList)));
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
    return StoreConnector<AppState, SearchState>(
        converter: (Store<AppState> store) => store.state.searchState,
        onDidChange: (newState) {
          print('Did changed');
          filter = newState.filter;
          _list = newState.list;
          myfilteredList = newState.filteredList;
          returnAll = newState.returnAll;
          ignoreChangeCount = 0;
          print(returnAll);
          SearchState s = StoreProvider.of<AppState>(context).state.searchState;
          StoreProvider.of<AppState>(context).dispatch(SearchListUpdate(
              searchState: s.copyWith(filter: filter, list: _list,filteredList:  myfilteredList, returnALl:
              returnAll)));
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
          print('search build');
          return InkWell(
            onTap: () {
              /*
              setState(() {
                if (this.actionIcon.icon == Icons.search) {
                  this.actionIcon = new Icon(Icons.close);
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
                                  filter: '', filteredList: myfilteredList, list: _list)));
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
                            myfilteredList = _list;
                          });
                          SearchState s =
                              StoreProvider.of<AppState>(context).state.searchState;
                          StoreProvider.of<AppState>(context).dispatch(SearchListUpdate(
                              searchState: s.copyWith(
                                  filter: '', filteredList: myfilteredList, list: _list)));
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
                }
                else {
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
              */
            },
            child: Row(
              children: [
                Flexible(
                  flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 3, color: Colors.greenAccent)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new IconButton(
                          icon: actionIcon,
                          onPressed: () {
                            setState(() {
                              if (this.actionIcon.icon == Icons.search) {
                                this.actionIcon = new Icon(Icons.close);
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
                                                filter: '', filteredList: myfilteredList, list: _list)));
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
                                      print('onChanged entered');
                                      ignoreChangeCount = 0;

                                      if (text.isEmpty) {
                                        setState(() {
                                          filter = '';
                                          myfilteredList = _list;
                                        });
                                        SearchState s =
                                            StoreProvider.of<AppState>(context).state.searchState;
                                        StoreProvider.of<AppState>(context).dispatch(SearchListUpdate(
                                            searchState: s.copyWith(
                                                filter: '', filteredList: myfilteredList, list: _list)));
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
                              }
                              else {
                                this.actionIcon = new Icon(Icons.search);
                                this.searchTitle = Expanded(
                                  child: new Text(
                                    "Search",
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                );
                                // SearchState s = StoreProvider.of<AppState>(context).state.searchState;
                                //_list = s.list;
                                print('List length form searchbar: '+_list.length.toString());
                                print('myFilteredList length form searchbar: '+myfilteredList.length
                                    .toString());
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
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, border: Border.all(color: Colors.green)),
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        "${searchState.filteredList.length}",
                      ),
                    ),
                  ),
                ),

              ],
            ),
          );
        });
  }
}
