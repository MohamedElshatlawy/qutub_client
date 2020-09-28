import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qutub_clinet/API/CommonCollections.dart';
import 'package:qutub_clinet/Providers/userProvider.dart';
import 'package:qutub_clinet/models/orderModel.dart';

import 'Order/orderListItem.dart';

class OrderTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection(MyCollections.orders)
          .where('userID', isEqualTo: userProvider.userModel.userToken)
          .orderBy('timeStamp',
          descending: true
          )
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
                    child: Text('لا يوجد طلبات'),
                  )
                : ListView.separated(
                  
                  separatorBuilder: (ctx,index)=>SizedBox(height: 10,),
                    itemCount: snapSHot.data.documents.length,
                    itemBuilder: (ctx, index) {
                      OrderModel model=OrderModel.fromjson(
                        id: snapSHot.data.documents[index].documentID,
                        json: snapSHot.data.documents[index].data
                      );
                      return OrderListItem(
                        index: snapSHot.data.documents.length-index,
                        orderModel: model,
                      );
                    },
                  );
        }
        return Container();
      },
    );
  }
}
