import 'package:flutter/material.dart';
import 'package:loja_virtual/tabs/home_tab.dart';
import 'package:loja_virtual/tabs/orders_tab.dart';
import 'package:loja_virtual/tabs/places_tab.dart';
import 'package:loja_virtual/tabs/products_tab.dart';
import 'package:loja_virtual/widgets/cart_button.dart';
import 'package:loja_virtual/widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Scaffold(
          body: const HomeTab(),
          drawer: CustomDrawer(pageController: _pageController),
          floatingActionButton: const CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text('Produtos'),
            centerTitle: true,
          ),
          floatingActionButton: const CartButton(),
          drawer: CustomDrawer(pageController: _pageController),
          body: const ProductsTab(),
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text("Lojas"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(pageController: _pageController),
          body: const PlacesTab(),
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text('Meus Pedidos'),
            centerTitle: true,
          ),
          drawer: CustomDrawer(pageController: _pageController),
          body: const OrdersTab(),
        )
      ],
    );
  }
}
