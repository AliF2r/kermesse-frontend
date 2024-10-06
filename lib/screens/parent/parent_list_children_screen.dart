import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/user_data.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/services/user_service.dart';
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
    return ScreenList(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "child List",
          ),
          ElevatedButton(
            onPressed: () async {
              await context.push(
                ParentRoutes.childInvitation,
              );
              _init();
            },
            child: const Text('Invite child'),
          ),
          Expanded(
            child: FutureBuilder<List<UserList>>(
              key: _key,
              future: _getAllChildren(),
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
                      UserList child = snapshot.data![index];
                      return ListTile(
                        title: Text(child.name),
                        subtitle: Text(child.balance.toString()),
                        onTap: () {
                          context.push(
                            ParentRoutes.childDetails,
                            extra: {
                              "userId": child.id,
                            },
                          );
                        },
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
