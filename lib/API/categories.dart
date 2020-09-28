import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:qutub_clinet/models/categoryModel.dart';

import 'CommonCollections.dart';

Future<void> insertNewCategory({File img, String categoryName}) async {
  //upload image
  String imageURL = "";
  final StorageReference storageReference = FirebaseStorage.instance
      .ref()
      .child(MyCollections.images)
      .child(basename(img.path));

  await storageReference.putFile(img).onComplete.then((taskSnap) async {
    imageURL = await taskSnap.ref.getDownloadURL();
  });

  //AddNewCategory
  return await Firestore.instance
      .collection(MyCollections.categories)
      .document()
      .setData(CategoryModel(imgPath: imageURL, name: categoryName).toMap());
}

Future<void> updateNewCategory({File img, CategoryModel categoryModel}) async {
  if (categoryModel.imgPath == null) {
//upload image
    String imageURL = "";
    final StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child(MyCollections.images)
        .child(basename(img.path));

    await storageReference.putFile(img).onComplete.then((taskSnap) async {
      imageURL = await taskSnap.ref.getDownloadURL();
    });

    //updateCategoryNewImg
    return await Firestore.instance
        .collection(MyCollections.categories)
        .document(categoryModel.id)
        .updateData(
            CategoryModel(imgPath: imageURL, name: categoryModel.name).toMap());
  }

  //updateCategoryName
  return await Firestore.instance
      .collection(MyCollections.categories)
      .document(categoryModel.id)
      .updateData(CategoryModel(
              imgPath: categoryModel.imgPath, name: categoryModel.name)
          .toMap());
}

Future<void> removeCategory(CategoryModel categoryModel) async {
  await removeProductRelatedToCategory(categoryModel.id);
  
  return await Firestore.instance
      .collection(MyCollections.categories)
      .document(categoryModel.id)
      .delete();
}
Future<void> removeProductRelatedToCategory(String catID) async {
  return await Firestore.instance
      .collection(MyCollections.products)
      .where('categoryID',
      isEqualTo: catID
      ).getDocuments().then((value) => value.documents.forEach((element) async { 

        await element.reference.delete();
      }));
}
Future<List<CategoryModel>> getAllCateogriesFireStore() async {
  List<CategoryModel> cats = [];
  await Firestore.instance
      .collection(MyCollections.categories)
      .getDocuments()
      .then((value) {
    value.documents.forEach((element) {
      cats.add(CategoryModel(
          id: element.documentID,
          imgPath: element.data['imgPath'],
          name: element.data['name']));
    });
  });

  return cats;
}
