import 'package:flutter/material.dart';
import 'package:qutub_clinet/API/order.dart';
import 'package:qutub_clinet/common.dart';
import 'package:qutub_clinet/models/orderModel.dart';
import 'package:qutub_clinet/models/productModel.dart';
import 'package:qutub_clinet/ui/widgets/customButton.dart';
import 'package:qutub_clinet/ui/widgets/customTextField.dart';

import '../../colors.dart';

class OrderDetails extends StatefulWidget {
  OrderModel orderModel;
  OrderDetails({this.orderModel});
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  List<ProductModel> products = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mappingProducts();
  }

  List<Widget> getProductsWidgets({String type}) {
    List<Widget> productsWidgets = [];

    products.forEach((element) {
      productsWidgets.add(Text(
        (type == "name")
            ? element.name
            : (type == "quantity")
                ? "${element.quaintity}X ${element.price}"
                : (element.quaintity * (int.parse(element.price))).toString(),
        textAlign: TextAlign.right,
        style: TextStyle(color: Colors.grey, fontSize: 14),
      ));
    });
    return productsWidgets;
  }

  void mappingProducts() async {
    widget.orderModel.productsQuantity.forEach((key, v) async {
      await getProductDetails(key).then((value) {
        if (value is ProductModel) {
          value.quaintity = v;
          products.add(value);
          setState(() {});
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل الطلب'),
        centerTitle: true,
        backgroundColor: MyColor.customColor,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'عنوان التوصيل',
                  style: TextStyle(fontSize: 16, color: MyColor.customColor),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: Colors.grey,
                        size: 25,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.orderModel.address,
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              widget.orderModel.phone,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      RaisedButton(
                        onPressed: () {},
                        color:
                            Common.mappingColors[widget.orderModel.orderStatus],
                        textColor: MyColor.whiteColor,
                        child: Text(Common
                            .mappingStatus[widget.orderModel.orderStatus]),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusDirectional.circular(8)),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'تفاصيل الطلب',
                  style: TextStyle(fontSize: 16, color: MyColor.customColor),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          Text(
                            'اسم المنتج',
                            style: TextStyle(
                                fontSize: 16, color: MyColor.customColor),
                          ),
                          ...getProductsWidgets(type: "name")
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Column(
                          children: <Widget>[
                            Text(
                              'الكمية',
                              style: TextStyle(
                                  fontSize: 16, color: MyColor.customColor),
                            ),
                            ...getProductsWidgets(type: "quantity")
                          ],
                        )),
                    /* Expanded(
                        flex: 1,
                        child: Column(
                          children: <Widget>[
                            Text(
                              'سعر القطعة',
                              style: TextStyle(
                                  fontSize: 16, color: MyColor.customColor),
                            ),
                            Text(
                              '20',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 18),
                            ),
                            Text(
                              '20',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 18),
                            )
                          ],
                        )),
                 
                 */
                    Expanded(
                        flex: 1,
                        child: Column(
                          children: <Widget>[
                            Text(
                              'الأجمالي',
                              style: TextStyle(
                                  fontSize: 16, color: MyColor.customColor),
                            ),
                            ...getProductsWidgets(type: "total")
                          ],
                        ))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'ملاحظات',
                  style: TextStyle(fontSize: 16, color: MyColor.customColor),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  (widget.orderModel.notes.isEmpty)
                      ? 'لايوجد ملاحظات'
                      : widget.orderModel.notes,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'طرق الدفع',
                  style: TextStyle(fontSize: 16, color: MyColor.customColor),
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                  child: ListTile(
                    leading: Image.asset(
                      'assets/cash.png',
                      scale: 8,
                    ),
                    title: Text(
                      'كاش',
                      style: TextStyle(color: MyColor.customColor),
                    ),
                    trailing: Icon(
                      Icons.check_circle,
                      color: Colors.green[600],
                      size: 30,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'تكلفة الطلب',
                      style:
                          TextStyle(fontSize: 16, color: MyColor.customColor),
                    ),
                    Text(
                      '${widget.orderModel.total} ريال',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    )
                  ],
                ),
                Text(
                  'يشمل ضريبة القيمة المضافة',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'كوبون الخصم',
                      style:
                          TextStyle(fontSize: 16, color: MyColor.customColor),
                    ),
                    Text(
                      widget.orderModel.coupon ?? 'لايوجد',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
               
                (widget.orderModel.coupon == null)
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'قيمة الخصم',
                            style:
                                TextStyle(fontSize: 16, color: Colors.red[800]),
                          ),
                          Text(
                            '${widget.orderModel.couponValue} ريال',
                            style: TextStyle(color: Colors.red[800], fontSize: 16),
                          )
                        ],
                      ),
               SizedBox(
                  height: 10,
                ),
                (widget.orderModel.orderStatus == Common.reviewStatus &&
                        widget.orderModel.deliveryCost == null)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            ' رسوم التوصيل يتم تحديدها من خلال التاجر',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      )
                    : (widget.orderModel.deliveryCost != null)
                        ? Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    ' رسوم التوصيل',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '${widget.orderModel.deliveryCost} ريال',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.red[800],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'التكلفة الكلية',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: MyColor.customColor),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border:
                                            Border.all(color: Colors.red[800])),
                                    child: Text(
                                      '${double.parse(widget.orderModel.totalCost) +(widget.orderModel.deliveryCost==null?0: double.parse(widget.orderModel.deliveryCost))} ريال',
                                      style: TextStyle(
                                          color: Colors.red[800], fontSize: 16),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          )
                        : Container(),
                SizedBox(
                  height: 10,
                ),
                Divider(),
                SizedBox(
                  height: 20,
                ),

                (widget.orderModel.orderStatus==Common.rejectedStatus)?
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('سبب الغاء الطلب',style: TextStyle(
                      color: Colors.red[800]
                    ),),
                    SizedBox(
                  height: 10,
                ),
                Text('${widget.orderModel.reasonOfReject}',style: TextStyle(
                      color: Colors.grey
                    ),),
                  ],
                ):Container()
                /*(widget.orderModel.deliveryCost != null &&
                        widget.orderModel.orderStatus == Common.acceptedStatus)
                    ? CustomButton(
                        backgroundColor: MyColor.customColor,
                        btnPressed: () {
                          confirmOrder(widget.orderModel.id);

                          Navigator.pop(context);
                        },
                        textColor: MyColor.whiteColor,
                        txt: 'تأكيد',
                      )
                    : Container(),
                SizedBox(
                  height: 20,
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
