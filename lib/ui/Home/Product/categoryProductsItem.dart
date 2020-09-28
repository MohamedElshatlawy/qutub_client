import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:qutub_clinet/models/productModel.dart';
import 'package:qutub_clinet/ui/Home/Product/productDetails.dart';
import 'package:qutub_clinet/ui/widgets/customButton.dart';
import 'package:qutub_clinet/ui/widgets/customModalButton.dart';

import '../../colors.dart';


class CategoryProductItem extends StatelessWidget {
  ProductModel productModel;
  CategoryProductItem({this.productModel});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(context,MaterialPageRoute(builder: (ctx)=>ProductDetails(
                productModel
              )));
            },
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(10)),
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Opacity(
                        opacity: .5,
                                              child: Image.network(
                          productModel.imgPaths[0],
                          fit: BoxFit.contain,
                        ),
                      )),
                ],
              ),
            ),
          ),
          Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Text(
                  productModel.name,
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: MyColor.customColor),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('ريال',
                  
                      style: TextStyle(
                        color: Colors.red[800], fontWeight: FontWeight.w600)),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    productModel.price,
                    style: TextStyle(
                        color: Colors.red[800], fontWeight: FontWeight.w600),
                  )
                ],
              )
            ],
          )

          ,SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
           textDirection: TextDirection.ltr,
            children: <Widget>[
            //  Icon(Icons.shopping_cart,color: MyColor.customColor,),
              Container(
                height: 40,
                child: RaisedButton(onPressed: (){
                       showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        builder: (context) => CustomModal(
                         productModel,
                         context
                        )
                    
                     );
                },
                color: MyColor.customColor,
                textColor: MyColor.whiteColor,
                child: Text('اضف الى المشتريات'),
                ),
                
                ),

               /* Icon(Icons.favorite_border,
                color: Colors.grey,
                )*/
            ],
          )
        ],
      ),
    );
  }
}
