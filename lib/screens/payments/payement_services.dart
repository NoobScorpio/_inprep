//import 'package:stripe_payment/stripe_payment.dart';

class StripeTransactionResponse {
  String message;
  bool success;
  StripeTransactionResponse({this.message, this.success});
}

class StripeService {
  static String apiBase = 'http://api.stripe.com//v1';
  static String secret = '';
  static init() {
//    StripePayment.setOptions(StripeOptions(
//        publishableKey:
//            "pk_test_51HBuzGGryK7xbWtA0dnJDm8xIUd30cVe2Rby0KhEAp66AZvEoRN2P1EMQotp8GwJ1y1wsARDeqAGsYBkX36bDhVB00RIO1r2Sv",
//        merchantId: "Test",
//        androidPayMode: 'test'));
  }

  static StripeTransactionResponse payViaExistingCard(
      {String amount, String currency, card}) {
    return StripeTransactionResponse(
        message: 'Transaction Successfull', success: true);
  }

//   static Future<StripeTransactionResponse> payViaNewCard(
//       {String amount, String currency}) async {
// //    try {
// //      var payementMethod = await StripePayment.paymentRequestWithCardForm(
// //          CardFormPaymentRequest());
// //      print(payementMethod);
// //      return StripeTransactionResponse(
// //          message: 'Transaction Successfull', success: true);
// //    } catch (e) {
// //      return StripeTransactionResponse(
// //          message: 'Transaction failed ${e.toString()}', success: true);
// //    }
//   }
}
