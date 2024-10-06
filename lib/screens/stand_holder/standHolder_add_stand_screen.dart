import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/providers/auth_provider.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/services/stand_service.dart';
import 'package:kermesse_frontend/widgets/screen.dart';
import 'package:kermesse_frontend/widgets/text_input.dart';
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

  final StandService _standService = StandService();

  Future<void> _addStand() async {
    ApiResponse<Null> response = await _standService.addStand(
      category: categoryInput.text,
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
    return Screen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Stand Create",
          ),
          Column(
            children: [
              RadioListTile<String>(
                title: const Text('Game'),
                value: 'GAME',
                groupValue: categoryInput.text,
                onChanged: (value) {
                  setState(() {
                    categoryInput.text = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Food'),
                value: 'FOOD',
                groupValue: categoryInput.text,
                onChanged: (value) {
                  setState(() {
                    categoryInput.text = value!;
                  });
                },
              ),
            ],
          ),
          TextInput(
            hint: "Name",
            controller: nameInput,
          ),
          TextInput(
            hint: "Description",
            controller: descriptionInput,
          ),
          TextInput(
            hint: "Price",
            controller: priceInput,
          ),
          TextInput(
            hint: "Stock",
            controller: stockInput,
          ),
          ElevatedButton(
            onPressed: _addStand,
            child: const Text('Add stand'),
          ),
        ],
      ),
    );
  }

}
