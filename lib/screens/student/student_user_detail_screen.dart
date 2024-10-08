import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/user_data.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/services/user_service.dart';
import 'package:kermesse_frontend/widgets/app_theme_helper.dart';
import 'package:kermesse_frontend/widgets/confirmation_dialog.dart';
import 'package:kermesse_frontend/widgets/custom_button.dart';
import 'package:kermesse_frontend/widgets/global_appBar.dart';
import 'package:kermesse_frontend/widgets/logout.dart';

class StudentUserDetailsScreen extends StatefulWidget {
  final int userId;

  const StudentUserDetailsScreen({
    super.key,
    required this.userId,
  });

  @override
  State<StudentUserDetailsScreen> createState() => _StudentUserDetailsScreenState();
}

class _StudentUserDetailsScreenState extends State<StudentUserDetailsScreen> {
  final Key _key = UniqueKey();

  final UserService _userService = UserService();

  Future<UserList> _getDetails() async {
    ApiResponse<UserList> response = await _userService.details(userId: widget.userId);
    if (response.error != null) {
      throw Exception(response.error);
    }
    return response.data!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlobalAppBar(title: 'Profile Details'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<UserList>(
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
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }
              if (snapshot.hasData) {
                UserList user = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [

                        Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.only(top: 40), // Create space for the circular widget
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 40), // Space below the circle
                                _buildDetailRow('Name:', user.name),
                                _buildDetailRow('Email:', user.email),
                                _buildDetailRow('Balance:', '${user.balance} jeton(s)'),
                              ],
                            ),
                          ),
                        ),

                        Positioned(
                          top: 0,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: AppThemeHelper.getColorForRole(user.role),
                            child: Text(
                              '${user.totalPoints} pts',
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Spacer(),
                    CustomButton(
                      text: 'Update Password',
                      onPressed: () {
                        context.push(StudentRoutes.userModify);
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomButton(
                      text: 'Buy Jeton',
                      onPressed: () {
                        context.push(ParentRoutes.userModifyBalance);
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomButton(
                      text: 'Logout',
                      onPressed: () {
                        showConfirmationDialog(
                          context,
                          'Are you sure you want to logout?',
                              () => performLogout(context),
                        );
                      },
                    ),
                  ],
                );
              }
              return const Center(
                child: Text('Something went wrong'),
              );
            },
          ),
        ),
      ),
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
