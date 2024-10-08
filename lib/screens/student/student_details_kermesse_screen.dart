import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/kermesse_data.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/services/kermesse_service.dart';
import 'package:kermesse_frontend/widgets/custom_button.dart';
import 'package:kermesse_frontend/widgets/global_appBar.dart';
import 'package:kermesse_frontend/widgets/statistics_widget.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlobalAppBar(title: 'Kermesse Details'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<KermesseDetailsResponse>(
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
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            if (snapshot.hasData) {
              KermesseDetailsResponse kermesse = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildKermesseInfo(kermesse),
                    const SizedBox(height: 20),
                    _buildKermesseStatistics(kermesse),
                    const SizedBox(height: 30),
                    _buildActionButtons(kermesse),
                  ],
                ),
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
                  style: const TextStyle(fontSize: 16, color: Colors.blue),
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
              label: 'Number of users',
              value: kermesse.userNumber.toString(),
            ),
            StatisticsWidget(
              icon: Icons.store,
              label: 'Number of Stands',
              value: kermesse.standNumber.toString(),
            ),
            StatisticsWidget(
              icon: Icons.confirmation_number,
              label: 'Tombolas',
              value: kermesse.tombolaNumber.toString(),
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
          text: 'List of Tombolas',
          onPressed: () {
            context.push(
              StudentRoutes.kermesseTombolaList,
              extra: {
                "kermesseId": kermesse.id,
              },
            );
          },
        ),
        const SizedBox(height: 20),
        CustomButton(
          text: 'List of Stands',
          onPressed: () {
            context.push(
              StudentRoutes.kermesseStandList,
              extra: {
                "kermesseId": kermesse.id,
              },
            );
          },
        ),
        const SizedBox(height: 20),
        CustomButton(
          text: 'Participations',
          onPressed: () {
            context.push(
              StudentRoutes.kermesseParticipationsList,
              extra: {
                "kermesseId": kermesse.id,
              },
            );
          },
        ),
      ],
    );
  }
}
