import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/tombola_data.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/services/tombola_service.dart';
import 'package:kermesse_frontend/widgets/confirmation_dialog.dart';
import 'package:kermesse_frontend/widgets/custom_button.dart';
import 'package:kermesse_frontend/widgets/global_appBar.dart';
import 'package:kermesse_frontend/widgets/screen.dart';

class OrganizerTombolaDetailsKermesseScreen extends StatefulWidget {
  final int kermesseId;
  final int tombolaId;

  const OrganizerTombolaDetailsKermesseScreen({
    super.key,
    required this.kermesseId,
    required this.tombolaId,
  });

  @override
  State<OrganizerTombolaDetailsKermesseScreen> createState() =>
      _OrganizerTombolaDetailsKermesseState();
}

class _OrganizerTombolaDetailsKermesseState
    extends State<OrganizerTombolaDetailsKermesseScreen> {
  final Key _key = UniqueKey();

  final TombolaService _tombolaService = TombolaService();

  Future<TombolaDetailsResponse> _getTombolaDetails() async {
    ApiResponse<TombolaDetailsResponse> response = await _tombolaService.getDetails(tombolaId: widget.tombolaId);
    if (response.error != null) {
      throw Exception(response.error);
    }
    return response.data!;
  }

  Future<void> _finishTombolaAndSetWinner() async {
    ApiResponse<Null> response =
    await _tombolaService.finishTombolaAndSetWinner(tombolaId: widget.tombolaId);
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.error!),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tombola ended successfully'),
        ),
      );
      _init();
    }
  }

  Future<void> _showConfirmationDialog() async {
    showConfirmationDialog(
      context,
      'Are you sure you want to finish the tombola and set the winner?',
      _finishTombolaAndSetWinner,
    );
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
                future: _getTombolaDetails(),
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
                                  text: "Modify",
                                  onPressed: () async {
                                    await context.push(
                                      OrganizerRoutes.kermesseModifyTombola,
                                      extra: {
                                        "kermesseId": widget.kermesseId,
                                        "tombolaId": widget.tombolaId,
                                      },
                                    );
                                    _init();
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: SizedBox(
                                width: double.infinity,
                                child: CustomButton(
                                  text: "Finish and Set Winner",
                                  onPressed: _showConfirmationDialog,
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
