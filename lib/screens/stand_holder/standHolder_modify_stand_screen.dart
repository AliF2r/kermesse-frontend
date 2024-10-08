import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/stand_data.dart';
import 'package:kermesse_frontend/services/stand_service.dart';
import 'package:kermesse_frontend/widgets/custom_button.dart';
import 'package:kermesse_frontend/widgets/custom_input_field.dart';
import 'package:kermesse_frontend/widgets/global_appBar.dart';
import 'package:kermesse_frontend/widgets/screen.dart';

class StandHolderModifyScreen extends StatefulWidget {
  const StandHolderModifyScreen({
    super.key,
  });

  @override
  State<StandHolderModifyScreen> createState() => _StandHolderModifyScreenState();
}

class _StandHolderModifyScreenState extends State<StandHolderModifyScreen> {
  final Key _key = UniqueKey();
  final TextEditingController nameInput = TextEditingController();
  final TextEditingController descriptionInput = TextEditingController();
  final TextEditingController priceInput = TextEditingController();
  final TextEditingController stockInput = TextEditingController();

  final StandService _standService = StandService();

  Future<StandDetailsResponse> _getStand() async {
    ApiResponse<StandDetailsResponse> response = await _standService.getOwnStand();
    if (response.error != null) {
      throw Exception(response.error);
    }
    return response.data!;
  }

  Future<void> _modifyStand() async {
    ApiResponse<Null> response = await _standService.modifyStand(
      name: nameInput.text,
      description: descriptionInput.text,
      price: int.parse(priceInput.text),
      stock: int.parse(stockInput.text),
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
          content: Text('Stand modified successfully'),
        ),
      );
      context.pop();
    }
  }

  @override
  void dispose() {
    nameInput.dispose();
    descriptionInput.dispose();
    priceInput.dispose();
    stockInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlobalAppBar(title: 'Modify Stand'),
      body: Screen(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<StandDetailsResponse>(
            key: _key,
            future: _getStand(),
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
                nameInput.text = stand.name;
                descriptionInput.text = stand.description;
                priceInput.text = stand.price.toString();
                stockInput.text = stand.stock.toString();

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
                    const SizedBox(height: 16),
                    CustomInputField(
                      labelText: "Price",
                      controller: priceInput,
                      inputType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    if (stand.category == "FOOD") CustomInputField(labelText: "Stock", controller: stockInput, inputType: TextInputType.number,),
                    const SizedBox(height: 30),
                    Center(
                      child: SizedBox(
                        width: double.infinity, // Full-width button
                        child: CustomButton(
                          text: "Modify Stand",
                          onPressed: _modifyStand,
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
        ),
      ),
    );
  }
}
