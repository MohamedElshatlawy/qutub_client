import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qutub_clinet/models/aboutUsModel.dart';
import 'CommonCollections.dart';

Future<void> insertNewAboutUs({String aboutTxt}) async {
  await Firestore.instance
      .collection(MyCollections.aboutUs)
      .getDocuments()
      .then((value) {
    value.documents.forEach((element) {
      element.reference.delete();
    });
  });

  return await Firestore.instance
      .collection(MyCollections.aboutUs)
      .document()
      .setData(AboutUsModel(txt: aboutTxt).toMap());
}
