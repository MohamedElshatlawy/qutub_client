

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qutub_clinet/models/contactUsModel.dart';

import 'CommonCollections.dart';

Future<void> insertNewContactPhone({String phone}) async {
  
  return await Firestore.instance
      .collection(MyCollections.contactUs)
      .document()
      .setData(ContactPhoneNumberModel(
        phone: phone
      ).toMap());
}

Future<void> removeContactPhone(ContactPhoneNumberModel phoneModel) async {
  return await Firestore.instance
      .collection(MyCollections.contactUs)
      .document(phoneModel.id)
      .delete();
}