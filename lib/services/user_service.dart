
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

  Future<ApiResponse<Null>> modify({
    required int userId,
    required String password,
    required String newPassword,
  }) async {
    UserModifyPasswordRequest body = UserModifyPasswordRequest(
      password: password,
      newPassword: newPassword,
    );

    return _apiService.patch("users/$userId", body.toJson(), (_) => null,);
  }


}
