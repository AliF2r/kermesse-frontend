import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/participation_data.dart';
import 'package:kermesse_frontend/providers/auth_provider.dart';
import 'package:kermesse_frontend/providers/auth_user.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/services/participation_service.dart';
import 'package:kermesse_frontend/widgets/app_theme_helper.dart';
import 'package:kermesse_frontend/widgets/global_appBar.dart';
import 'package:kermesse_frontend/widgets/screen_list.dart';
import 'package:provider/provider.dart';

class StandHolderListParticipationKermesseScreen extends StatefulWidget {
  final int kermesseId;

  const StandHolderListParticipationKermesseScreen({
    super.key,
    required this.kermesseId,
  });

  @override
  State<StandHolderListParticipationKermesseScreen> createState() => _StandHolderListParticipationKermesseScreenState();
}

class _StandHolderListParticipationKermesseScreenState extends State<StandHolderListParticipationKermesseScreen> {
  final Key _key = UniqueKey();

  final ParticipationService _participationService = ParticipationService();

  Future<List<ParticipationList>> _getAllParticipation() async {
    ApiResponse<List<ParticipationList>> response = await _participationService.getAllParticipations(kermesseId: widget.kermesseId);
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
                "List of Participations:",
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

  Widget buildParticipationCard(BuildContext context, ParticipationList participation) {
    AuthUser user = Provider.of<AuthProvider>(context, listen: false).user;
    Color roleColor = AppThemeHelper.getColorForRole(user.role);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: () async {
          // Navigate to the participation details when tapped
          await context.push(
            StandHolderRoutes.kermesseParticipationDetails,
            extra: {
              "kermesseId": widget.kermesseId,
              "participationId": participation.id,
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                participation.status == "STARTED" ? Icons.pending_actions : Icons.paid,
                color: participation.status == "STARTED" ? Colors.teal : roleColor,
                size: 40,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      participation.user.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Used ${participation.balance} jeton(s)',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Stand: ${participation.stand.name}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Description: ${participation.stand.description}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                AppThemeHelper.getStandIcon(participation.category).icon,
                color: roleColor,
                size: 36,
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
