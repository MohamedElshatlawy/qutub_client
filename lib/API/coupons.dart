import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qutub_clinet/models/couponModel.dart';

import 'CommonCollections.dart';

Future<void> insertNewCoupon({CouponModel couponModel}) async {
  
  return await Firestore.instance
      .collection(MyCollections.coupon)
      .document()
      .setData(couponModel.toMap());
}

Future<void> removeCoupon(CouponModel couponModel) async {
  return await Firestore.instance
      .collection(MyCollections.coupon)
      .document(couponModel.id)
      .delete();
}