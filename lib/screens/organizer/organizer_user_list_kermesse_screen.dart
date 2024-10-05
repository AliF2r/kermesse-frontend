import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/user_data.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/services/user_service.dart';
import 'package:kermesse_frontend/widgets/screen_list.dart';


class OriganizerUserListKermesseScreen extends StatefulWidget {
  final int kermesseId;

  const OriganizerUserListKermesseScreen({
    super.key,
    required this.kermesseId,
  });

  @override
  State<OriganizerUserListKermesseScreen> createState() => _OriganizerUserListKermesseScreenState();
}

class _OriganizerUserListKermesseScreenState extends State<OriganizerUserListKermesseScreen> {
  final Key _key = UniqueKey();

  final UserService _userService = UserService();

  Future<List<UserList>> _getAllUsers() async {
    ApiResponse<List<UserList>> response = await _userService.getAllUserByKermesseId(kermesseId: widget.kermesseId);
    if (response.error != null) {
      throw Exception(response.error);
    }
    return response.data!;
  }

  void _init() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ScreenList(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Kermesse User List",
          ),
          ElevatedButton(
            onPressed: () async {
              await context.push(
                OrganizerRoutes.kermesseUserInvitation,
                extra: {
                  'kermesseId': widget.kermesseId,
                },
              );
              _init();
            },
            child: const Text('Invite student'),
          ),
          Expanded(
            child: FutureBuilder<List<UserList>>(
              key: _key,
              future: _getAllUsers(),
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
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      UserList user = snapshot.data![index];
                      return ListTile(
                        title: Text(user.name),
                        subtitle: Text(user.role),
                      );
                    },
                  );
                }
                return const Center(
                  child: Text('No users found'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
