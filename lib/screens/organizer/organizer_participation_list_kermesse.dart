import 'package:flutter/material.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/participation_data.dart';
import 'package:kermesse_frontend/services/participation_service.dart';
import 'package:kermesse_frontend/widgets/global_appBar.dart';
import 'package:kermesse_frontend/widgets/participation_card.dart';
import 'package:kermesse_frontend/widgets/screen_list.dart';

class OrganizerParticipationListKermesseScreen extends StatefulWidget {
  final int kermesseId;

  const OrganizerParticipationListKermesseScreen({
    super.key,
    required this.kermesseId,
  });

  @override
  State<OrganizerParticipationListKermesseScreen> createState() => _OrganizerParticipationListKermesseScreenState();
}

class _OrganizerParticipationListKermesseScreenState extends State<OrganizerParticipationListKermesseScreen> {
  final Key _key = UniqueKey();

  final ParticipationService _participationService = ParticipationService();

  Future<List<ParticipationList>> _getAllParticipation() async {
    ApiResponse<List<ParticipationList>> response =
    await _participationService.getAllParticipations(kermesseId: widget.kermesseId);
    if (response.error != null) {
      throw Exception(response.error);
    }
    return response.data!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlobalAppBar(title: 'Participations'),
      body: ScreenList(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Text(
                "List of participations:",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<ParticipationList>>(
                key: _key,
                future: _getAllParticipation(),
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
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        ParticipationList participation = snapshot.data![index];
                        return buildParticipationCard(context, participation);
                      },
                    );
                  }
                  return const Center(
                    child: Text('No participation found'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


}
