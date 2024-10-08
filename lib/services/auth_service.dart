import 'package:flutter/material.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/api/api_service.dart';
import 'package:kermesse_frontend/data/auth_data.dart';
import 'package:kermesse_frontend/services/webSocket_service.dart';

class AuthService {
  ApiService apiService = ApiService();
  WebSocketService _webSocketService = WebSocketService();


  Future<ApiResponse<Null>> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    RegisterRequest body = RegisterRequest(name: name, email: email, password: password, role: role);
    return apiService.post("register", body.toJson(), (_) => null);
  }

  Future<ApiResponse<LoginResponse>> login({
    required String email,
    required String password,
  }) async {
    LoginRequest body = LoginRequest(email: email, password: password);
    return apiService.post("login", body.toJson(), (data) {
        LoginResponse signInResponse = LoginResponse.fromJson(data);
        if (signInResponse.role == "ORGANIZER") {
          _webSocketService.connectWebSocket(signInResponse.id);
        }
        return signInResponse;
      }
    );
  }

  Future<ApiResponse<CurrentUserResponse>> getCurrentUserResponse() async {
    return apiService.get<CurrentUserResponse>("me", null, (data) {
            CurrentUserResponse currentUserResponse = CurrentUserResponse.fromJson(data);
            if (currentUserResponse.role == "ORGANIZER") {
              _webSocketService.connectWebSocket(currentUserResponse.id);
            }
        return currentUserResponse;
      }
    );
  }

  Future<ApiResponse<Null>> updateAuthUserBalance(BuildContext context) async {
    try {
      final response = await getCurrentUserResponse();
      if (response.error != null) {
        return ApiResponse<Null>(error: response.error);
      }
      CurrentUserResponse data = response.data!;
      //Provider.of<AuthProvider>(context, listen: false).setBalance(data.balance);
      return ApiResponse<Null>(data: null);
    } catch (error) {
      return ApiResponse<Null>(error: error.toString());
    }
  }


}
