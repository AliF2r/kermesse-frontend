
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/api/api_service.dart';
import 'package:kermesse_frontend/data/user_data.dart';

class UserService {
  final ApiService _apiService = ApiService();

  Future<ApiResponse<List<UserList>>> getAllUserByKermesseId({int? kermesseId}) {
    return _apiService.get<List<UserList>>("users", { 'kermesse_id': kermesseId?.toString() ?? '' }, (data) {
        UserListResponse userListResponse = UserListResponse.fromJson(data);
        return userListResponse.users;
      },
    );
  }

  Future<ApiResponse<UserList>> details({
    required int userId,
  }) async {
    return _apiService.get<UserList>("users/$userId", null, (data) {
            UserList userDetailsResponse = UserList.fromJson(data);
        return userDetailsResponse;
      },
    );
  }

  Future<ApiResponse<Null>> modifyPassword({
    required int userId,
    required String password,
    required String newPassword,
  }) async {
    UserModifyPasswordRequest body = UserModifyPasswordRequest(
      password: password,
      newPassword: newPassword,
    );

    return _apiService.patch("users/password/$userId", body.toJson(), (_) => null);
  }

  Future<ApiResponse<List<UserList>>> getAllChildren({
    int? kermesseId,
  }) {
    Map<String, String> params = {};
    if (kermesseId != null) {
      params['kermesse_id'] = kermesseId.toString();
    }
    return _apiService.get<List<UserList>>("users/students", params, (data) {
        UserListResponse userListResponse = UserListResponse.fromJson(data);
        return userListResponse.users;
      },
    );
  }


  Future<ApiResponse<Null>> sendBalance({
    required int studentId,
    required int balance,
  }) async {
    UserBalanceSendRequest body = UserBalanceSendRequest(
      studentId: studentId,
      balance: balance,
    );
    return _apiService.patch("users/send-jeton", body.toJson(), (_) => null);
  }

  Future<ApiResponse<Null>> inviteChild({
    required String name,
    required String email,
  }) async {
    ChildInvitationRequest body = ChildInvitationRequest(
      name: name,
      email: email,
    );
    return _apiService.post("users/invite-child", body.toJson(), (_) => null);
  }
}
