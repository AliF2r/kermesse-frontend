

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/kermesse_data.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/services/kermesse_service.dart';
import 'package:kermesse_frontend/widgets/screen.dart';

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
    return Screen(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Kermesse Details",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            FutureBuilder<KermesseDetailsResponse>(
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
                  return _buildKermesseDetails(snapshot.data!);
                }
                return const Center(child: Text('Something went wrong'));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKermesseDetails(KermesseDetailsResponse kermesse) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          kermesse.id.toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          kermesse.name,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          kermesse.description,
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 8),
        Text(
          kermesse.status,
          style: TextStyle(
            fontSize: 14,
            color: kermesse.status == "STARTED" ? Colors.green : Colors.red,
          ),
        ),
        if (kermesse.status == "STARTED") _buildStartedActions(kermesse),
        _buildNavigationButton("Users", OrganizerRoutes.kermesseUsers, kermesse.id),
        _buildNavigationButton("Stands", OrganizerRoutes.kermesseStands, kermesse.id),
        _buildNavigationButton("Tombolas", OrganizerRoutes.kermesseTombolas, kermesse.id),
        _buildNavigationButton("Participations", OrganizerRoutes.kermesseParticipations, kermesse.id),
      ],
    );
}

  Widget _buildStartedActions(KermesseDetailsResponse kermesse) {
  return Column(
    children: [
      ElevatedButton(
        onPressed: () async {
          await context.push(
            OrganizerRoutes.modifyKermesse,
            extra: {"kermesseId": kermesse.id},
          );
          _init();
        },
        child: const Text("Modify"),
      ),
      ElevatedButton(
        onPressed: _complete,
        child: const Text("Finish"),
      ),
    ],
  );
}

  Widget _buildNavigationButton(String label, String route, int kermesseId) {
  return ElevatedButton(
    onPressed: () {
      context.push(route, extra: {"kermesseId": kermesseId});
    },
    child: Text(label),
  );
}
}
