import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/tombola_data.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/services/tombola_service.dart';
import 'package:kermesse_frontend/widgets/screen.dart';

class OrganizerTombolaDetailsKermesseScreen extends StatefulWidget {
  final int kermesseId;
  final int tombolaId;

  const OrganizerTombolaDetailsKermesseScreen({
    super.key,
    required this.kermesseId,
    required this.tombolaId,
  });

  @override
  State<OrganizerTombolaDetailsKermesseScreen> createState() =>
      _OrganizerTombolaDetailsKermesseState();
}

class _OrganizerTombolaDetailsKermesseState
    extends State<OrganizerTombolaDetailsKermesseScreen> {
  final Key _key = UniqueKey();

  final TombolaService _tombolaService = TombolaService();

  Future<TombolaDetailsResponse> _getTombolaDetails() async {
    ApiResponse<TombolaDetailsResponse> response = await _tombolaService.getDetails(tombolaId: widget.tombolaId);
    if (response.error != null) {
      throw Exception(response.error);
    }
    return response.data!;
  }

  Future<void> _finishTombolaAndSetWinner() async {
    ApiResponse<Null> response =
    await _tombolaService.finishTombolaAndSetWinner(tombolaId: widget.tombolaId);
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.error!),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tombola ended successfully'),
        ),
      );
      _refresh();
    }
  }

  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tombola Details",
          ),
          FutureBuilder<TombolaDetailsResponse>(
            key: _key,
            future: _getTombolaDetails(),
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
                TombolaDetailsResponse tombola = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tombola.id.toString()),
                    Text(tombola.name),
                    Text(tombola.prize),
                    Text(tombola.price.toString()),
                    Text(tombola.status),
                    tombola.status == "STARTED"
                        ? Column(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await context.push(
                              OrganizerRoutes.kermesseModifyTombola,
                              extra: {
                                "kermesseId": widget.kermesseId,
                                "tombolaId": widget.tombolaId,
                              },
                            );
                            _refresh();
                          },
                          child: const Text("Modify"),
                        ),
                        ElevatedButton(
                          onPressed: _finishTombolaAndSetWinner,
                          child: const Text("Finish and set winner"),
                        )
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
