import 'package:flutter/material.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/user_data.dart';
import 'package:kermesse_frontend/services/kermesse_service.dart';
import 'package:kermesse_frontend/services/user_service.dart';
import 'package:kermesse_frontend/widgets/app_theme_helper.dart';
import 'package:kermesse_frontend/widgets/confirmation_dialog.dart';
import 'package:kermesse_frontend/widgets/global_appBar.dart';
import 'package:kermesse_frontend/widgets/screen_list.dart';


class OrganizerInviteUserKermesseScreen extends StatefulWidget {
  final int kermesseId;

  const OrganizerInviteUserKermesseScreen({
    super.key,
    required this.kermesseId,
  });

  @override
  State<OrganizerInviteUserKermesseScreen> createState() =>
      _OrganizerInviteUserKermesseScreenState();
}

class _OrganizerInviteUserKermesseScreenState extends State<OrganizerInviteUserKermesseScreen> {
  final Key _key = UniqueKey();

  final KermesseService _kermesseService = KermesseService();

  Future<List<UserList>> _getAllUsers() async {
    ApiResponse<List<UserList>> response = await _kermesseService.getAllStudentForKermesseInvitation(kermesseId: widget.kermesseId);
    if (response.error != null) {
      throw Exception(response.error);
    }
    return response.data!;
  }


  Future<void> _showConfirmationDialog(BuildContext context, int userId) async {
    showConfirmationDialog(
      context,
      'Are you sure you want to invite this user?',
          () => _invite(userId),
    );
  }


  Future<void> _invite(int userId) async {
    ApiResponse<Null> response = await _kermesseService.inviteStudentForKermesse(userId: userId, kermesseId: widget.kermesseId);
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
      _init();
    }
  }

  void _init() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlobalAppBar(title: 'Kermesse Invitation'),
      body: ScreenList(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Text(
                "Users:",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
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
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        UserList user = snapshot.data![index];
                        return _buildUserCard(user, _invite);
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

  Widget _buildUserCard(UserList user, Function(int) onInvite) {
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
        onTap: () async {
          await _showConfirmationDialog(context, user.id);
        },
      ),
    );
  }
}
