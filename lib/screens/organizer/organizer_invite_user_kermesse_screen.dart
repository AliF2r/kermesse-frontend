import 'package:flutter/material.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/user_data.dart';
import 'package:kermesse_frontend/services/kermesse_service.dart';
import 'package:kermesse_frontend/services/user_service.dart';
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
      _refresh();
    }
  }

  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ScreenList(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Kermesse User Invite",
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
                        subtitle: Text(user.email),
                        leading: ElevatedButton(
                          onPressed: () async {
                            await _invite(user.id);
                          },
                          child: const Text('Invite'),
                        ),
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
