import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/kermesse_data.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/services/kermesse_service.dart';
import 'package:kermesse_frontend/widgets/screen_list.dart';

class StudentListKermesseScreen extends StatefulWidget {
  const StudentListKermesseScreen({super.key});

  @override
  State<StudentListKermesseScreen> createState() => _StudentListKermesseScreenState();
}

class _StudentListKermesseScreenState extends State<StudentListKermesseScreen> {
  final Key _key = UniqueKey();

  final KermesseService _kermesseService = KermesseService();

  Future<List<KermesseList>> _getKermesseList() async {
    ApiResponse<List<KermesseList>> response = await _kermesseService.getKermesseList();
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
            "Kermesse List",
          ),
          Expanded(
            child: FutureBuilder<List<KermesseList>>(
              key: _key,
              future: _getKermesseList(),
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
                      KermesseList kermesse = snapshot.data![index];
                      return ListTile(
                        title: Text(kermesse.name),
                        subtitle: Text(kermesse.description),
                        onTap: () {
                          context.push(
                            StudentRoutes.kermesseDetails,
                            extra: {
                              "kermesseId": kermesse.id,
                            },
                          );
                        },
                      );
                    },
                  );
                }
                return const Center(
                  child: Text('No kermesses found'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
