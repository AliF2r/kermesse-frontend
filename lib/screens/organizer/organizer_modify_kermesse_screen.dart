

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/kermesse_data.dart';
import 'package:kermesse_frontend/services/kermesse_service.dart';
import 'package:kermesse_frontend/widgets/custom_button.dart';
import 'package:kermesse_frontend/widgets/custom_input_field.dart';
import 'package:kermesse_frontend/widgets/global_appBar.dart';
import 'package:kermesse_frontend/widgets/screen.dart';
import 'package:kermesse_frontend/widgets/text_input.dart';

class OrganizerModifyKermesseScreen extends StatefulWidget {
  final int kermesseId;

  const OrganizerModifyKermesseScreen({
    super.key,
    required this.kermesseId,
  });

  @override
  State<OrganizerModifyKermesseScreen> createState() => _KermesseEditScreenState();
}

class _KermesseEditScreenState extends State<OrganizerModifyKermesseScreen> {
  final Key _key = UniqueKey();
  final TextEditingController nameInput = TextEditingController();
  final TextEditingController descriptionInput = TextEditingController();

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

  Future<void> _modify() async {
    ApiResponse<Null> response = await _kermesseService.modify(
      id: widget.kermesseId,
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
          content: Text('Kermesse modified successfully'),
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
    return Scaffold(
      appBar: const GlobalAppBar(
        title: 'Modify Kermesse',
      ),
      body: Screen(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Modify Kermesse",
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
                    KermesseDetailsResponse data = snapshot.data!;
                    nameInput.text = data.name;
                    descriptionInput.text = data.description;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomInputField(
                          labelText: "Name",
                          controller: nameInput,
                        ),
                        const SizedBox(height: 16),
                        CustomInputField(
                          labelText: "Description",
                          controller: descriptionInput,
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: SizedBox(
                            width: double.infinity,
                            child: CustomButton(
                              text: 'Modify Kermesse',
                              onPressed: _modify,
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
