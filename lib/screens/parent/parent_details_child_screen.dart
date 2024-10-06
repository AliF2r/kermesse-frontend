import 'package:flutter/material.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/user_data.dart';
import 'package:kermesse_frontend/services/user_service.dart';
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
    ApiResponse<Null> response = await _userService.sendBalance(studentId: widget.userId, balance: int.parse(balanceInput.text));
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.error!),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jeton sent successfully'),
        ),
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
    return Screen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Children Details",
          ),
          FutureBuilder<UserList>(
            key: _key,
            future: _getDetails(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    snapshot.error.toString(),
                  ),
                );
              }
              if (snapshot.hasData) {
                UserList user = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.id.toString()),
                    Text(user.name),
                    Text(user.email),
                    Text(user.balance.toString()),
                    Text(user.role),
                    TextInput(
                      hint: "Balance",
                      controller: balanceInput,
                    ),
                    ElevatedButton(
                      onPressed: _sendJeton,
                      child: const Text("Send Jeton"),
                    ),
                  ],
                );
              }
              return const Center(
                child: Text('Something went wrong'),
              );
            },
          ),
        ],
      ),
    );
  }
}
