
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/api/api_service.dart';
import 'package:kermesse_frontend/data/participation_data.dart';

class ParticipationService {
  final ApiService _apiService = ApiService();

  Future<ApiResponse<List<ParticipationList>>> getAllParticipations({int? kermesseId}) {
    return _apiService.get<List<ParticipationList>>("participations", { 'kermesse_id': kermesseId?.toString() ?? '' }, (data) {
            ParticipationListResponse participationListResponse = ParticipationListResponse.fromJson(data);
        return participationListResponse.participations;
      },
    );
  }

  Future<ApiResponse<ParticipationDetailsResponse>> details({
    required int participationId,
  }) async {
    return _apiService.get<ParticipationDetailsResponse>("participations/$participationId", null, (data) {
      ParticipationDetailsResponse participationDetailsResponse = ParticipationDetailsResponse.fromJson(data);
      return participationDetailsResponse;
      },
    );
  }

  Future<ApiResponse<Null>> create({
    required int kermesseId,
    required int standId,
    required int quantity,
  }) async {
    ParticipationCreateRequest body = ParticipationCreateRequest(
      standId: standId,
      kermesseId: kermesseId,
      quantity: quantity,
    );

    return _apiService.post("participations", body.toJson(), (_) => null);
  }

}
