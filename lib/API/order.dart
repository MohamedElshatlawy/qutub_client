import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qutub_clinet/API/CommonCollections.dart';
import 'package:qutub_clinet/common.dart';
import 'package:qutub_clinet/models/productModel.dart';

Future<dynamic> getProductDetails(String productID) async {
  ProductModel productModel;
  await Firestore.instance
      .collection(MyCollections.products)
      .document(productID)
      .get()
      .then((value) {
    productModel =
        ProductModel.fromJson(id: value.documentID, json: value.data);
  });

  return productModel;
}

Future<dynamic> confirmOrder(String orderID) async {
  await Firestore.instance
      .collection(MyCollections.orders)
      .document(orderID)
      .updateData({'orderStatus': Common.confirmedStatus});
}
