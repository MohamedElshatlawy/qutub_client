import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:qutub_clinet/API/CommonCollections.dart';
import 'package:qutub_clinet/Providers/cartItemsCounterProvider.dart';
import 'package:qutub_clinet/models/addressModel.dart';
import 'package:qutub_clinet/models/couponModel.dart';
import 'package:qutub_clinet/models/extralVatModel.dart';
import 'package:qutub_clinet/models/orderModel.dart';
import 'package:qutub_clinet/models/productModel.dart';
import 'package:qutub_clinet/FCM/fcmConfig.dart';

Future<dynamic> addProductToCart(
    ProductModel productModel, int quantity, var ctx) async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();

  //CheckIf product is exists
  bool founded = false;
  await Firestore.instance
      .collection(MyCollections.userCollection)
      .document(user.uid)
      .collection(MyCollections.cart)
      .getDocuments()
      .then((value) => value.documents.forEach((doc) {
            if (doc.documentID == productModel.id) {
              founded = true;

              int quantity1 = doc.data['quantity'];
              quantity1 += quantity;
              doc.reference.updateData({'quantity': quantity1});
            }
          }));

//InsertNewProduct

  if (founded == false) {
    Map<String, dynamic> data = {};
    data.addAll(productModel.toMap());
    data['quantity'] = quantity;
    await Firestore.instance
        .collection(MyCollections.userCollection)
        .document(user.uid)
        .collection(MyCollections.cart)
        .document(productModel.id)
        .setData(data);
    return true;
  }
}

Future<void> decrementProductCart({String productID}) async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();

  await Firestore.instance
      .collection(MyCollections.userCollection)
      .document(user.uid)
      .collection(MyCollections.cart)
      .getDocuments()
      .then((value) => value.documents.forEach((doc) {
            if (doc.documentID == productID) {
              int quantity = doc.data['quantity'];
              quantity--;
              doc.reference.updateData({'quantity': quantity});
            }
          }));
}

Future<dynamic> deleteProductFromCart(String productID, var ctx) async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();

  await Firestore.instance
      .collection(MyCollections.userCollection)
      .document(user.uid)
      .collection(MyCollections.cart)
      .getDocuments()
      .then((value) => value.documents.forEach((doc) {
            if (doc.documentID == productID) {
              doc.reference.delete();
            }
          }));
  var cartCountProvider = Provider.of<CartCounterProvider>(ctx, listen: false);
  cartCountProvider.decrementCount();
}

Future<dynamic> getDefaultAddress() async {
  AddressModel addressModel;

  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  await Firestore.instance
      .collection(MyCollections.userCollection)
      .document(user.uid)
      .collection(MyCollections.address)
      .getDocuments()
      .then((value) {
    value.documents.forEach((element) {
      if (element.data['enabled'] == true) {
        addressModel =
            AddressModel.fromJson(id: element.documentID, json: element.data);
      }
    });
  });

  return addressModel;
}

Future<dynamic> getCartProducts() async {
  List<ProductModel> products = [];
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  await Firestore.instance
      .collection(MyCollections.userCollection)
      .document(user.uid)
      .collection(MyCollections.cart)
      .getDocuments()
      .then((value) => value.documents.forEach((element) {
            products.add(ProductModel.fromJson(
                id: element.documentID, json: element.data));
          }));
  return products;
}

Future<dynamic> getExtraVat() async {
  ExtraVatModel vatModel;
  await Firestore.instance
      .collection(MyCollections.extraVat)
      .getDocuments()
      .then((value) => value.documents.forEach((element) {
            vatModel =
                ExtraVatModel(id: element.documentID, txt: element.data['vat']);
          }));

  return vatModel;
}

Future<dynamic> checkPromoCode({String code}) async {
  bool founded = false;
  CouponModel couponModel;
  await Firestore.instance
      .collection(MyCollections.coupon)
      .getDocuments()
      .then((value) => value.documents.forEach((doc) {
            if (doc.data['coupon'] == code) {
              founded = true;
              couponModel = CouponModel(
                  id: doc.documentID,
                  coupon: doc.data['coupon'],
                  description: doc.data['description'],
                  discountValue: doc.data['discountValue']);
            }
          }));

  if (founded == true) {
    return couponModel;
  }
  return false;
}

Future<dynamic> sendOrder(OrderModel orderModel) async {
  await Firestore.instance
      .collection(MyCollections.orders)
      .document()
      .setData(orderModel.toMap());
      
sendDashboardNotification();
      
}

Future<dynamic> clearCart(var ctx) async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  await Firestore.instance
      .collection(MyCollections.userCollection)
      .document(user.uid)
      .collection(MyCollections.cart)
      .getDocuments()
      .then((value) => value.documents.forEach((element) {
            element.reference.delete();
          }));
  var cartCountProvider = Provider.of<CartCounterProvider>(ctx, listen: false);
  cartCountProvider.clearCartCounter();
}
