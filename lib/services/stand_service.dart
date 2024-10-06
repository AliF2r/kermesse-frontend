
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/api/api_service.dart';
import 'package:kermesse_frontend/data/stand_data.dart';

class StandService {
  final ApiService _apiService = ApiService();

  Future<ApiResponse<List<StandList>>> getAllStands({
    bool? isReady,
    int? kermesseId,
  }) {
    Map<String, String> params = {};
    if (isReady != null) {
      params['is_ready'] = isReady.toString();
    }
    if (kermesseId != null) {
      params['kermesse_id'] = kermesseId.toString();
    }
    return _apiService.get<List<StandList>>("stands", params, (data) {
        StandListResponse standListResponse = StandListResponse.fromJson(data);
        return standListResponse.stands;
      },
    );
  }
}
