import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/api/api_service.dart';
import 'package:kermesse_frontend/data/tombola_data.dart';

class TombolaService {
  final ApiService _apiService = ApiService();

  Future<ApiResponse<List<TombolaList>>> getAllTombolas({int? kermesseId}) {
    return _apiService.get<List<TombolaList>>("tombolas", { 'kermesse_id': kermesseId?.toString() ?? '' }, (data) {
        TombolaListResponse tombolaListResponse = TombolaListResponse.fromJson(data);
        return tombolaListResponse.tombolas;
      },
    );
  }

  Future<ApiResponse<Null>> create({
    required int kermesseId,
    required String name,
    required String prize,
    required int price,
  }) async {
    TombolaCreateRequest body = TombolaCreateRequest(
      kermesseId: kermesseId,
      name: name,
      prize: prize,
      price: price,
    );

    return _apiService.post("tombolas", body.toJson(), (_) => null);
  }

  Future<ApiResponse<TombolaDetailsResponse>> getDetails({
    required int tombolaId,
  }) async {
    return _apiService.get<TombolaDetailsResponse>("tombolas/$tombolaId", null, (data) {
        TombolaDetailsResponse tombolaDetailsResponse = TombolaDetailsResponse.fromJson(data);
        return tombolaDetailsResponse;
      },
    );
  }

  Future<ApiResponse<Null>> finishTombolaAndSetWinner({required int tombolaId}) async {
    return _apiService.patch("tombolas/$tombolaId/finish-winner", "", (_) => null);
  }

  Future<ApiResponse<Null>> modifyTombola({
    required int id,
    required String name,
    required String prize,
    required int price,
  }) async {
    TombolaModifyRequest body = TombolaModifyRequest(
      name: name,
      prize: prize,
      price: price,
    );

    return _apiService.patch("tombolas/$id", body.toJson(), (_) => null);
  }

}
