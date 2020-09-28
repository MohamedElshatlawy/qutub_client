import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qutub_clinet/API/CommonCollections.dart';
import 'package:qutub_clinet/ui/widgets/customTextField.dart';

import '../colors.dart';

class AddAboutUs extends StatelessWidget {
  var myController = TextEditingController();

  var aboutKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: aboutKey,
      appBar: AppBar(
        backgroundColor: MyColor.customColor,
        title: Text('من نحن'),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          margin: EdgeInsets.all(20),
          child: StreamBuilder(
              stream: Firestore.instance
                  .collection(MyCollections.aboutUs)
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
                    if (snapSHot.data.documents.isNotEmpty)
                      myController.text =
                          snapSHot.data.documents[0].data['aboutus'];
                    return Column(
                      children: <Widget>[
                        CustomTextField(
                          controller: myController,
                          txtLablel: 'اضف وصف',
                          isEdit: false,
                          lineCount: 8,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    );
                }
                return Container();
              }),
        ),
      ),
    );
  }
}
