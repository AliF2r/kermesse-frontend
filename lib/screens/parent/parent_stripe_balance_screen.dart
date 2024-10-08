import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/services/stripe_service.dart';
import 'package:kermesse_frontend/widgets/custom_button.dart';
import 'package:kermesse_frontend/widgets/custom_input_field.dart';
import 'package:kermesse_frontend/widgets/global_appBar.dart';
import 'package:kermesse_frontend/widgets/screen.dart';

class ParentStripeBalanceScreen extends StatefulWidget {
  final int userId;

  const ParentStripeBalanceScreen({
    super.key,
    required this.userId,
  });

  @override
  State<ParentStripeBalanceScreen> createState() => _ParentStripeBalanceScreenState();
}

class _ParentStripeBalanceScreenState extends State<ParentStripeBalanceScreen> {
  final StripeService _stripeService = StripeService();

  final TextEditingController balanceInput = TextEditingController();

  Future<void> _buy() async {
    await _stripeService.stripePaymentCheckout(widget.userId, int.parse(balanceInput.text),
      context,
      onSuccess: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Jeton bought successfully'),
          ),
        );
        context.push(ParentRoutes.userDetails);
      },
      onCancel: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Jeton buying canceled'),
          ),
        );
      },
      onError: (error) {},
    );
  }
  @override
  void dispose() {
    balanceInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlobalAppBar(title: 'Buy Jetons'),
      body: Screen(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Buy Jetons (1 jeton = 1 €)",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              CustomInputField(
                controller: balanceInput,
                labelText: "Jetons",
                inputType: TextInputType.number,
              ),
              const SizedBox(height: 30),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: "Buy Jetons",
                    onPressed: _buy,
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
