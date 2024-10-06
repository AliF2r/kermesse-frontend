
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

  Future<ApiResponse<StandDetailsResponse>> details({
    required int standId,
  }) async {
    return _apiService.get<StandDetailsResponse>("stands/$standId", null, (data) {
        StandDetailsResponse standDetailsResponse = StandDetailsResponse.fromJson(data);
        return standDetailsResponse;
      },
    );
  }

  Future<ApiResponse<Null>> addStand({
    required String category,
    required String name,
    required String description,
    required int price,
    required int stock,
  }) async {
    StandAddRequest body = StandAddRequest(
      category: category,
      name: name,
      description: description,
      price: price,
      stock: stock,
    );

    return _apiService.post("stands", body.toJson(), (_) => null);
  }


  Future<ApiResponse<StandDetailsResponse>> getOwnStand() async {
    return _apiService.get<StandDetailsResponse>("stands/owner", null, (data) {
        StandDetailsResponse standDetailsResponse = StandDetailsResponse.fromJson(data);
        return standDetailsResponse;
      },
    );
  }

  Future<ApiResponse<Null>> modifyStand({
    required String name,
    required String description,
    required int price,
    required int stock,
  }) async {
    StandEditRequest body = StandEditRequest(
      name: name,
      description: description,
      price: price,
      stock: stock,
    );

    return _apiService.patch("stands/modify", body.toJson(), (_) => null);
  }

}
