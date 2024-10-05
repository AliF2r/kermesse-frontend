import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/tombola_data.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/services/tombola_service.dart';
import 'package:kermesse_frontend/widgets/screen_list.dart';

class OrganizerTombolaListKermesseScreen extends StatefulWidget {
  final int kermesseId;

  const OrganizerTombolaListKermesseScreen({
    super.key,
    required this.kermesseId,
  });

  @override
  State<OrganizerTombolaListKermesseScreen> createState() =>
      _OrganizerTombolaListKermesseScreenState();
}

class _OrganizerTombolaListKermesseScreenState extends State<OrganizerTombolaListKermesseScreen> {
  final Key _key = UniqueKey();

  final TombolaService _tombolaService = TombolaService();

  Future<List<TombolaList>> _getAllTombolas() async {
    ApiResponse<List<TombolaList>> response = await _tombolaService.getAllTombolas(kermesseId: widget.kermesseId);
    if (response.error != null) {
      throw Exception(response.error);
    }
    return response.data!;
  }

  void _init() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ScreenList(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Kermesse Tombola List",
          ),
          ElevatedButton(
            onPressed: () async {
              await context.push(
                OrganizerRoutes.kermesseCreateTombola,
                extra: {
                  "kermesseId": widget.kermesseId,
                },
              );
              _init();
            },
            child: const Text('Create Tombola'),
          ),
          Expanded(
            child: FutureBuilder<List<TombolaList>>(
              key: _key,
              future: _getAllTombolas(),
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
                      TombolaList tombola = snapshot.data![index];
                      return ListTile(
                        title: Text(tombola.name),
                        subtitle: Text(tombola.prize),
                        onTap: () {
                          context.push(
                            OrganizerRoutes.kermesseDetailsTombola,
                            extra: {
                              "tombolaId": tombola.id,
                              "kermesseId": widget.kermesseId,
                            },
                          );
                        },
                      );
                    },
                  );
                }
                return const Center(
                  child: Text('No tombolas found'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
