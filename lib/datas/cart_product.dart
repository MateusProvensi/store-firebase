import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/datas/product_data.dart';

class CartProduct {
  late String cId;

  late String category;
  late String pId;

  late int quantity;
  String? size;

  ProductData? productData;

  CartProduct();

  CartProduct.fromDocument(DocumentSnapshot document) {
    cId = document.id;
    category = (document.data()! as Map<String, dynamic>)['category'];
    pId = (document.data()! as Map<String, dynamic>)['pid'].toString();
    quantity = (document.data()! as Map<String, dynamic>)['quantity'];
    size = (document.data()! as Map<String, dynamic>)['size'];
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'pid': pId,
      'quantity': quantity,
      'size': size,
      'product': productData!.toResumedMap(),
    };
  }
}
