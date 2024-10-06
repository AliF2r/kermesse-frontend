import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_constants.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/providers/auth_provider.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/services/user_service.dart';
import 'package:kermesse_frontend/widgets/screen.dart';
import 'package:kermesse_frontend/widgets/text_input.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserEditScreen extends StatefulWidget {
  final int userId;

  const UserEditScreen({
    super.key,
    required this.userId,
  });

  @override
  State<UserEditScreen> createState() => _UserEditScreenState();
}

class _UserEditScreenState extends State<UserEditScreen> {
  final TextEditingController passwordInput = TextEditingController();
  final TextEditingController newPasswordInput = TextEditingController();

  final UserService _userService = UserService();

  Future<void> _submit() async {
    ApiResponse<Null> response = await _userService.modify(
      userId: widget.userId,
      password: passwordInput.text,
      newPassword: newPasswordInput.text,
    );
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.error!),
        ),
      );
    } else {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove(ApiConstants.tokenKey);
      Provider.of<AuthProvider>(context, listen: false).setUser(-1, "", "", "", false);
      context.go(AuthRoutes.login);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password modified successfully'),
        ),
      );
    }
  }

  @override
  void dispose() {
    passwordInput.dispose();
    newPasswordInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Password Edit",
          ),
          TextInput(
            hint: "Password",
            controller: passwordInput,
          ),
          TextInput(
            hint: "New password",
            controller: newPasswordInput,
          ),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('update password'),
          ),
        ],
      ),
    );
  }
}
