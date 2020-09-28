import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qutub_clinet/API/CommonCollections.dart';
import 'package:qutub_clinet/models/addressModel.dart';

Future<dynamic> insertNewAddress(AddressModel model) async {
  //getUserID
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  String id = user.uid;

  //disable allAddresses
  await Firestore.instance
      .collection(MyCollections.userCollection)
      .document(id)
      .collection(MyCollections.address)
      .getDocuments()
      .then((value) {
    value.documents.forEach((element) {
      element.reference.updateData({'enabled': false});
    });
  });

  //insert newAddress
  await Firestore.instance
      .collection(MyCollections.userCollection)
      .document(id)
      .collection(MyCollections.address)
      .document()
      .setData(model.toMap());
  return true;
}

Future<void> setDefaulsAddress(String addID) async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  String id = user.uid;
  //disable allAddresses
  await Firestore.instance
      .collection(MyCollections.userCollection)
      .document(id)
      .collection(MyCollections.address)
      .getDocuments()
      .then((value) {
    value.documents.forEach((element) {
      element.reference.updateData(
          {'enabled': (element.documentID == addID) ? true : false});
    });
  });
}


Future<void>removeAddress(String addID) async {
 FirebaseUser user = await FirebaseAuth.instance.currentUser();
  String id = user.uid;
  
  await Firestore.instance
      .collection(MyCollections.userCollection)
      .document(id)
      .collection(MyCollections.address)
      .document(addID).delete();

}