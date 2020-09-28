import 'package:flutter/material.dart';
import 'package:qutub_clinet/common.dart';
import 'package:qutub_clinet/models/orderModel.dart';
import 'package:qutub_clinet/ui/Home/Order/orderDetails.dart';

import '../../colors.dart';

class OrderListItem extends StatelessWidget {
  int index;
  OrderModel orderModel;
  OrderListItem({this.index, this.orderModel});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => OrderDetails(
                      orderModel: orderModel,
                    )));
      },
      child: Container(
         color: MyColor.whiteColor,
        child: Row(
          textDirection: TextDirection.rtl,
          children: <Widget>[
            Expanded(
                child: Container(
              padding: EdgeInsets.all(10),
           
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'طلب رقم # $index',
                    style: TextStyle(color: MyColor.customColor),
                  ),
                  Text(
                    orderModel.address,
                    style: TextStyle(color: MyColor.customColor),
                  )
                ],
              ),
            )),
            Container(
              padding: EdgeInsets.all(5),
              width: MediaQuery.of(context).size.width / 4,
              color: Common.mappingColors[orderModel.orderStatus],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    Common.mappingStatus[orderModel.orderStatus],
                    textAlign: TextAlign.center,
                    style: TextStyle(color: MyColor.whiteColor),
                  ),
                  Divider(
                    color: MyColor.whiteColor,
                    endIndent: 10,
                    indent: 10,
                  ),
                  Text(
                    '${(orderModel.deliveryCost == null) ? orderModel.totalCost : double.parse(orderModel.totalCost) +double.parse(orderModel.deliveryCost)}',
                    style: TextStyle(color: MyColor.whiteColor),
                  ),
                  Text(
                    'ريال',
                    style: TextStyle(color: MyColor.whiteColor),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
