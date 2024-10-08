import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/providers/auth_provider.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/services/stand_service.dart';
import 'package:kermesse_frontend/widgets/custom_button.dart';
import 'package:kermesse_frontend/widgets/custom_input_field.dart';
import 'package:kermesse_frontend/widgets/global_appBar.dart';
import 'package:kermesse_frontend/widgets/screen.dart';
import 'package:provider/provider.dart';

class StandHolderAddScreen extends StatefulWidget {
  const StandHolderAddScreen({super.key});

  @override
  State<StandHolderAddScreen> createState() => _StandHolderAddScreenState();
}

class _StandHolderAddScreenState extends State<StandHolderAddScreen> {
  final TextEditingController nameInput = TextEditingController();
  final TextEditingController categoryInput = TextEditingController();
  final TextEditingController descriptionInput = TextEditingController();
  final TextEditingController priceInput = TextEditingController();
  final TextEditingController stockInput = TextEditingController();
  String selectedCategory = 'FOOD';

  final StandService _standService = StandService();

  Future<void> _addStand() async {
    if (categoryInput.text == 'GAME') {
      stockInput.text = '0';
    }
    ApiResponse<Null> response = await _standService.addStand(
      category: selectedCategory,
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
          content: Text('Stand added successfully'),
        ),
      );
      Provider.of<AuthProvider>(context, listen: false).setHasStand(true);
      context.go(StandHolderRoutes.dashboard);
    }
  }

  @override
  void dispose() {
    nameInput.dispose();
    categoryInput.dispose();
    descriptionInput.dispose();
    priceInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlobalAppBar(title: 'Stand'),
      body: Screen(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Add your Stand",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text("Choose a category:"),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Radio<String>(
                        value: 'GAME',
                        groupValue: selectedCategory,
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value!;
                            stockInput.text = '0';
                          });
                        },
                      ),
                      const Text('Game'),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'FOOD',
                        groupValue: selectedCategory,
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value!;
                          });
                        },
                      ),
                      const Text('Food'),
                    ],
                  ),
                ],
              ),

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

              if (selectedCategory != 'GAME') ...[
                const SizedBox(height: 16),
                CustomInputField(
                  labelText: "Stock",
                  controller: stockInput,
                  inputType: TextInputType.number,
                ),
              ],
              const SizedBox(height: 30),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: "Add Stand",
                    onPressed: _addStand,
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
