import 'package:flutter/material.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/user_data.dart';
import 'package:kermesse_frontend/services/user_service.dart';
import 'package:kermesse_frontend/widgets/confirmation_dialog.dart';
import 'package:kermesse_frontend/widgets/custom_button.dart';
import 'package:kermesse_frontend/widgets/custom_input_field.dart';
import 'package:kermesse_frontend/widgets/global_appBar.dart';
import 'package:kermesse_frontend/widgets/screen.dart';
import 'package:kermesse_frontend/widgets/text_input.dart';

class ParentDetailsChildScreen extends StatefulWidget {
  final int userId;

  const ParentDetailsChildScreen({
    super.key,
    required this.userId,
  });

  @override
  State<ParentDetailsChildScreen> createState() => _ParentDetailsChildScreenState();
}


class _ParentDetailsChildScreenState extends State<ParentDetailsChildScreen> {
  final Key _key = UniqueKey();
  final TextEditingController balanceInput = TextEditingController();
  final UserService _userService = UserService();

  Future<UserList> _getDetails() async {
    ApiResponse<UserList> response = await _userService.details(userId: widget.userId);
    if (response.error != null) {
      throw Exception(response.error);
    }
    return response.data!;
  }

  Future<void> _sendJeton() async {
    ApiResponse<Null> response = await _userService.sendBalance(
      studentId: widget.userId,
      balance: int.parse(balanceInput.text),
    );
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.error!)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jeton sent successfully')),
      );
      _init();
    }
  }

  void _init() {
    setState(() {});
  }

  @override
  void dispose() {
    balanceInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserList>(
      key: _key,
      future: _getDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            appBar: const GlobalAppBar(title: 'Child Details'),
            body: Center(
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }
        if (snapshot.hasData) {
          UserList user = snapshot.data!;
          return Scaffold(
            appBar: GlobalAppBar(title: '${user.name}\'s Details'),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Information :",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildDetailRow("Name", user.name),
                    _buildDetailRow("Email", user.email),
                    _buildDetailRow("Balance", '${user.balance} tokens'),
                    const SizedBox(height: 20),
                    const Spacer(),
                    CustomInputField(
                      controller: balanceInput,
                      labelText: 'Balance to Send',
                      inputType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: 'Send Jeton',
                        onPressed: () {
                          showConfirmationDialog(
                            context,
                            'Are you sure you want to send ${balanceInput.text} jetons to ${user.name}?',
                            _sendJeton,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: Text('Something went wrong'),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
