import 'package:flutter/material.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/user_data.dart';
import 'package:kermesse_frontend/services/user_service.dart';
import 'package:kermesse_frontend/widgets/screen_list.dart';

class ParentChildListKermesseScreen extends StatefulWidget {
  final int kermesseId;

  const ParentChildListKermesseScreen({
    super.key,
    required this.kermesseId,
  });

  @override
  State<ParentChildListKermesseScreen> createState() => _ParentChildListKermesseScreenState();
}

class _ParentChildListKermesseScreenState extends State<ParentChildListKermesseScreen> {
  final Key _key = UniqueKey();

  final UserService _userService = UserService();

  Future<List<UserList>> _getAllChildren() async {
    ApiResponse<List<UserList>> response = await _userService.getAllChildren(kermesseId: widget.kermesseId);
    if (response.error != null) {
      throw Exception(response.error);
    }
    return response.data!;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenList(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Children List for kermesse",
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
                        subtitle: Text(child.role),
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
