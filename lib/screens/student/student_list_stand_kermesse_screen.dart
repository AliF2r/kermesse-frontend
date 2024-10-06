import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/stand_data.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/services/stand_service.dart';
import 'package:kermesse_frontend/widgets/screen_list.dart';

class StudentListStandKermesseScreen extends StatefulWidget {
  final int kermesseId;

  const StudentListStandKermesseScreen({
    super.key,
    required this.kermesseId,
  });

  @override
  State<StudentListStandKermesseScreen> createState() => _StudentListStandKermesseScreenState();
}

class _StudentListStandKermesseScreenState extends State<StudentListStandKermesseScreen> {
  final Key _key = UniqueKey();

  final StandService _standService = StandService();

  Future<List<StandList>> _getAllStand() async {
    ApiResponse<List<StandList>> response = await _standService.getAllStands(kermesseId: widget.kermesseId);
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
            "Stand List of Kermesse",
          ),
          Expanded(
            child: FutureBuilder<List<StandList>>(
              key: _key,
              future: _getAllStand(),
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
                      StandList stand = snapshot.data![index];
                      return ListTile(
                        title: Text(stand.name),
                        subtitle: Text(stand.category),
                        onTap: () {
                          context.push(
                            StudentRoutes.kermesseStandDetails,
                            extra: {
                              "kermesseId": widget.kermesseId,
                              "standId": stand.id,
                            },
                          );
                        },
                      );
                    },
                  );
                }
                return const Center(
                  child: Text('No stands found'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
