import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/ticket_data.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/services/ticket_service.dart';
import 'package:kermesse_frontend/widgets/global_appBar.dart';
import 'package:kermesse_frontend/widgets/screen_list.dart';
import 'package:kermesse_frontend/widgets/ticket_card.dart';

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
    return Scaffold(
      appBar: const GlobalAppBar(title: 'Tickets'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Children\'s tickets:",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
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
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return const Center(child: Text('No tickets found.'));
                      }

                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          TicketList ticket = snapshot.data![index];
                          return TicketCard(
                            username: ticket.user.name,
                            isWinner: ticket.isWinner,
                            isFinish: ticket.kermesse.status == 'FINISH',
                            onTap: () {
                              context.push(
                                ParentRoutes.ticketDetails,
                                extra: {
                                  'ticketId': ticket.id,
                                }
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
        ),
      ),
    );
  }


}
