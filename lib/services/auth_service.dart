import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/api/api_service.dart';
import 'package:kermesse_frontend/data/auth_data.dart';

class AuthService {
  ApiService apiService = ApiService();

  Future<ApiResponse<Null>> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    RegisterRequest body = RegisterRequest(
      name: name,
      email: email,
      password: password,
      role: role
    );

    return apiService.post(
      "register",
      body.toJson(),
          (_) => null,
    );
  }

  Future<ApiResponse<LoginResponse>> login({
    required String email,
    required String password,
  }) async {
    LoginRequest body = LoginRequest(
      email: email,
      password: password,
    );

    return apiService.post(
      "login",
      body.toJson(),
          (data) {
        LoginResponse signInResponse = LoginResponse.fromJson(data);
        return signInResponse;
      },
    );
  }

  Future<ApiResponse<CurrentUserResponse>> getCurrentUserResponse() async {
    return apiService.get<CurrentUserResponse>(
      "me",
      null,
          (data) {
            CurrentUserResponse currentUserResponse = CurrentUserResponse.fromJson(data);
        return currentUserResponse;
      },
    );
  }
}
