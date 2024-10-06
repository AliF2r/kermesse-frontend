import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/kermesse_data.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/services/kermesse_service.dart';
import 'package:kermesse_frontend/widgets/screen.dart';

class StudentDetailsKermesseScreen extends StatefulWidget {
  final int kermesseId;

  const StudentDetailsKermesseScreen({
    super.key,
    required this.kermesseId,
  });

  @override
  State<StudentDetailsKermesseScreen> createState() => _StudentDetailsKermesseScreenState();
}

class _StudentDetailsKermesseScreenState extends State<StudentDetailsKermesseScreen> {
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
                KermesseDetailsResponse data = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.id.toString()),
                    Text(data.name),
                    Text(data.description),
                    Text(data.status),
                    ElevatedButton(
                      onPressed: () {
                        context.push(
                          StudentRoutes.kermesseTombolaList,
                          extra: {
                            "kermesseId": data.id,
                          },
                        );
                      },
                      child: const Text("Tombolas"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.push(
                          StudentRoutes.kermesseStandList,
                          extra: {
                            "kermesseId": data.id,
                          },
                        );
                      },
                      child: const Text("Stands"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.push(
                          StudentRoutes.kermesseParticipationsList,
                          extra: {
                            "kermesseId": data.id,
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
