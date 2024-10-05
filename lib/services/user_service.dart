
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




}
