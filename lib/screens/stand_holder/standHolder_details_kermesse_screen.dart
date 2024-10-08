import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/kermesse_data.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/services/kermesse_service.dart';
import 'package:kermesse_frontend/widgets/custom_button.dart';
import 'package:kermesse_frontend/widgets/global_appBar.dart';
import 'package:kermesse_frontend/widgets/screen.dart';
import 'package:kermesse_frontend/widgets/statistics_widget.dart';

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
    return Scaffold(
      appBar: const GlobalAppBar(
        title: 'Kermesse Details',
      ),
      body: Screen(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<KermesseDetailsResponse>(
            key: _key,
            future: _getDetails(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              }
              if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildKermesseInfo(snapshot.data!),
                    const SizedBox(height: 20),
                    _buildKermesseStatistics(snapshot.data!),
                    const SizedBox(height: 20),
                    _buildActionButtons(snapshot.data!),
                  ],
                );
              }
              return const Center(child: Text('Something went wrong'));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildKermesseInfo(KermesseDetailsResponse kermesse) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.event, color: Colors.blue, size: 28),
                const SizedBox(width: 10),
                Text(
                  kermesse.name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              kermesse.description,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.blue, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Status: ${kermesse.status}',
                  style: TextStyle(
                    fontSize: 16,
                    color: kermesse.status == "STARTED" ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKermesseStatistics(KermesseDetailsResponse kermesse) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            StatisticsWidget(
              icon: Icons.people,
              label: 'Number of Users',
              value: kermesse.userNumber.toString(),
            ),
            const SizedBox(height: 8),
            StatisticsWidget(
              icon: Icons.store,
              label: 'Number of Stands',
              value: kermesse.standNumber.toString(),
            ),
            const SizedBox(height: 8),
            StatisticsWidget(
              icon: Icons.confirmation_number,
              label: 'Number of Tombolas',
              value: kermesse.tombolaNumber.toString(),
            ),
            const SizedBox(height: 8),
            StatisticsWidget(
              icon: Icons.integration_instructions,
              label: 'Total Participation',
              value: '${kermesse.participationNumber}',
            ),
            StatisticsWidget(
              icon: Icons.attach_money,
              label: 'Participation Benefit',
              value: '${kermesse.participationBenefit} €',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(KermesseDetailsResponse kermesse) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomButton(
          text: 'List of Participations',
          onPressed: () {
            context.push(StandHolderRoutes.kermesseParticipationList, extra: {"kermesseId": kermesse.id});
          },
        ),
      ],
    );
  }
}
