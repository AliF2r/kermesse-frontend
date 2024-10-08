import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_constants.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/providers/auth_provider.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/services/user_service.dart';
import 'package:kermesse_frontend/widgets/confirmation_dialog.dart';
import 'package:kermesse_frontend/widgets/custom_button.dart';
import 'package:kermesse_frontend/widgets/custom_input_field.dart';
import 'package:kermesse_frontend/widgets/global_appBar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StandHolderUserModifyScreen extends StatefulWidget {
  final int userId;

  const StandHolderUserModifyScreen({
    super.key,
    required this.userId,
  });

  @override
  State<StandHolderUserModifyScreen> createState() => _StandHolderUserModifyScreenState();
}

class _StandHolderUserModifyScreenState extends State<StandHolderUserModifyScreen> {
  final TextEditingController passwordInput = TextEditingController();
  final TextEditingController newPasswordInput = TextEditingController();

  final UserService _userService = UserService();

  Future<void> _updatePassword() async {
    ApiResponse<Null> response = await _userService.modifyPassword(userId: widget.userId, password: passwordInput.text, newPassword: newPasswordInput.text);
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.error!),
        ),
      );
    } else {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove(ApiConstants.tokenKey);
      Provider.of<AuthProvider>(context, listen: false).setUser(-1, "", "", "", false, 0);
      context.go(AuthRoutes.login);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password modified successfully'),
        ),
      );
    }
  }

  Future<void> _showConfirmationDialog() async {
    showConfirmationDialog(
      context,
      'Are you sure you want to modify the password?',
      _updatePassword,
    );
  }

  @override
  void dispose() {
    passwordInput.dispose();
    newPasswordInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlobalAppBar(title: 'Modify Password'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Edit Password",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              CustomInputField(
                controller: passwordInput,
                labelText: "Current Password",
                obscureText: true,
              ),
              const SizedBox(height: 20),

              CustomInputField(
                controller: newPasswordInput,
                labelText: "New Password",
                obscureText: true,
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: 'Modify Password',
                onPressed: _showConfirmationDialog,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
