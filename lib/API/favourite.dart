

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qutub_clinet/models/productModel.dart';

import 'CommonCollections.dart';

Future<void> addProductToFavourite(ProductModel productModel) async {
  
  //getUserID
  FirebaseUser user;
  user = await FirebaseAuth.instance.currentUser();
  String id = user.uid;



  //insert favourote
  await Firestore.instance
      .collection(MyCollections.userCollection)
      .document(id)
      .collection(MyCollections.favourite)
      .document(productModel.id)
      .setData(productModel.toMap());
  return true;

}

Future<void>removeProductFavourite(ProductModel model) async {
 FirebaseUser user = await FirebaseAuth.instance.currentUser();
  String id = user.uid;
  
  await Firestore.instance
      .collection(MyCollections.userCollection)
      .document(id)
      .collection(MyCollections.favourite)
      .document(model.id).delete();

}

Future<dynamic> foundProductFavourite(String productID) async {
  bool founded=false;
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  String id = user.uid;
  
  await Firestore.instance
      .collection(MyCollections.userCollection)
      .document(id)
      .collection(MyCollections.favourite)
      .getDocuments().then((value) => value.documents.forEach((element) { 

        if(productID==element.documentID){
          founded=true;
        }
      }));

      return founded;
}