import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:qutub_clinet/API/CommonCollections.dart';

class CartCounterProvider extends ChangeNotifier {
  int count = 0;

  CartCounterProvider() {
    getCount();
  }

  getCount() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      print('''object''');
      await Firestore.instance
          .collection(MyCollections.userCollection)
          .document(user.uid)
          .collection(MyCollections.cart)
          .getDocuments()
          .then((value) {
        count = value.documents.length;
        print('Value:${value.documents.length}');
        print(count);
         notifyListeners();
      });
     
    }
  }

  setCount(){
    count++;
    notifyListeners();
  }

  decrementCount(){
    count--;
    notifyListeners();
  }

  clearCartCounter(){
    count=0;
    notifyListeners();
  }
}
