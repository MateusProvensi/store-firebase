import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  late String category;
  late String id;

  late String title;
  late String description;

  late double price;

  late List images;
  late List sizes;

  ProductData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.id;
    title = (snapshot.data()! as Map<String, dynamic>)['title'];
    description = (snapshot.data()! as Map<String, dynamic>)['description'];
    price = (snapshot.data()! as Map<String, dynamic>)['price'] + 0.0;
    images = (snapshot.data()! as Map<String, dynamic>)['images'];
    sizes = (snapshot.data()! as Map<String, dynamic>)['sizes'];
  }

  Map<String, dynamic> toResumedMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
    };
  }
}
