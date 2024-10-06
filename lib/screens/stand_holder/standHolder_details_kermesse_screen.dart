import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/kermesse_data.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/services/kermesse_service.dart';
import 'package:kermesse_frontend/widgets/screen.dart';

class StandHolderDetailsKermesseScreen extends StatefulWidget {
  final int kermesseId;

  const StandHolderDetailsKermesseScreen({
    super.key,
    required this.kermesseId,
  });

  @override
  State<StandHolderDetailsKermesseScreen> createState() => _StandHolderDetailsKermesseScreenState();
}

class _StandHolderDetailsKermesseScreenState extends State<StandHolderDetailsKermesseScreen> {
  final Key _key = UniqueKey();

  final KermesseService _kermesseService = KermesseService();

  Future<KermesseDetailsResponse> _getDetails() async {
    ApiResponse<KermesseDetailsResponse> response = await _kermesseService.details(kermesseId: widget.kermesseId);
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
            "Kermesse Details",
          ),
          FutureBuilder<KermesseDetailsResponse>(
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
                KermesseDetailsResponse kermesse = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(kermesse.id.toString()),
                    Text(kermesse.name),
                    Text(kermesse.description),
                    Text(kermesse.status),
                    ElevatedButton(
                      onPressed: () {
                        context.push(
                          StandHolderRoutes.kermesseParticipationList,
                          extra: {
                            "kermesseId": kermesse.id,
                          },
                        );
                      },
                      child: const Text("Participations"),
                    )
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
