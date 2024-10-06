import 'package:flutter/material.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/participation_data.dart';
import 'package:kermesse_frontend/services/participation_service.dart';
import 'package:kermesse_frontend/widgets/screen.dart';
import 'package:kermesse_frontend/widgets/text_input.dart';

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
    return Screen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Participation Details",
          ),
          FutureBuilder<ParticipationDetailsResponse>(
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
                ParticipationDetailsResponse participation = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(participation.id.toString()),
                    Text(participation.category),
                    Text(participation.status),
                    Text(participation.user.name),
                    Text(participation.balance.toString()),
                    Text(participation.kermesse.name),
                    Text(participation.stand.name),
                    participation.category == "GAME" && participation.status == "STARTED"
                        ? Column(
                      children: [
                        TextInput(
                          controller: pointInput,
                          value: "0",
                          hint: "Point",
                        ),
                        ElevatedButton(
                          onPressed: _finishGame,
                          child: const Text("finish game"),
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
    );
  }
}
