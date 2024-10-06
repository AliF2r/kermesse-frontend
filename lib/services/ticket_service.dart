

import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/api/api_service.dart';
import 'package:kermesse_frontend/data/ticket_data.dart';

class TicketService {
  final ApiService _apiService = ApiService();

  Future<ApiResponse<List<TicketList>>> getAllTickets() {
    return _apiService.get<List<TicketList>>("tickets", null, (data) {
        TicketListResponse ticketListResponse = TicketListResponse.fromJson(data);
        return ticketListResponse.tickets;
      },
    );
  }

  Future<ApiResponse<TicketDetailsResponse>> details({
    required int ticketId,
  }) async {
    return _apiService.get<TicketDetailsResponse>("tickets/$ticketId", null, (data) {
        TicketDetailsResponse ticketDetailsResponse = TicketDetailsResponse.fromJson(data);
        return ticketDetailsResponse;
      },
    );
  }

  Future<ApiResponse<Null>> create({
    required int tombolaId,
  }) async {
    TicketCreateRequest body = TicketCreateRequest(tombolaId: tombolaId);

    return _apiService.post("tickets", body.toJson(), (_) => null);
  }
}
