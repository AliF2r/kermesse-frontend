import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/user_data.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/services/user_service.dart';
import 'package:kermesse_frontend/widgets/app_theme_helper.dart';
import 'package:kermesse_frontend/widgets/custom_button.dart';
import 'package:kermesse_frontend/widgets/global_appBar.dart';
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
    return Scaffold(
      appBar: const GlobalAppBar(title: 'List of Users'),
      body: ScreenList(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Text(
                "Users: ",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CustomButton(
                    text: 'Invite Student',
                    onPressed: () async {
                      await context.push(
                        OrganizerRoutes.kermesseUserInvitation,
                        extra: {'kermesseId': widget.kermesseId},
                      );
                      _init();
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
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
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        UserList user = snapshot.data![index];
                        return _buildUserCard(user);
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
      ),
    );
  }

  Widget _buildUserCard(UserList user) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        leading: Icon(
          Icons.person,
          color: AppThemeHelper.getColorForRole(user.role),
          size: 38,
        ),
        title: Text(
          user.name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          user.role,
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}
