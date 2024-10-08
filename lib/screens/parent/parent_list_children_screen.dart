import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/user_data.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/services/user_service.dart';
import 'package:kermesse_frontend/widgets/global_appBar.dart';
import 'package:kermesse_frontend/widgets/screen_list.dart';

class ParentListChildrenScreen extends StatefulWidget {
  const ParentListChildrenScreen({
    super.key,
  });

  @override
  State<ParentListChildrenScreen> createState() => _ParentListChildrenScreenState();
}

class _ParentListChildrenScreenState extends State<ParentListChildrenScreen> {
  final Key _key = UniqueKey();
  final UserService _userService = UserService();

  Future<List<UserList>> _getAllChildren() async {
    ApiResponse<List<UserList>> response = await _userService.getAllChildren();
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
      appBar: const GlobalAppBar(title: 'My Children'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await context.push(ParentRoutes.childInvitation);
                  _init();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90E2), // Soft blue
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Invite Child',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<UserList>>(
                  key: _key,
                  future: _getAllChildren(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          snapshot.error.toString(),
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return const Center(child: Text('No children found.'));
                      }

                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          UserList child = snapshot.data![index];
                          return _buildChildCard(child);
                        },
                      );
                    }
                    return const Center(child: Text('No users found'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChildCard(UserList child) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          child.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        subtitle: Text(
          'Balance: ${child.balance} jeton(s)',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey.shade400,
        ),
        onTap: () {
          context.push(
            ParentRoutes.childDetails,
            extra: {"userId": child.id},
          );
        },
      ),
    );
  }
}
