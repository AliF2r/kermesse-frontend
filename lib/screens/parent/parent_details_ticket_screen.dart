import 'package:flutter/material.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/ticket_data.dart';
import 'package:kermesse_frontend/services/ticket_service.dart';
import 'package:kermesse_frontend/widgets/global_appBar.dart';
import 'package:kermesse_frontend/widgets/screen.dart';

class ParentDetailsTicketScreen extends StatefulWidget {
  final int ticketId;

  const ParentDetailsTicketScreen({
    super.key,
    required this.ticketId,
  });

  @override
  State<ParentDetailsTicketScreen> createState() => _ParentDetailsTicketScreenState();
}

class _ParentDetailsTicketScreenState extends State<ParentDetailsTicketScreen> {
  final Key _key = UniqueKey();
  final TicketService _ticketService = TicketService();

  Future<TicketDetailsResponse> _getDetails() async {
    ApiResponse<TicketDetailsResponse> response = await _ticketService.details(ticketId: widget.ticketId);
    if (response.error != null) {
      throw Exception(response.error);
    }
    return response.data!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlobalAppBar(title: 'Ticket Details'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<TicketDetailsResponse>(
            key: _key,
            future: _getDetails(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    snapshot.error.toString(),
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }
              if (snapshot.hasData) {
                TicketDetailsResponse ticket = snapshot.data!;
                return _buildTicketDetails(ticket);
              }
              return const Center(
                child: Text('Something went wrong'),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTicketDetails(TicketDetailsResponse ticket) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          color: ticket.isWinner ? Colors.green.shade100 : Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(
                      ticket.isWinner ? Icons.emoji_events : Icons.sentiment_dissatisfied,
                      color: ticket.isWinner ? Colors.green : Colors.red,
                      size: 40,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      ticket.isWinner ? 'Winner!' : 'Not win yet',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: ticket.isWinner ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildDetailRow('Ticket ID:', ticket.id.toString()),
                _buildDetailRow('Bought by:', ticket.user.name),
                _buildDetailRow('Tombola name:', ticket.tombola.name),
                _buildDetailRow('kermesse name:', ticket.kermesse.name),
                _buildDetailRow('Prize:', ticket.tombola.prize),
                _buildDetailRow('Price:', ticket.tombola.price.toString()),
              ]
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
