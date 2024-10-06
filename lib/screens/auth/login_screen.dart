import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_constants.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/auth_data.dart';
import 'package:kermesse_frontend/providers/auth_provider.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<LoginScreen> {

  TextEditingController emailInput = TextEditingController();
  TextEditingController passwordInput = TextEditingController();
  AuthService authService = AuthService();


 Future<void> login() async {
  ApiResponse<LoginResponse> response = await authService.login(
    email: emailInput.text,
    password: passwordInput.text,
  );

  if (response.error != null) {
    _showSnackBar(response.error!);
    return;
  }

  await _saveToken(response.data!.token);
  _setUser(response.data!);
  _navigateToDashboard(response.data!.role);
  _showSnackBar('login successful');
}

 void _showSnackBar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}

 Future<void> _saveToken(String token) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString(ApiConstants.tokenKey, token);
}

 void _setUser(LoginResponse data) {
  Provider.of<AuthProvider>(context, listen: false).setUser(
    data.id,
    data.name,
    data.email,
    data.role,
    data.withStand,
  );
}

 void _navigateToDashboard(String role) {
  if (role == "ORGANIZER") {
    context.go(OrganizerRoutes.dashboard);
  } // TODO: add more roles
}

  @override
  void dispose() {
    emailInput.dispose();
    passwordInput.dispose();
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
                'Login',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
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
              ElevatedButton(
                onPressed: login,
                child: const Text('Login'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.push(AuthRoutes.register);
                },
                child: const Text('Register'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
