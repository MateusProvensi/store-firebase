import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceTile extends StatelessWidget {
  final DocumentSnapshot snapshot;

  const PlaceTile({Key? key, required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 8.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 100,
            child: Image.network(
              (snapshot.data() as Map<String, dynamic>)['image'],
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (snapshot.data() as Map<String, dynamic>)['title'],
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  (snapshot.data() as Map<String, dynamic>)['address'],
                  textAlign: TextAlign.start,
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  launchUrl(
                    Uri.parse(
                      'https://www.google.com/maps/search/?api=1&query=${(snapshot.data() as Map<String, dynamic>)['lat']},${(snapshot.data() as Map<String, dynamic>)['long']}',
                    ),
                  );
                },
                child: const Text(
                  'Ver no Mapa',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              TextButton(
                onPressed: () {
                  launchUrl(
                    Uri.parse(
                      'tel:${(snapshot.data() as Map<String, dynamic>)['phone']}',
                    ),
                  );
                },
                child: const Text(
                  'Ligar',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
