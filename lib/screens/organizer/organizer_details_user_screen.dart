import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/user_data.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/services/user_service.dart';
import 'package:kermesse_frontend/widgets/screen.dart';


class OriganizerUserDetailsScreen extends StatefulWidget {
  final int userId;

  const OriganizerUserDetailsScreen({
    super.key,
    required this.userId,
  });

  @override
  State<OriganizerUserDetailsScreen> createState() => _OriganizerUserDetailsScreenState();
}

class _OriganizerUserDetailsScreenState extends State<OriganizerUserDetailsScreen> {
  final Key _key = UniqueKey();

  final UserService _userService = UserService();

  Future<UserList> _getUser() async {
    ApiResponse<UserList> response = await _userService.details(userId: widget.userId,);
    if (response.error != null) {
      throw Exception(response.error);
    }
    return response.data!;
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Profile",
          ),
          FutureBuilder<UserList>(
            key: _key,
            future: _getUser(),
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
                    ElevatedButton(
                      onPressed: () {
                        context.push(
                          OrganizerRoutes.userModify,
                        );
                      },
                      child: const Text("change password"),
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
