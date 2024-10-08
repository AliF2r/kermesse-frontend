import 'package:flutter/material.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/tombola_data.dart';
import 'package:kermesse_frontend/services/ticket_service.dart';
import 'package:kermesse_frontend/services/tombola_service.dart';
import 'package:kermesse_frontend/widgets/confirmation_dialog.dart';
import 'package:kermesse_frontend/widgets/custom_button.dart';
import 'package:kermesse_frontend/widgets/global_appBar.dart';
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
    return Scaffold(
      appBar: const GlobalAppBar(title: 'Tombola Details'),
      body: Screen(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Tombola:",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              FutureBuilder<TombolaDetailsResponse>(
                key: _key,
                future: _getDetails(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
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
                    TombolaDetailsResponse tombola = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDetailRow('Name:', tombola.name),
                                _buildDetailRow('Prize:', tombola.prize),
                                _buildDetailRow('Price:', tombola.price.toString()),
                                _buildDetailRow('Status:', tombola.status),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        tombola.status == "STARTED"
                            ? Column(
                          children: [
                            Center(
                              child: SizedBox(
                                width: double.infinity,
                                child: CustomButton(
                                  text: "Buy Ticket",
                                  onPressed: _createTicket,
                                ),
                              ),
                            ),
                          ],
                        )
                            : const SizedBox.shrink(),
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
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 18, color: Colors.black26),
          ),
        ],
      ),
    );
  }
}
