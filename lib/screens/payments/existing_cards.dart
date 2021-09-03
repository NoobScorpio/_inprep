// import 'package:flutter/material.dart';
// import 'package:flutter_credit_card/credit_card_widget.dart';
//
// class ExistingCards extends StatefulWidget {
//   @override
//   _ExistingCardsState createState() => _ExistingCardsState();
// }
//
// class _ExistingCardsState extends State<ExistingCards> {
//   List cards = [
//     {
//       'cardNumber': '4242424242424242',
//       'expiryDate': '04/24',
//       'cardHolderName': 'Muhammad Ali Adam',
//       'cvvCode': '424',
//       'showBackView': false
//     },
//     {
//       'cardNumber': '3566002020360505',
//       'expiryDate': '04/23',
//       'cardHolderName': 'Tracer',
//       'cvvCode': '123',
//       'showBackView': false
//     }
//   ];
//   @override
//   Widget build(BuildContext context) {
//     final primaryColor = Theme.of(context).primaryColor;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Existing Cards'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Container(
//           child: ListView.builder(
//               itemCount: cards.length,
//               itemBuilder: (context, index) {
//                 var card = cards[index];
//                 print(cards[0]);
//                 return InkWell(
//                   onTap: () {
//                     payViaExistingCard(context, card[index], primaryColor);
//                   },
//                   child: CreditCardWidget(
//                     cardNumber:
//                         cards[index]['cardNumber'] ?? '3566002020360505',
//                     expiryDate: cards[index]['expiryDate'],
//                     cardHolderName: cards[index]['cardHolderName'],
//                     cvvCode: cards[index]['cvvCode'],
//                     showBackView:
//                         false, //true when you want to show cvv(back) view
//                   ),
//                 );
//               }),
//         ),
//       ),
//     );
//   }
//
//   void payViaExistingCard(context, card, color) {
// //    var response = StripeService.payViaExistingCard(
// //        amount: '150', currency: 'USD', card: card);
// //    if (response.success == true) {
// //      Scaffold.of(context)
// //          .showSnackBar(SnackBar(
// //            content: Text(response.message),
// //          ))
// //          .closed
// //          .then((value) => Navigator.pop(context));
// //    }
//   }
// }
