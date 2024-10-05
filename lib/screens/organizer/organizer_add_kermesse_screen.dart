import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/services/kermesse_service.dart';
import 'package:kermesse_frontend/widgets/screen.dart';

class OrganizerAddKermesseScreen extends StatefulWidget {
  const OrganizerAddKermesseScreen({super.key});

  @override
  State<OrganizerAddKermesseScreen> createState() => _OrganizerAddKermesseScreenState();
}

class _OrganizerAddKermesseScreenState extends State<OrganizerAddKermesseScreen> {

  final TextEditingController nameInput = TextEditingController();
  final TextEditingController descriptionInput = TextEditingController();
  final KermesseService _kermesseService = KermesseService();

  Future<void> _add() async {
    ApiResponse<Null> response = await _kermesseService.add(
      name: nameInput.text,
      description: descriptionInput.text,
    );
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.error!),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kermesse added successfully'),
        ),
      );
      context.pop();
    }
  }

  @override
  void dispose() {
    nameInput.dispose();
    descriptionInput.dispose();
    super.dispose();
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
            "Add Kermesse",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: nameInput,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: descriptionInput,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _add,
              child: const Text('Add Kermesse'),
            ),
          ),
        ],
      ),
    ),
  );
}
}
