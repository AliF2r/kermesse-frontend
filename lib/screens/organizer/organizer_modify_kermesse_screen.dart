

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/kermesse_data.dart';
import 'package:kermesse_frontend/services/kermesse_service.dart';
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
  final TextEditingController _nameInput = TextEditingController();
  final TextEditingController _descriptionInput = TextEditingController();

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
      name: _nameInput.text,
      description: _descriptionInput.text,
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
    _nameInput.dispose();
    _descriptionInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Modify Kermesse",
          ),
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
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextInput(
                      hint: "Name",
                      controller: _nameInput,
                      value: data.name,
                    ),
                    TextInput(
                      hint: "Description",
                      controller: _descriptionInput,
                      value: data.description,
                    ),
                    ElevatedButton(
                      onPressed: _modify,
                      child: const Text('Modify Kermesse'),
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
    );
  }

}
