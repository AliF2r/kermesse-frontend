

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/kermesse_data.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/services/kermesse_service.dart';
import 'package:kermesse_frontend/widgets/confirmation_dialog.dart';
import 'package:kermesse_frontend/widgets/custom_button.dart';
import 'package:kermesse_frontend/widgets/global_appBar.dart';
import 'package:kermesse_frontend/widgets/screen.dart';
import 'package:kermesse_frontend/widgets/statistics_widget.dart';

class OrganizerDetailsKermesseScreen extends StatefulWidget {
  final int kermesseId;

  const OrganizerDetailsKermesseScreen({
    super.key,
    required this.kermesseId,
  });

  @override
  State<OrganizerDetailsKermesseScreen> createState() => _OrganizerDetailsKermesseScreenState();
}

class _OrganizerDetailsKermesseScreenState extends State<OrganizerDetailsKermesseScreen> {
  final Key _key = UniqueKey();

  final KermesseService _kermesseService = KermesseService();

  Future<KermesseDetailsResponse> _getKermesse() async {
    ApiResponse<KermesseDetailsResponse> response =
    await _kermesseService.details(
      kermesseId: widget.kermesseId,
    );
    if (response.error != null) {
      throw Exception(response.error);
    }
    return response.data!;
  }

  Future<void> _showConfirmationDialog() async {
    showConfirmationDialog(
      context,
      'The kermesse is really finished?',
      _complete,
    );
  }


  Future<void> _complete() async {
    ApiResponse<Null> response =
    await _kermesseService.complete(id: widget.kermesseId);
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.error!),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kermesse finished successfully'),
        ),
      );
      _init();
    }
  }

  void _init() {
    setState(() {});
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
            future: _getKermesse(),
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
              icon: Icons.attach_money,
              label: 'Tombola Benefit',
              value: '${kermesse.tombolaBenefit} €',
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
          text: 'List of Users',
          onPressed: () {
            context.push(OrganizerRoutes.kermesseUsers, extra: {"kermesseId": kermesse.id});
          },
        ),
        const SizedBox(height: 20),
        CustomButton(
          text: 'List of Stands',
          onPressed: () {
            context.push(OrganizerRoutes.kermesseStands, extra: {"kermesseId": kermesse.id});
          },
        ),
        const SizedBox(height: 20),
        CustomButton(
          text: 'List of Tombolas',
          onPressed: () {
            context.push(OrganizerRoutes.kermesseTombolas, extra: {"kermesseId": kermesse.id});
          },
        ),
        const SizedBox(height: 20),
        CustomButton(
          text: 'List of Participations',
          onPressed: () {
            context.push(OrganizerRoutes.kermesseParticipations, extra: {"kermesseId": kermesse.id});
          },
        ),
        const SizedBox(height: 20),
        if (kermesse.status == "STARTED")
          CustomButton(
            text: 'Modify Kermesse',
            onPressed: () async {
              await context.push(
                OrganizerRoutes.modifyKermesse,
                extra: {"kermesseId": kermesse.id},
              );
              _init();
            },
          ),
        if (kermesse.status == "STARTED")
          const SizedBox(height: 20),
          CustomButton(
              text: 'Finish Kermesse',
              onPressed: _showConfirmationDialog
          ),
        const SizedBox(height: 20),
      ],
    );
  }
}
