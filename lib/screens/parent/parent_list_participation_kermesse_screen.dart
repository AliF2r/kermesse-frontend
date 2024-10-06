import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/participation_data.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/services/participation_service.dart';
import 'package:kermesse_frontend/widgets/screen_list.dart';

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Kermesse Participation List",
          ),
          Expanded(
            child: FutureBuilder<List<ParticipationList>>(
              key: _key,
              future: _getAll(),
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
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      ParticipationList participation = snapshot.data![index];
                      return ListTile(
                        title: Text(participation.user.name),
                        subtitle: Text(participation.balance.toString()),
                        onTap: () async {
                          await context.push(
                            ParentRoutes.kermesseParticipationDetails,
                            extra: {
                              "kermesseId": widget.kermesseId,
                              "participationId": participation.id,
                            },
                          );
                        },
                      );
                    },
                  );
                }
                return const Center(
                  child: Text('No Participation found'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
