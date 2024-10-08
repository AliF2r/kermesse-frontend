import 'package:flutter/material.dart';
import 'package:kermesse_frontend/providers/auth_provider.dart';
import 'package:kermesse_frontend/providers/auth_user.dart';
import 'package:provider/provider.dart';

class TombolaCard extends StatelessWidget {
  final String title;
  final String prize;
  final String price;
  final String status;
  final bool showDetails;
  final VoidCallback onTap;

  const TombolaCard({
    Key? key,
    required this.title,
    required this.prize,
    required this.price,
    required this.status,
    required this.showDetails,
    required this.onTap,
  }) : super(key: key);

  Icon _getStatusIcon(String status) {
    switch (status) {
      case "STARTED":
        return const Icon(Icons.play_circle_fill, color: Colors.green, size: 38);
      default:
        return const Icon(Icons.stop_circle_outlined, color: Colors.red, size: 38);
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthUser user = Provider.of<AuthProvider>(context, listen: false).user;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: _getStatusIcon(status), // Display icon based on status
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Prize: $prize'),
            Text('Price: $price'),
          ],
        ),
        trailing: showDetails
            ? const Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
          size: 18,
        )
            : null,
        onTap: onTap,
      ),
    );
  }
}
