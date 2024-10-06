import 'package:flutter/material.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/ticket_data.dart';
import 'package:kermesse_frontend/services/ticket_service.dart';
import 'package:kermesse_frontend/widgets/screen.dart';


class OrganizerDetailsTicketKermesseScreen extends StatefulWidget {
  final int ticketId;

  const OrganizerDetailsTicketKermesseScreen({
    super.key,
    required this.ticketId,
  });

  @override
  State<OrganizerDetailsTicketKermesseScreen> createState() => _OrganizerDetailsTicketKermesseScreenState();
}

class _OrganizerDetailsTicketKermesseScreenState extends State<OrganizerDetailsTicketKermesseScreen> {
  final Key _key = UniqueKey();

  final TicketService _ticketService = TicketService();

  Future<TicketDetailsResponse> _get() async {
    ApiResponse<TicketDetailsResponse> response = await _ticketService.details(ticketId: widget.ticketId);
    if (response.error != null) {
      throw Exception(response.error);
    }
    return response.data!;
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Ticket Details",
          ),
          FutureBuilder<TicketDetailsResponse>(
            key: _key,
            future: _get(),
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
                  ),
                );
              }
              if (snapshot.hasData) {
                TicketDetailsResponse ticket = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ticket.id.toString()),
                    Text(ticket.isWinner ? 'Winner' : 'Loser'),
                    Text(ticket.user.name),
                    Text(ticket.tombola.name),
                  ],
                );
              }
              return const Center(
                child: Text('Something went wrong'),
              );
            },
          ),
        ],
      ),
    );
  }
}
