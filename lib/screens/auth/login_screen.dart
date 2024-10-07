import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_constants.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/auth_data.dart';
import 'package:kermesse_frontend/providers/auth_provider.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/services/auth_service.dart';
import 'package:kermesse_frontend/widgets/custom_button.dart';
import 'package:kermesse_frontend/widgets/custom_input_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

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
    _showSnackBar('Login successful');
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
      data.balance,
    );
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
                  'Login',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
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
                CustomButton(
                  text: 'Login',
                  onPressed: login,
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: 'Register page',
                  onPressed: () {
                    context.push(AuthRoutes.register);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
