import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/ticket_data.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/services/ticket_service.dart';
import 'package:kermesse_frontend/widgets/screen_list.dart';

class OrganizerListTicketKermesseScreen extends StatefulWidget {
  const OrganizerListTicketKermesseScreen({super.key});

  @override
  State<OrganizerListTicketKermesseScreen> createState() => _OrganizerListTicketKermesseScreenState();
}

class _OrganizerListTicketKermesseScreenState extends State<OrganizerListTicketKermesseScreen> {
  final Key _key = UniqueKey();

  final TicketService _ticketService = TicketService();

  Future<List<TicketList>> _getAll() async {
    ApiResponse<List<TicketList>> response = await _ticketService.getAllTickets();
    if (response.error != null) {
      throw Exception(response.error);
    }
    return response.data!;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenList(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Ticket List",
          ),
          Expanded(
            child: FutureBuilder<List<TicketList>>(
              key: _key,
              future: _getAll(),
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
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      TicketList ticket = snapshot.data![index];
                      return ListTile(
                        title: Text(ticket.isWinner ? 'Winner' : 'Loser'),
                        subtitle: Text(ticket.user.name),
                        onTap: () {
                          context.push(
                            OrganizerRoutes.kermesseTicketDetails,
                            extra: {
                              "ticketId": ticket.id,
                            },
                          );
                        },
                      );
                    },
                  );
                }
                return const Center(
                  child: Text('No tickets found'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
