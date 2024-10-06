

import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/api/api_service.dart';
import 'package:kermesse_frontend/data/kermesse_data.dart';
import 'package:kermesse_frontend/data/user_data.dart';

class KermesseService {

  final ApiService _apiService = ApiService();

  Future<ApiResponse<Null>> add({
    required String name,
    required String description,
  }) async {
    KermesseAddRequest body = KermesseAddRequest(name: name, description: description);
    return _apiService.post("kermesses", body.toJson(), (_) => null);
  }

  Future<ApiResponse<Null>> modify({
    required int id,
    required String name,
    required String description,
  }) async {
    KermesseModifyRequest body = KermesseModifyRequest(name: name, description: description);
    return _apiService.patch("kermesses/$id", body.toJson(), (_) => null);
  }

  Future<ApiResponse<KermesseDetailsResponse>> details({
    required int kermesseId,
  }) async {
    return _apiService.get<KermesseDetailsResponse>("kermesses/$kermesseId", null, (data) {
        KermesseDetailsResponse kermesseDetailsResponse =
        KermesseDetailsResponse.fromJson(data);
        return kermesseDetailsResponse;
      }
    );
  }


  Future<ApiResponse<List<KermesseList>>> getKermesseList() {
    return _apiService.get<List<KermesseList>>("kermesses", null, (data) {
        KermesseListResponse kermesseListResponse =
        KermesseListResponse.fromJson(data);
        return kermesseListResponse.kermesses;
      }
    );
  }

  Future<ApiResponse<Null>> complete({required int id}) async {
    return _apiService.patch("kermesses/$id/complete", "", (_) => null);
  }

  Future<ApiResponse<List<UserList>>> getAllStudentForKermesseInvitation({
    required int kermesseId,
  }) {
    return _apiService.get<List<UserList>>("kermesses/$kermesseId/users", null, (data) {
        UserListResponse userListResponse = UserListResponse.fromJson(data);
        return userListResponse.users;
      },
    );
  }

  Future<ApiResponse<Null>> inviteStudentForKermesse({
    required int userId,
    required int kermesseId,
  }) async {
    KermesseUserInvitationRequest body = KermesseUserInvitationRequest(userId: userId);
    return _apiService.patch("kermesses/$kermesseId/add-user", body.toJson(), (_) => null);
  }


  Future<ApiResponse<Null>> inviteStandForKermesse({
    required int kermesseId,
    required int standId,
  }) async {
    KermesseStandInvitationRequest body = KermesseStandInvitationRequest(standId: standId);
    return _apiService.patch("kermesses/$kermesseId/add-stand", body.toJson(), (_) => null);
  }

}

