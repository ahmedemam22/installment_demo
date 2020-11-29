import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AllInstallmentsProvider extends ChangeNotifier{
  List<QueryDocumentSnapshot> _items;
  List<QueryDocumentSnapshot> _search_items=[];
  List<QueryDocumentSnapshot> get items=>_items;
  List<QueryDocumentSnapshot> get search_items=>_search_items;

 /* get_installments() {
    _items= FirebaseFirestore.instance.collection('sellSomeThing')
        .snapshots()
        .map((snapShot) => snapShot.docs

        .toList());
    notifyListeners();
  }*/
  set_items(value){
    _items=value;
    print(_items.length);
    notifyListeners();
  }
  set_search_items(String title){
    _search_items=_items.where((element) => element['deviceName'].toString().contains(title)).toList();
    notifyListeners();

  }
  clear_search(){
    _search_items=[];
    notifyListeners();
  }
}