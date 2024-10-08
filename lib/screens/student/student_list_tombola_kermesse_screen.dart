import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/tombola_data.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/services/tombola_service.dart';
import 'package:kermesse_frontend/widgets/global_appBar.dart';
import 'package:kermesse_frontend/widgets/screen_list.dart';
import 'package:kermesse_frontend/widgets/tombola_card.dart';

class StudentListTombolaKermesseScreen extends StatefulWidget {
  final int kermesseId;

  const StudentListTombolaKermesseScreen({
    super.key,
    required this.kermesseId,
  });

  @override
  State<StudentListTombolaKermesseScreen> createState() =>
      _StudentListTombolaKermesseScreenState();
}

class _StudentListTombolaKermesseScreenState extends State<StudentListTombolaKermesseScreen> {
  final Key _key = UniqueKey();

  final TombolaService _tombolaService = TombolaService();

  Future<List<TombolaList>> _getAllTombola() async {
    ApiResponse<List<TombolaList>> response = await _tombolaService.getAllTombolas(kermesseId: widget.kermesseId);
    if (response.error != null) {
      throw Exception(response.error);
    }
    return response.data!;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const GlobalAppBar(title: 'Tombolas'),
      body: ScreenList(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Text(
                "List of Tombolas: ",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<TombolaList>>(
                key: _key,
                future: _getAllTombola(),
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
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        TombolaList tombola = snapshot.data![index];
                        return TombolaCard(
                          title: tombola.name,
                          prize: 'Prize: ${tombola.prize}',
                          price: 'Price: ${tombola.price}',
                          status: tombola.status,
                          showDetails: true,
                          onTap: () {
                            context.push(
                              StudentRoutes.kermesseTombolaDetails,
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
      ),
    );
  }
}
