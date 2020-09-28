import 'package:flutter/material.dart';
import 'package:qutub_clinet/models/categoryModel.dart';
import 'package:qutub_clinet/ui/Home/Product/categoryProducts.dart';

class CategoryItem extends StatelessWidget {
  CategoryModel categoryModel;
  CategoryItem({this.categoryModel});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => CategoryProducts(
                      categoryModel: categoryModel,
                    )));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[600], borderRadius: BorderRadius.circular(10)),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Opacity(
                opacity: .5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    categoryModel.imgPath,
                    fit: BoxFit.cover,
                  ),
                )),
            Align(
              alignment: Alignment.centerLeft,
              child: RotatedBox(
                quarterTurns: -1,
                child: Container(
                  width: 90,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.red[800],
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10))),
                  child: Center(
                    child: Text(
                      categoryModel.name,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
