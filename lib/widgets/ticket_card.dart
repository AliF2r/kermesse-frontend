import 'package:flutter/material.dart';

class TicketCard extends StatelessWidget {
  final String username;
  final bool isWinner;
  final VoidCallback onTap;

  const TicketCard({
    Key? key,
    required this.username,
    required this.isWinner,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isWinner ? Colors.green.shade100 : Colors.white,
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          isWinner ? Icons.emoji_events : Icons.event_note,
          color: isWinner ? Colors.green : Colors.grey,
          size: 36,
        ),
        title: Text(
          isWinner ? 'Winner!' : 'Not win yet',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isWinner ? Colors.green : Colors.grey,
          ),
        ),
        subtitle: Text('Bought by: ${username}'),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
