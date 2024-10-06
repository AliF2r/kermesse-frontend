import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  TextEditingController nameInput = TextEditingController();
  TextEditingController emailInput = TextEditingController();
  TextEditingController passwordInput = TextEditingController();
  TextEditingController roleInput = TextEditingController();

  AuthService authService = AuthService();

  Future<void> register() async {
    ApiResponse<Null> response = await authService.register(
      name: nameInput.text,
      email: emailInput.text,
      password: passwordInput.text,
      role: roleInput.text,
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
    roleInput.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Register',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameInput,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailInput,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordInput,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('Organizer'),
                    value: 'ORGANIZER',
                    groupValue: roleInput.text,
                    onChanged: (value) {
                      setState(() {
                        roleInput.text = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Parent'),
                    value: 'PARENT',
                    groupValue: roleInput.text,
                    onChanged: (value) {
                      setState(() {
                        roleInput.text = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Stand Holder'),
                    value: 'STAND_HOLDER',
                    groupValue: roleInput.text,
                    onChanged: (value) {
                      setState(() {
                        roleInput.text = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: register,
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
