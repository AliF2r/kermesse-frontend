import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/services/tombola_service.dart';
import 'package:kermesse_frontend/widgets/screen.dart';


class OrganizerTombolaCreateKermesseScreen extends StatefulWidget {
  final int kermesseId;

  const OrganizerTombolaCreateKermesseScreen({
    super.key,
    required this.kermesseId,
  });

  @override
  State<OrganizerTombolaCreateKermesseScreen> createState() =>
      _OrganizerTombolaCreateKermesseScreenState();
}

class _OrganizerTombolaCreateKermesseScreenState extends State<OrganizerTombolaCreateKermesseScreen> {
  final Key _key = UniqueKey();

  final TombolaService _tombolaService = TombolaService();

  final TextEditingController nameInput = TextEditingController();
  final TextEditingController prizeInput = TextEditingController();
  final TextEditingController priceInput = TextEditingController();


  Future<void> _addTombola() async {
    ApiResponse<Null> response = await _tombolaService.add(
      kermesseId: widget.kermesseId,
      name: nameInput.text,
      prize: prizeInput.text,
      price: int.parse(priceInput.text),
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
          content: Text('Tombola created successfully'),
        ),
      );
      context.pop();
    }
  }

  @override
  void dispose() {
    nameInput.dispose();
    prizeInput.dispose();
    priceInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Add Tombola",
          ),
          TextField(
            controller: nameInput,
            decoration: const InputDecoration(
              hintText: 'Name',
            ),
          ),
          TextField(
            controller: prizeInput,
            decoration: const InputDecoration(
              hintText: 'Prize',
            ),
          ),
          TextField(
            controller: priceInput,
            decoration: const InputDecoration(
              hintText: 'Price',
            ),
          ),
          ElevatedButton(
            onPressed: _addTombola,
            child: const Text('Add tombola'),
          ),
        ],
      ),
    );
  }

}
