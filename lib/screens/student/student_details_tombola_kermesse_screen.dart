import 'package:flutter/material.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/tombola_data.dart';
import 'package:kermesse_frontend/services/ticket_service.dart';
import 'package:kermesse_frontend/services/tombola_service.dart';
import 'package:kermesse_frontend/widgets/screen.dart';

class StudentDetailsTombolaKermesseScreen extends StatefulWidget {
  final int kermesseId;
  final int tombolaId;

  const StudentDetailsTombolaKermesseScreen({
    super.key,
    required this.kermesseId,
    required this.tombolaId,
  });

  @override
  State<StudentDetailsTombolaKermesseScreen> createState() => _StudentDetailsTombolaKermesseScreenState();
}

class _StudentDetailsTombolaKermesseScreenState extends State<StudentDetailsTombolaKermesseScreen> {
  final Key _key = UniqueKey();

  final TicketService _ticketService = TicketService();
  final TombolaService _tombolaService = TombolaService();

  Future<TombolaDetailsResponse> _getDetails() async {
    ApiResponse<TombolaDetailsResponse> response = await _tombolaService.getDetails(tombolaId: widget.tombolaId);
    if (response.error != null) {
      throw Exception(response.error);
    }
    return response.data!;
  }

  Future<void> _createTicket() async {
    ApiResponse<Null> response = await _ticketService.create(tombolaId: widget.tombolaId);
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.error!),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ticket created successfully'),
        ),
      );
      _init();
    }
  }

  void _init() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tombola Details",
          ),
          FutureBuilder<TombolaDetailsResponse>(
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
                  ),
                );
              }
              if (snapshot.hasData) {
                TombolaDetailsResponse data = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.id.toString()),
                    Text(data.name),
                    Text(data.price.toString()),
                    Text(data.prize),
                    Text(data.status),
                    ElevatedButton(
                      onPressed: _createTicket,
                      child: const Text("Buy ticket"),
                    )
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
