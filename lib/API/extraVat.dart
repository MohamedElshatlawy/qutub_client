import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qutub_clinet/models/extralVatModel.dart';

import 'CommonCollections.dart';

Future<void> insertNewExtraVat({String aboutTxt}) async {
  await Firestore.instance
      .collection(MyCollections.extraVat)
      .getDocuments()
      .then((value) {
    value.documents.forEach((element) {
      element.reference.delete();
    });
  });

  return await Firestore.instance
      .collection(MyCollections.extraVat)
      .document()
      .setData(ExtraVatModel(txt: aboutTxt).toMap());
}