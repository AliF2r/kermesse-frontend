import 'package:flutter/material.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/stand_data.dart';
import 'package:kermesse_frontend/services/participation_service.dart';
import 'package:kermesse_frontend/services/stand_service.dart';
import 'package:kermesse_frontend/widgets/screen.dart';
import 'package:kermesse_frontend/widgets/text_input.dart';

class StudentDetailsStandKermesseScreen extends StatefulWidget {
  final int kermesseId;
  final int standId;

  const StudentDetailsStandKermesseScreen({
    super.key,
    required this.kermesseId,
    required this.standId,
  });

  @override
  State<StudentDetailsStandKermesseScreen> createState() => _StudentDetailsStandKermesseScreenState();
}

class _StudentDetailsStandKermesseScreenState extends State<StudentDetailsStandKermesseScreen> {
  final Key _key = UniqueKey();
  final TextEditingController quantityInput = TextEditingController();

  final StandService _standService = StandService();
  final ParticipationService _participationService = ParticipationService();

  Future<StandDetailsResponse> _getDetails() async {
    ApiResponse<StandDetailsResponse> response = await _standService.details(standId: widget.standId);
    if (response.error != null) {
      throw Exception(response.error);
    }
    return response.data!;
  }

  Future<void> _createParticipation() async {
    ApiResponse<Null> response = await _participationService.create(kermesseId: widget.kermesseId, standId: widget.standId, quantity: int.parse(quantityInput.text));
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.error!),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Participation successful'),
        ),
      );
    }
  }

  @override
  void dispose() {
    quantityInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Stand Details",
          ),
          FutureBuilder<StandDetailsResponse>(
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
                StandDetailsResponse stand = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(stand.id.toString()),
                    Text(stand.category),
                    Text(stand.name),
                    Text(stand.description),
                    Text(stand.price.toString()),
                    Text(stand.stock.toString()),
                    stand.category == "ACTIVITY"
                        ? SizedBox(width: 0, height: 0, child: TextInput(
                        value: "1",
                        controller: quantityInput,
                        hint: "Quantity",
                      ),
                    )
                        : TextInput(
                      value: "1",
                      controller: quantityInput,
                      hint: "Quantity",
                    ),
                    ElevatedButton(
                      onPressed: _createParticipation,
                      child: const Text("Participate"),
                    ),
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
