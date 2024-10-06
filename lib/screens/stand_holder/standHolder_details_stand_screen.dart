import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/stand_data.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/services/stand_service.dart';
import 'package:kermesse_frontend/widgets/screen.dart';

class StandHolderDetailsStandScreen extends StatefulWidget {
  const StandHolderDetailsStandScreen({
    super.key,
  });

  @override
  State<StandHolderDetailsStandScreen> createState() => _StandHolderDetailsStandScreenState();
}

class _StandHolderDetailsStandScreenState extends State<StandHolderDetailsStandScreen> {
  final Key _key = UniqueKey();

  final StandService _standService = StandService();

  Future<StandDetailsResponse> _get() async {
    ApiResponse<StandDetailsResponse> response = await _standService.getOwnStand();
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
    return Screen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Stand Details",
          ),
          FutureBuilder<StandDetailsResponse>(
            key: _key,
            future: _get(),
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
                StandDetailsResponse stand = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(stand.id.toString()),
                    Text(stand.category),
                    Text(stand.name),
                    Text(stand.description),
                    Text(stand.stock.toString()),
                    Text(stand.price.toString()),
                    ElevatedButton(
                      onPressed: () async {
                        await context.push(
                          StandHolderRoutes.standModify,
                        );
                        _init();
                      },
                      child: const Text('Modify stand'),
                    ),
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
