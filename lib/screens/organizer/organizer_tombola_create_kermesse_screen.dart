import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/services/tombola_service.dart';
import 'package:kermesse_frontend/widgets/custom_button.dart';
import 'package:kermesse_frontend/widgets/custom_input_field.dart';
import 'package:kermesse_frontend/widgets/global_appBar.dart';
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
    return Scaffold(
      appBar: const GlobalAppBar(title: 'Add Tombola'),
      body: Screen(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Adding some padding for better visuals
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "New Tombola",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              CustomInputField(
                controller: nameInput,
                labelText: 'Name', // Replacing TextField with CustomInput
              ),
              const SizedBox(height: 20),
              CustomInputField(
                controller: prizeInput,
                labelText: 'Prize', // Replacing TextField with CustomInput
              ),
              const SizedBox(height: 20),
              CustomInputField(
                controller: priceInput,
                labelText: 'Price',
                inputType: TextInputType.number, // Ensure numeric input
              ),
              const SizedBox(height: 30), // Add some spacing before the button
              Center(
                child: SizedBox(
                  width: double.infinity, // Making the button full width
                  child: CustomButton( // Using the reusable CustomButton
                    text: 'Add Tombola',
                    onPressed: _addTombola,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
