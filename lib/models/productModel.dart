class ProductModel {
  String id;
  String name;
  String price;
  String description;
  String categoryName;
  String categoryId;
  List<String> imgPaths;
  int quaintity;

  ProductModel(
      {this.id,
      this.name,
      this.categoryId,
      this.categoryName,
      this.description,
      this.imgPaths,
      this.price});

  ProductModel.fromJson({String id,Map<String,dynamic> json}){
    this.id=id;
    this.name=json['name'];
    this.categoryId=json['categoryID'];
    this.categoryName=json['categoryName'];
    this.description=json['description'];
    List s=json['imgPaths'];
    this.imgPaths=[];
    s.forEach((element) { 
      this.imgPaths.add(element.toString());
    });
//    this.imgPaths=json['imgPaths'];
    this.price=json['price'];

    this.quaintity=json['quantity']??null;
    
  }

  toMap()=>{
    "name":this.name,
    "categoryID":this.categoryId,
    "categoryName":this.categoryName,
    "description":this.description,
    "imgPaths":this.imgPaths,
    "price":this.price
  };
}
