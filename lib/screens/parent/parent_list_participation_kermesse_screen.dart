import 'package:flutter/material.dart';
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

class ParentListParticipationKermesseScreen extends StatefulWidget {
  final int kermesseId;

  const ParentListParticipationKermesseScreen({
    super.key,
    required this.kermesseId,
  });

  @override
  State<ParentListParticipationKermesseScreen> createState() => _ParentListParticipationKermesseScreenState();
}

class _ParentListParticipationKermesseScreenState extends State<ParentListParticipationKermesseScreen> {
  final Key _key = UniqueKey();

  final ParticipationService _participationService = ParticipationService();

  Future<List<ParticipationList>> _getAll() async {
    ApiResponse<List<ParticipationList>> response = await _participationService.getAllParticipations(kermesseId: widget.kermesseId);
    if (response.error != null) {
      throw Exception(response.error);
    }
    return response.data!;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenList(
      appBar: const GlobalAppBar(title: "List of participations"),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Participation:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<ParticipationList>>(
                key: _key,
                future: _getAll(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return _buildErrorWidget(snapshot.error.toString());
                  }
                  if (snapshot.hasData) {
                    return _buildParticipationList(snapshot.data!);
                  }
                  return const Center(
                    child: Text('No Participation found'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Error: $error',
            style: const TextStyle(color: Colors.red, fontSize: 16),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              setState(() {});
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipationList(List<ParticipationList> participations) {
    return ListView.builder(
      itemCount: participations.length,
      itemBuilder: (context, index) {
        ParticipationList participation = participations[index];
        return ParticipationCard(
          participation: participation,
          kermesseId: widget.kermesseId,
        );
      },
    );
  }
}

class ParticipationCard extends StatelessWidget {
  final ParticipationList participation;
  final int kermesseId;

  const ParticipationCard({
    Key? key,
    required this.participation,
    required this.kermesseId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthUser user = Provider.of<AuthProvider>(context).user;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () async {
          await context.push(
            ParentRoutes.kermesseParticipationDetails,
            extra: {
              "kermesseId": kermesseId,
              "participationId": participation.id,
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                Icons.person,
                color: AppThemeHelper.getColorForRole(user.role),
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
                      'Balance: ${participation.balance} tokens',
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
                Icons.arrow_forward_ios,
                color: AppThemeHelper.getColorForRole(user.role),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
