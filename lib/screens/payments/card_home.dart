// import 'package:flutter/material.dart';
// import 'package:indeed_app/screens/payments/existing_cards.dart';
// import 'package:square_in_app_payments/models.dart';
// import 'package:square_in_app_payments/in_app_payments.dart';
//
// class CardHome extends StatefulWidget {
//   @override
//   _CardHomeState createState() => _CardHomeState();
// }
//
// class _CardHomeState extends State<CardHome> {
//   @override
//   void initState() {
//
//     super.initState();
//     //StripeService.init();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final primaryColor = Theme.of(context).primaryColor;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Select payment method'),
//       ),
//       body: ListView.separated(
//           itemBuilder: (context, index) {
//             Icon icon;
//             Text text;
//             switch (index) {
//               case 0:
//                 icon = Icon(
//                   Icons.add_circle,
//                   color: primaryColor,
//                 );
//                 text = Text('Pay via new card');
//                 break;
//               case 1:
//                 icon = Icon(
//                   Icons.credit_card,
//                   color: primaryColor,
//                 );
//                 text = Text('Pay via existing card');
//                 break;
//             }
//             return InkWell(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: ListTile(
//                   leading: icon,
//                   title: text,
//                   onTap: () {
//                     onPressed(context, index);
//                   },
//                 ),
//               ),
//             );
//           },
//           separatorBuilder: (context, index) => Divider(
//                 color: primaryColor,
//               ),
//           itemCount: 2),
//     );
//   }
//
//   onPressed(BuildContext context, int index) async {
//     switch (index) {
//       case 0:
// //        var response = await StripeService.payViaNewCard(
// //          amount: '150',
// //          currency: 'USD',
// //        );
// //        if (response.success == true) {
// //          Scaffold.of(context).showSnackBar(SnackBar(
// //            content: Text(response.message),
// //          ));
// //        }
// //        Stripe.apiKey =
// //            "sk_test_51HBuzGGryK7xbWtAlVvoRvhG5GmEvXCbxZzmCpRlzpwKw6FGtOndKU2xK3fxG4MNu6O0HMoimswLefyRNDCbCLyf00If1QbCAZ";
//         //Navigator.push(context, MaterialPageRoute(builder: (_) => StripePay()));
//         await InAppPayments.setSquareApplicationId(
//             'sq0idp-n5Z9Q0kuWYBJgQQ7Grx1zw');
//         await InAppPayments.startCardEntryFlow(
//             onCardNonceRequestSuccess: (CardDetails result) {
//               try {
//                 print('success');
// //                var chargeResult =
// //                    PaymentsRepository.actuallyMakeTheCharge(result.nonce);
// //                if (chargeResult != 'Success!')
// //                  throw new StateError(chargeResult);
//                 InAppPayments.completeCardEntry(
//                   onCardEntryComplete: () {},
//                 );
//               } catch (ex) {
//                 InAppPayments.showCardNonceProcessingError(ex.toString());
//               }
//             },
//             onCardEntryCancel: () {});
//         break;
//       case 1:
//         Navigator.push(
//             context, MaterialPageRoute(builder: (_) => ExistingCards()));
//         break;
//     }
//   }
// }
