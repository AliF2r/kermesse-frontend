import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/services/user_service.dart';
import 'package:kermesse_frontend/widgets/screen.dart';
import 'package:kermesse_frontend/widgets/text_input.dart';

class ParentInvitationChildScreen extends StatefulWidget {
  const ParentInvitationChildScreen({super.key});

  @override
  State<ParentInvitationChildScreen> createState() => _ParentInvitationChildScreenState();
}

class _ParentInvitationChildScreenState extends State<ParentInvitationChildScreen> {
  final UserService _userService = UserService();

  final TextEditingController nameInput = TextEditingController();
  final TextEditingController emailInput = TextEditingController();

  Future<void> _invite() async {
    ApiResponse<Null> response = await _userService.inviteChild(name: nameInput.text, email: emailInput.text);
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.error!),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User invited successfully'),
        ),
      );
      context.pop();
    }
  }

  @override
  void dispose() {
    nameInput.dispose();
    emailInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Child Invite",
          ),
          TextInput(
            controller: nameInput,
            hint: 'Name',
          ),
          TextInput(
            controller: emailInput,
            hint: 'Email',
          ),
          ElevatedButton(
            onPressed: _invite,
            child: const Text('Invite child'),
          ),
        ],
      ),
    );
  }
}
