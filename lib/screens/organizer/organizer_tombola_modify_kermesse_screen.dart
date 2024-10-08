import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/tombola_data.dart';
import 'package:kermesse_frontend/services/tombola_service.dart';
import 'package:kermesse_frontend/widgets/custom_button.dart';
import 'package:kermesse_frontend/widgets/custom_input_field.dart';
import 'package:kermesse_frontend/widgets/global_appBar.dart';
import 'package:kermesse_frontend/widgets/screen.dart';
import 'package:kermesse_frontend/widgets/text_input.dart';

class OrganizerTombolaModifyKermesseScreen extends StatefulWidget {
  final int kermesseId;
  final int tombolaId;

  const OrganizerTombolaModifyKermesseScreen({
    super.key,
    required this.tombolaId,
    required this.kermesseId,
  });

  @override
  State<OrganizerTombolaModifyKermesseScreen> createState() =>
      _OrganizerTombolaModifyKermesseScreenState();
}

class _OrganizerTombolaModifyKermesseScreenState extends State<OrganizerTombolaModifyKermesseScreen> {
  final Key _key = UniqueKey();

  final TextEditingController nameInput = TextEditingController();
  final TextEditingController prizeInput = TextEditingController();
  final TextEditingController priceInput = TextEditingController();
  final TombolaService _tombolaService = TombolaService();

  Future<TombolaDetailsResponse> _get() async {
    ApiResponse<TombolaDetailsResponse> response =
    await _tombolaService.getDetails(tombolaId: widget.tombolaId);
    if (response.error != null) {
      throw Exception(response.error);
    }
    return response.data!;
  }

  Future<void> _modifyTombola() async {
    ApiResponse<Null> response = await _tombolaService.modifyTombola(
      id: widget.tombolaId,
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
          content: Text('Tombola modified successfully'),
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
      appBar: const GlobalAppBar(title: 'Modify Tombola'),
      body: Screen(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Modify Tombola",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              FutureBuilder<TombolaDetailsResponse>(
                key: _key,
                future: _get(),
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
                    TombolaDetailsResponse data = snapshot.data!;
                    nameInput.text = data.name;
                    prizeInput.text = data.prize;
                    priceInput.text = data.price.toString();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomInputField(
                          controller: nameInput,
                          labelText: 'Name',
                        ),
                        const SizedBox(height: 20),
                        CustomInputField(
                          controller: prizeInput,
                          labelText: 'Prize',
                        ),
                        const SizedBox(height: 20),
                        CustomInputField(
                          controller: priceInput,
                          labelText: 'Price',
                          inputType: TextInputType.number,
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: SizedBox(
                            width: double.infinity,
                            child: CustomButton(
                              text: 'Modify Tombola',
                              onPressed: _modifyTombola,
                            ),
                          ),
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
        ),
      ),
    );
  }
}
