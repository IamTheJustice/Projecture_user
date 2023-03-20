import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserContactProvider extends ChangeNotifier {
  List<QueryDocumentSnapshot<Object?>> _userContact=[];
  List<QueryDocumentSnapshot<Object?>> get userContact => _userContact;
  setUserContactData(List<QueryDocumentSnapshot<Object?>> data) {
    _userContact = data;
    notifyListeners();
  }
}
