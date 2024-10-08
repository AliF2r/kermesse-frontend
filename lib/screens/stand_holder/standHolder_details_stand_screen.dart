import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/stand_data.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/services/stand_service.dart';
import 'package:kermesse_frontend/widgets/custom_button.dart';
import 'package:kermesse_frontend/widgets/global_appBar.dart';
import 'package:kermesse_frontend/widgets/stand_card_details.dart';

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

  Future<StandDetailsResponse> _getDetails() async {
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
    return Scaffold(
      appBar: const GlobalAppBar(title: 'Stand Details'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<StandDetailsResponse>(
          key: _key,
          future: _getDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            if (snapshot.hasData) {
              StandDetailsResponse stand = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StandDetailsCard(stand: stand),
                    const SizedBox(height: 20),
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text: "Modify Stand",
                          onPressed: () async {
                            await context.push(
                              StandHolderRoutes.standModify,
                            );
                            _init();
                          },
                        ),
                      ),
                    ),
                  ],
                )
              );
            }
            return const Center(
              child: Text('Something went wrong'),
            );
          },
        ),
      ),
    );
  }
}

