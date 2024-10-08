import "dart:convert";
import "package:kermesse_frontend/api/api_constants.dart";
import "package:stripe_checkout/stripe_checkout.dart";
import "package:http/http.dart" as http;

class StripeService {
  // Base URL for Stripe Checkout session creation
  static const String _checkoutUrl = "https://api.stripe.com/v1/checkout/sessions";
  static const String _currency = "EUR";

  // Create a checkout session for Stripe payment
  Future<String> createCheckoutSession(int userId, int balance) async {
    final url = Uri.parse(_checkoutUrl);
    final price = (balance * 100).round();

    final Map<String, String> headers = {
      "Authorization": "Bearer ${ApiConstants.stripeSK}",
      "Content-Type": "application/x-www-form-urlencoded",
    };

    final String body = _buildRequestBody(userId, balance, price);

    final response = await http.post(url, headers: headers, body: body);
    final responseData = json.decode(response.body);

    if (response.statusCode == 200 && responseData.containsKey("id")) {
      return responseData["id"];
    } else {
      throw Exception("Failed to create Stripe Checkout session");
    }
  }

  // Build the request body for the checkout session
  String _buildRequestBody(int userId, int balance, int price) {
    return [
      "success_url=https://example.com/success",
      "mode=payment",
      "line_items[0][price_data][product_data][name]=$balance jeton(s)",
      "line_items[0][price_data][unit_amount]=$price",
      "line_items[0][price_data][currency]=$_currency",
      "line_items[0][quantity]=1",
      "metadata[user_id]=$userId",
      "metadata[balance]=$balance"
    ].join("&");
  }

  // Handle the payment checkout process
  Future<String> stripePaymentCheckout(
      int userId,
      int balance,
      dynamic context, {
        required Function onSuccess,
        required Function onCancel,
        required Function onError,
      }) async {
    try {
      final checkoutId = await createCheckoutSession(userId, balance);

      final result = await redirectToCheckout(
        context: context,
        sessionId: checkoutId,
        publishableKey: ApiConstants.stripePK,
        successUrl: "https://example.com/success",
        canceledUrl: "https://example.com/cancel",
      );

      return result.when(
        redirected: () => "Redirected to checkout",
        success: () => onSuccess(),
        canceled: () => onCancel(),
        error: (e) => onError(e),
      );
    } catch (e) {
      onError(e);
      return "Error occurred during checkout";
    }
  }
}
