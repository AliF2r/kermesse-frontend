import 'package:flutter/material.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/participation_data.dart';
import 'package:kermesse_frontend/services/participation_service.dart';
import 'package:kermesse_frontend/widgets/global_appBar.dart';
import 'package:kermesse_frontend/widgets/screen.dart';

class ParentDetailsParticipationKermesseScreen extends StatefulWidget {
  final int kermesseId;
  final int participationId;

  const ParentDetailsParticipationKermesseScreen({
    super.key,
    required this.kermesseId,
    required this.participationId,
  });

  @override
  State<ParentDetailsParticipationKermesseScreen> createState() => _ParentDetailsParticipationKermesseScreenState();
}

class _ParentDetailsParticipationKermesseScreenState extends State<ParentDetailsParticipationKermesseScreen> {
  final Key _key = UniqueKey();

  final ParticipationService _participationService = ParticipationService();

  Future<ParticipationDetailsResponse> _getParticipation() async {
    ApiResponse<ParticipationDetailsResponse> response = await _participationService.details(participationId: widget.participationId);
    if (response.error != null) {
      throw Exception(response.error);
    }
    return response.data!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlobalAppBar(
        title: 'Participation Details',
      ),
      body: Screen(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Participation Details",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              FutureBuilder<ParticipationDetailsResponse>(
                key: _key,
                future: _getParticipation(),
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
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    ParticipationDetailsResponse participation = snapshot.data!;
                    return ParticipationDetailsCard(participation: participation);
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
}
class ParticipationDetailsCard extends StatelessWidget {
  final ParticipationDetailsResponse participation;

  const ParticipationDetailsCard({
    Key? key,
    required this.participation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoRow(icon: Icons.person, label: 'User name', value: participation.user.name),
            InfoRow(icon: Icons.location_city, label: 'Kermesse name', value: participation.kermesse.name),
            InfoRow(icon: Icons.category, label: 'Category of stand', value: participation.category),
            InfoRow(icon: Icons.confirmation_number, label: 'Stand name', value: participation.stand.name),
            InfoRow(icon: Icons.store, label: 'Description', value: participation.stand.description),
            InfoRow(icon: Icons.account_balance_wallet, label: 'Balance paid', value: '${participation.balance} jeton'),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoRow({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.blueAccent,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$label: $value',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
