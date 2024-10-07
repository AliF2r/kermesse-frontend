import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/services/auth_service.dart';
import 'package:kermesse_frontend/widgets/custom_button.dart';
import 'package:kermesse_frontend/widgets/custom_input_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  TextEditingController nameInput = TextEditingController();
  TextEditingController emailInput = TextEditingController();
  TextEditingController passwordInput = TextEditingController();
  String selectedRole = 'ORGANIZER';

  AuthService authService = AuthService();

  Future<void> register() async {
    ApiResponse<Null> response = await authService.register(
      name: nameInput.text,
      email: emailInput.text,
      password: passwordInput.text,
      role: selectedRole,
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
          content: Text('Register successful'),
        ),
      );
      context.push(AuthRoutes.login);
    }
  }

  @override
  void dispose() {
    nameInput.dispose();
    emailInput.dispose();
    passwordInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                CustomInputField(
                  controller: nameInput,
                  labelText: 'Name',
                ),
                const SizedBox(height: 20),
                CustomInputField(
                  controller: emailInput,
                  labelText: 'Email',
                  inputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                CustomInputField(
                  controller: passwordInput,
                  labelText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 30),

                // Role selection using Radio buttons
                const Text(
                  'Select Role:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                RadioListTile<String>(
                  title: const Text('Organizer'),
                  value: 'ORGANIZER',
                  groupValue: selectedRole,
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Parent'),
                  value: 'PARENT',
                  groupValue: selectedRole,
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Stand Holder'),
                  value: 'STAND_HOLDER',
                  groupValue: selectedRole,
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value!;
                    });
                  },
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: 'Register',
                  onPressed: register,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
