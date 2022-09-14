import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  final String orderId;

  const OrderTile({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 8,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("orders")
              .doc(orderId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            int status = snapshot.data!['status'];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Código do Pedido: ${snapshot.data!.id}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  _buildProductsText(snapshot.data),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Status do Pedido:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCircle(1, "Preparação", status),
                    Container(height: 1, width: 40, color: Colors.grey[500]),
                    _buildCircle(2, "Transporte", status),
                    Container(height: 1, width: 40, color: Colors.grey[500]),
                    _buildCircle(3, "Entrega", status),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }

  String _buildProductsText(DocumentSnapshot? snapshot) {
    String text = "Descrição:\n";

    for (LinkedHashMap product
        in (snapshot!.data()! as Map<String, dynamic>)['products']) {
      text +=
          "${product['quantity']}x ${product['product']['title']} (R\$ ${product['product']['price'].toStringAsFixed(2)}) \n";
    }

    text +=
        "Total: R\$ ${(snapshot.data()! as Map<String, dynamic>)['totalPrice'].toStringAsFixed(2)}";

    return text;
  }

  Widget _buildCircle(
    int thisStatus,
    String subtitle,
    int status,
  ) {
    late Color backColor;
    late Widget child;

    if (status < thisStatus) {
      backColor = Colors.grey[500]!;
      child = Text(
        thisStatus.toString(),
        style: const TextStyle(color: Colors.white),
      );
    } else if (status == thisStatus) {
      backColor = Colors.blue;
      child = Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              thisStatus.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          )
        ],
      );
    } else if (status > thisStatus) {
      backColor = Colors.green;
      child = const Icon(
        Icons.check,
        color: Colors.white,
      );
    }

    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: backColor,
          child: child,
        ),
        Text(subtitle)
      ],
    );
  }
}
