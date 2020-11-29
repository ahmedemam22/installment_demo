import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AllInstallmentsProvider extends ChangeNotifier{
  QuerySnapshot _items;
  get items=>_items;
  Stream<QuerySnapshot> get_installments(){
   FirebaseFirestore.instance
        .collection("sellSomeThing")
        .snapshots()
        .listen((result) {
          _items=result;
          notifyListeners();
          return result;

    });
  }
}