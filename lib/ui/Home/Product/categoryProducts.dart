import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qutub_clinet/API/CommonCollections.dart';
import 'package:qutub_clinet/models/categoryModel.dart';
import 'package:qutub_clinet/models/productModel.dart';
import 'package:qutub_clinet/ui/setupGridItemSize.dart';

import '../../colors.dart';
import 'categoryProductsItem.dart';

class CategoryProducts extends StatelessWidget {
  CategoryModel categoryModel;
  CategoryProducts({this.categoryModel});
  @override
  Widget build(BuildContext context) {
    var gridItem=GridItemSize(context,300);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.customColor,
        title: Text(categoryModel.name),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
              child: Container(
            margin: EdgeInsets.all(10),
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection(MyCollections.products)
                  .where('categoryID', isEqualTo: categoryModel.id)
                  .snapshots(),
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
                            child: Text('لا يوجد منتجات'),
                          )
                        : GridView.builder(
                            gridDelegate:
                                new SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                    childAspectRatio: gridItem.aspectRatio),
                            itemCount: snapSHot.data.documents.length,
                            itemBuilder: (ctx, index) {
                              var prodModel = ProductModel.fromJson(
                                  id: snapSHot.data.documents[index].documentID,
                                  json: snapSHot.data.documents[index].data);
                              return CategoryProductItem(
                                productModel: prodModel,
                              );
                            });
                }
                return Container();
              },
            )),
      ),
    );
  }
}
