import 'package:flutter/material.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/participation_data.dart';
import 'package:kermesse_frontend/services/participation_service.dart';
import 'package:kermesse_frontend/widgets/screen.dart';

class StudentDetailsParticipationKermesseScreen extends StatefulWidget {
  final int kermesseId;
  final int participationId;

  const StudentDetailsParticipationKermesseScreen({
    super.key,
    required this.kermesseId,
    required this.participationId,
  });

  @override
  State<StudentDetailsParticipationKermesseScreen> createState() => _StudentDetailsParticipationKermesseScreenState();
}

class _StudentDetailsParticipationKermesseScreenState extends State<StudentDetailsParticipationKermesseScreen> {
  final Key _key = UniqueKey();

  final ParticipationService _participationService = ParticipationService();

  Future<ParticipationDetailsResponse> _getDetails() async {
    ApiResponse<ParticipationDetailsResponse> response = await _participationService.details(participationId: widget.participationId);
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
                    Text(participation.user.name),
                    Text(participation.balance.toString()),
                    Text(participation.category),
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
