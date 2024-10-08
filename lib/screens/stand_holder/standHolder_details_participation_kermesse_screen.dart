import 'package:flutter/material.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/participation_data.dart';
import 'package:kermesse_frontend/services/participation_service.dart';
import 'package:kermesse_frontend/widgets/custom_button.dart';
import 'package:kermesse_frontend/widgets/custom_input_field.dart';
import 'package:kermesse_frontend/widgets/global_appBar.dart';
import 'package:kermesse_frontend/widgets/screen.dart';

class StandHolderDetailsParticipationKermesseScreen extends StatefulWidget {
  final int kermesseId;
  final int participationId;

  const StandHolderDetailsParticipationKermesseScreen({
    super.key,
    required this.kermesseId,
    required this.participationId,
  });

  @override
  State<StandHolderDetailsParticipationKermesseScreen> createState() => _StandHolderDetailsParticipationKermesseScreenState();
}

class _StandHolderDetailsParticipationKermesseScreenState extends State<StandHolderDetailsParticipationKermesseScreen> {
  final Key _key = UniqueKey();
  final TextEditingController pointInput = TextEditingController();

  final ParticipationService _participationService = ParticipationService();

  Future<ParticipationDetailsResponse> _getDetails() async {
    ApiResponse<ParticipationDetailsResponse> response = await _participationService.details(participationId: widget.participationId);
    if (response.error != null) {
      throw Exception(response.error);
    }
    return response.data!;
  }

  Future<void> _finishGame() async {
    ApiResponse<Null> response = await _participationService.finishGame(
      participationId: widget.participationId,
      point: int.parse(pointInput.text),
    );
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.error!),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('participation ended successfully'),
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
      appBar: const GlobalAppBar(title: 'Participation Details'),
      body: Screen(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<ParticipationDetailsResponse>(
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
                ParticipationDetailsResponse participation = snapshot.data!;

                // If participation category is GAME and status is STARTED
                if (participation.category == "GAME" && participation.status == "STARTED") {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow("Participation Category", participation.category),
                      _buildDetailRow("Player", participation.user.name),
                      _buildDetailRow("Stand", participation.stand.name),
                      _buildDetailRow("Game", participation.stand.description),
                      _buildDetailRow("Game Price", "${participation.stand.price} jeton(s)"),
                      _buildDetailRow("Kermesse", participation.kermesse.name),
                      const SizedBox(height: 20),
                      CustomInputField(
                        controller: pointInput,
                        labelText: "Point",
                        inputType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: SizedBox(
                          width: double.infinity, // Full-width button
                          child: CustomButton(
                            text: "Finish Game",
                            onPressed: _finishGame,
                          ),
                        ),
                      ),
                    ],
                  );
                }

                // Otherwise, display the standard details
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow("Participation Category", participation.category),
                    _buildDetailRow("Buyer", participation.user.name),
                    _buildDetailRow("Price", "${participation.balance} tokens"),
                    _buildDetailRow("Kermesse", participation.kermesse.name),
                    _buildDetailRow("Stand", participation.stand.name),
                  ],
                );
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

  // Helper method to build a row for details
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
