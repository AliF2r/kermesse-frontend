import 'package:flutter/material.dart';

class StandCard extends StatelessWidget {
  final Icon icon;
  final String title;
  final String subtitle;
  final String description;
  final String price;
  final VoidCallback onTap;

  const StandCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.price,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: icon,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle),
            Text(description),
            Text(price),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
