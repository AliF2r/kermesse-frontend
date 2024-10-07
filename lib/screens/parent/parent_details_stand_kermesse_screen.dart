import 'package:flutter/material.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/stand_data.dart';
import 'package:kermesse_frontend/providers/auth_provider.dart';
import 'package:kermesse_frontend/providers/auth_user.dart';
import 'package:kermesse_frontend/services/auth_service.dart';
import 'package:kermesse_frontend/services/participation_service.dart';
import 'package:kermesse_frontend/services/stand_service.dart';
import 'package:kermesse_frontend/widgets/app_theme_helper.dart';
import 'package:kermesse_frontend/widgets/custom_button.dart';
import 'package:kermesse_frontend/widgets/custom_input_field.dart';
import 'package:kermesse_frontend/widgets/global_appBar.dart';
import 'package:kermesse_frontend/widgets/screen.dart';
import 'package:kermesse_frontend/widgets/stand_card_details.dart';
import 'package:kermesse_frontend/widgets/text_input.dart';
import 'package:provider/provider.dart';

class ParentDetailsStandKermesseScreen extends StatefulWidget {
  final int kermesseId;
  final int standId;

  const ParentDetailsStandKermesseScreen({
    super.key,
    required this.kermesseId,
    required this.standId,
  });

  @override
  State<ParentDetailsStandKermesseScreen> createState() => _ParentDetailsStandKermesseScreenState();
}

class _ParentDetailsStandKermesseScreenState extends State<ParentDetailsStandKermesseScreen> {
  final Key _key = UniqueKey();
  final TextEditingController quantityInput = TextEditingController();

  final StandService _standService = StandService();
  final ParticipationService _participationService = ParticipationService();
  final AuthService _authService = AuthService();

  Future<StandDetailsResponse> _getDetails() async {
    ApiResponse<StandDetailsResponse> response = await _standService.details(standId: widget.standId);
    if (response.error != null) {
      throw Exception(response.error);
    }
    return response.data!;
  }

  Future<void> _participate() async {
    ApiResponse<Null> response = await _participationService.create(
      kermesseId: widget.kermesseId,
      standId: widget.standId,
      quantity: int.tryParse(quantityInput.text) ?? 1,
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
          content: Text('Participation successful'),
        ),
      );
    }
  }

  @override
  void dispose() {
    quantityInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlobalAppBar(title: 'Stand Details'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<StandDetailsResponse>(
          key: _key,
          future: _getDetails(),
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
              StandDetailsResponse stand = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StandDetailsCard(stand: stand),
                    const SizedBox(height: 20),
                    if (stand.category == "GAME")
                      Container()
                    else
                      CustomInputField(
                        controller: quantityInput,
                        labelText: "Quantity",
                        inputType: TextInputType.number,
                      ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: stand.category == "GAME" ? "Start" : "Buy",
                      onPressed: _participate,
                    ),
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
}
