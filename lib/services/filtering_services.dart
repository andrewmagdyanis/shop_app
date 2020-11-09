import 'package:cloud_firestore/cloud_firestore.dart';
import '../reduxElements/models/models.dart';

class FilteringService {
  List list = [];
  List myfilteredList = [];
  String filter = "";
  SearchState searchState = SearchState(filter: '', filteredList: [], list: []);
/*
  FilteringService({
    this.filter,
    this.list,
    this.searchState,
  });

*/
  List filtering({
    filter,
    list,
    searchState,
  }) {
    Type r;
    try {
      r = list[0].runtimeType;
    } catch (e) {
      print(e);
    }
    if (filter != null) {
      if ((filter.isNotEmpty)) {
        List<dynamic> tmpList = new List<dynamic>();
        print('<searchBar> ' + 'type: ' + r.toString());
        if (r.toString() == "DocumentSnapshot") {
          print('<searchBar> ' + r.toString() + ' entered');
          for (int i = 0; i < list.length; i++) {
            DocumentSnapshot d = list[i];
            Map<String, dynamic> m = d.data;
            if ((d.documentID + m.toString()).toLowerCase().contains(filter.toLowerCase())) {
              tmpList.add(list[i]);
            }
          }
        } else if (r.toString() == '_InternalLinkedHashMap<String, dynamic>') {
          print('<searchBar> ' + r.toString() + ' entered');
          for (int i = 0; i < list.length; i++) {
            Map<String, dynamic> m = list[i];
            m.forEach((key, value) {
              if ((key.toString() + value.toString()).contains(filter)) {
                tmpList.add(list[i]);
              }
            });
          }
        } else if (r.toString() == '_InternalLinkedHashMap<String, Map<String, dynamic>>') {
          print('<searchBar> ' + r.toString() + ' entered');
          for (int i = 0; i < list.length; i++) {
            Map<String, dynamic> m = list[i];
            m.forEach((key, value) {
              if ((key.toString() + value.toString()).contains(filter)) {
                tmpList.add(list[i]);
              }
            });
          }
        } else {
          print('some error');
        }
        myfilteredList = tmpList;
        print('myFilteredList length: ' + myfilteredList.length.toString());
        // print('myFilteredList : ' + myfilteredList.toString());

      }

      return myfilteredList;
    }
  }
}
