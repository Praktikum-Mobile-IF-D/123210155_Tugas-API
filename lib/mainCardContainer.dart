import 'package:flutter/material.dart';

class MainCardContainer extends StatelessWidget {
  final String id;
  String logoUrl;
  final String name;
  final int total;
  String symbolUrl;

  MainCardContainer({
    required this.id,
    required this.logoUrl,
    required this.name,
    required this.total,
    required this.symbolUrl,
  });

  @override
  Widget build(BuildContext context) {
    if (logoUrl.isNotEmpty) {
      // Add PNG extension to logoUrl if missing
      if (!logoUrl.endsWith('.png')) {
        logoUrl += '.png';
      }
    } else {
      logoUrl = 'https://via.placeholder.com/100';
    }

    if (symbolUrl.isNotEmpty) {
      // Add PNG extension to symbolUrl if missing
      if (!symbolUrl.endsWith('.png')) {
        symbolUrl += '.png';
      }
    }

    return Card(
      elevation: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: false, // Hide the ID from view
            child: Text(id),
          ),
          Image.network(
            logoUrl,
            width: 100,
            height: 100,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: $total cards',
                style: TextStyle(fontSize: 16),
              ),
              if (symbolUrl.isNotEmpty)
                Image.network(
                  symbolUrl,
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
