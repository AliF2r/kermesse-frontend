import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/stand_data.dart';
import 'package:kermesse_frontend/services/stand_service.dart';
import 'package:kermesse_frontend/widgets/screen.dart';
import 'package:kermesse_frontend/widgets/text_input.dart';

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
    return Screen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Modify Stand",
          ),
          FutureBuilder<StandDetailsResponse>(
            key: _key,
            future: _getStand(),
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
                StandDetailsResponse stand = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextInput(
                      hint: "Name",
                      controller: nameInput,
                      value: stand.name,
                    ),
                    TextInput(
                      hint: "Description",
                      controller: descriptionInput,
                      value: stand.description,
                    ),
                    TextInput(
                      hint: "Price",
                      controller: priceInput,
                      value: stand.price.toString(),
                    ),
                    TextInput(
                      hint: "Stock",
                      controller: stockInput,
                      value: stand.stock.toString(),
                    ),
                    ElevatedButton(
                      onPressed: _modifyStand,
                      child: const Text('Modify stand'),
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
