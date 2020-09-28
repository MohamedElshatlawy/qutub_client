import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qutub_clinet/API/CommonCollections.dart';
import 'package:qutub_clinet/Providers/userProvider.dart';
import 'package:qutub_clinet/models/NotificationModel.dart';
import 'package:qutub_clinet/ui/colors.dart';
import 'package:qutub_clinet/ui/widgets/customNotificationListItem.dart';

class AddNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColor.customColor,
          title: Text('الأشعارات'),
          centerTitle: true,
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 10,
                      right: 10
                    ),
                    child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection(MyCollections.userCollection)
                .document(userProvider.userModel.userToken)
                .collection(MyCollections.notification)
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
                            child: Text('لا يوجد اشعارات'),
                          )
                        : ListView.separated(
                            itemBuilder: (ctx, index) {
                              var model = NotificationModel.fromJson(
                                  snapSHot.data.documents[index].documentID,
                                  snapSHot.data.documents[index].data);
                                  return NotificationListItem(
                                    model: model,
                                  );
                            },
                            separatorBuilder: (ctx, index) => SizedBox(
                                  height: 15,
                                ),
                            itemCount: snapSHot.data.documents.length);
              }
              return Container();
            },
          ),
                
                
                  ),
        ));
  }
}
