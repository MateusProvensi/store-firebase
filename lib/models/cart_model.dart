import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  final UserModel user;

  bool isLoading = false;

  List<CartProduct> products = [];

  String? couponCode;
  int discountPercentage = 0;

  CartModel({required this.user}) {
    if (user.isLoggedIn()) {
      _loadCartItems();
    }
  }

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct) {
    products.add(cartProduct);

    FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.user!.uid)
        .collection('cart')
        .add(cartProduct.toMap())
        .then((doc) => cartProduct.cId = doc.id);

    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct) {
    products.remove(cartProduct);

    FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.user!.uid)
        .collection('cart')
        .doc(cartProduct.cId)
        .delete();

    notifyListeners();
  }

  void decProduct(CartProduct cartProduct) {
    cartProduct.quantity--;

    FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.user!.uid)
        .collection("cart")
        .doc(cartProduct.cId)
        .update(cartProduct.toMap());

    notifyListeners();
  }

  void incProduct(CartProduct cartProduct) {
    cartProduct.quantity++;

    FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.user!.uid)
        .collection("cart")
        .doc(cartProduct.cId)
        .update(cartProduct.toMap());

    notifyListeners();
  }

  void _loadCartItems() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.user!.uid)
        .collection("cart")
        .get();

    products =
        query.docs.map((product) => CartProduct.fromDocument(product)).toList();
  }

  void updatePrices() {
    notifyListeners();
  }

  double getProductsPrice() {
    double price = 0.0;

    for (CartProduct c in products) {
      if (c.productData != null) {
        price += c.quantity * c.productData!.price;
      }
    }

    return price;
  }

  double getDiscount() {
    return getProductsPrice() * discountPercentage / 100;
  }

  double getShipPrice() {
    return 9.99;
  }

  void setCoupon(String? couponCode, int discountPercentage) {
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  Future<String?> finishOrder() async {
    if (products.isEmpty) return null;

    isLoading = true;

    notifyListeners();

    double productsPrice = getProductsPrice();
    double discountPrice = getDiscount();
    double shipPrice = getShipPrice();

    DocumentReference refOrder =
        await FirebaseFirestore.instance.collection("orders").add(
      {
        "clientId": user.firebaseUser!.user!.uid,
        "products": products.map((cartProduct) => cartProduct.toMap()).toList(),
        "shipPrice": shipPrice,
        "productsPrice": productsPrice,
        "discountPrice": discountPrice,
        "totalPrice": (productsPrice + shipPrice - discountPrice),
        "status": 1,
      },
    );

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.user!.uid)
        .collection("orders")
        .doc(refOrder.id)
        .set(
      {
        "orderId": refOrder.id,
      },
    );

    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.user!.uid)
        .collection("cart")
        .get();

    for (DocumentSnapshot doc in query.docs) {
      doc.reference.delete();
    }

    products.clear();
    discountPercentage = 0;
    couponCode = null;
    isLoading = false;

    notifyListeners();

    return refOrder.id;
  }
}
