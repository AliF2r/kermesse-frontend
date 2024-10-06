import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/ticket_data.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/services/ticket_service.dart';
import 'package:kermesse_frontend/widgets/screen_list.dart';

class ParentListTicketScreen extends StatefulWidget {
  const ParentListTicketScreen({super.key});

  @override
  State<ParentListTicketScreen> createState() => _ParentListTicketScreenState();
}

class _ParentListTicketScreenState extends State<ParentListTicketScreen> {
  final Key _key = UniqueKey();

  final TicketService _ticketService = TicketService();

  Future<List<TicketList>> _getAllTicket() async {
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
              future: _getAllTicket(),
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
                        title: Text(ticket.isWinner ? 'Winner' : 'Maybe next time'),
                        subtitle: Text(ticket.user.name),
                        onTap: () {
                          context.push(
                            ParentRoutes.ticketDetails,
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
                  child: Text('No ticket found'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
