import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/services/user_service.dart';
import 'package:kermesse_frontend/widgets/custom_button.dart';
import 'package:kermesse_frontend/widgets/custom_input_field.dart';
import 'package:kermesse_frontend/widgets/global_appBar.dart';
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
    ApiResponse<Null> response = await _userService.inviteChild(
      name: nameInput.text,
      email: emailInput.text,
    );

    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.error!)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User invited successfully')),
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
    return Scaffold(
      appBar: const GlobalAppBar(title: 'Invite Child'),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'The temporary password for the new child is "esgi-kermesse".',
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  CustomInputField(
                    controller: nameInput,
                    labelText: 'Child\'s Name',
                  ),
                  const SizedBox(height: 20),
                  CustomInputField(
                    controller: emailInput,
                    labelText: 'Child\'s Email',
                    inputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: 'Invite Child',
                    onPressed: _invite,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
