import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qutub_clinet/API/CommonCollections.dart';
import 'package:qutub_clinet/models/contactUsModel.dart';
import 'package:qutub_clinet/ui/widgets/customPhoneContactUs.dart';

import '../colors.dart';

class AddContactUs extends StatelessWidget {
  var addContactKey = GlobalKey<ScaffoldState>();
  var phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: addContactKey,
      appBar: AppBar(
        backgroundColor: MyColor.customColor,
        title: Text('أرقام التواصل'),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: <Widget>[
              Expanded(
                child: StreamBuilder(
                    stream: Firestore.instance
                        .collection(MyCollections.contactUs)
                        .snapshots(),
                    builder: (ctx, AsyncSnapshot<QuerySnapshot> snapSHot) {
                      if (snapSHot.hasError)
                        return new Text('خطأ: ${snapSHot.error}');
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
                                  child: Text('لا يوجد ارقام تواصل'),
                                )
                              : ListView.separated(
                                  itemBuilder: (ctx, index) {
                                    ContactPhoneNumberModel phoneModel =
                                        ContactPhoneNumberModel(
                                            id: snapSHot.data.documents[index]
                                                .documentID,
                                            phone: snapSHot
                                                .data
                                                .documents[index]
                                                .data['phone']);
                                    return CustomPhoneContactUS(
                                      phoneNumber: phoneModel.phone,
                                    );
                                  },
                                  itemCount: snapSHot.data.documents.length,
                                  separatorBuilder: (ctx, index) => SizedBox(
                                    height: 30,
                                  ),
                                );
                      }
                      return Container();
                    }),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
