import 'package:flutter/material.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/participation_data.dart';
import 'package:kermesse_frontend/services/participation_service.dart';
import 'package:kermesse_frontend/widgets/screen.dart';

class OrganizerParticipationDetailsKermesseScreen extends StatefulWidget {
  final int kermesseId;
  final int participationId;

  const OrganizerParticipationDetailsKermesseScreen({
    super.key,
    required this.kermesseId,
    required this.participationId,
  });

  @override
  State<OrganizerParticipationDetailsKermesseScreen> createState() =>
      _OrganizerParticipationDetailsKermesseScreenState();
}

class _OrganizerParticipationDetailsKermesseScreenState
    extends State<OrganizerParticipationDetailsKermesseScreen> {
  final Key _key = UniqueKey();

  final ParticipationService _participationService = ParticipationService();

  Future<ParticipationDetailsResponse> _get() async {
    ApiResponse<ParticipationDetailsResponse> response =
    await _participationService.details(
      interactionId: widget.participationId,
    );
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
            "Interaction Details",
          ),
          FutureBuilder<ParticipationDetailsResponse>(
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
                ParticipationDetailsResponse participation = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(participation.id.toString()),
                    Text(participation.type),
                    Text(participation.user.name),
                    Text(participation.balance.toString()),
                    Text(participation.kermesse.name),
                    Text(participation.stand.name),
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
