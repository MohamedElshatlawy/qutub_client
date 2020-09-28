import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qutub_clinet/API/CommonCollections.dart';
import 'package:qutub_clinet/models/categoryModel.dart';

import 'Category/customHomeCategoriesItem.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     return StreamBuilder<QuerySnapshot>(
        stream:
      Firestore.instance.collection(MyCollections.categories).snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> snapSHot) {
    if (snapSHot.hasError) return new Text('خطأ: ${snapSHot.error}');
    switch (snapSHot.connectionState) {
      case ConnectionState.waiting:
        return Center(
          child: CircularProgressIndicator(),
        );

      case ConnectionState.none:
        return Center(
          child: Text('لايوجد اتصال بالأنترنت'),
        );
      case ConnectionState.active:

      case ConnectionState.done:
        return (snapSHot.data.documents.isEmpty)
            ? Center(
                child: Text('لا يوجد أقسام'),
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8),
                itemCount: snapSHot.data.documents.length,
                itemBuilder: (ctx, index) {
                
                  CategoryModel model = CategoryModel(
                      id: snapSHot.data.documents[index].documentID,
                      name: snapSHot.data.documents[index].data['name'],
                      imgPath:
                          snapSHot.data.documents[index].data['imgPath']);
                  return CategoryItem(
                    categoryModel: model,
                  );
                },
              );
    }
    return Container();
        },
      );
 
  }
}
