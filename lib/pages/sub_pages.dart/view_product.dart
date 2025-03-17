// import 'package:flutter/material.dart';
// import 'package:petify/contants/discount.dart';
// import 'package:petify/models/cart_model.dart';
// import 'package:petify/models/products_model.dart';
// import 'package:petify/providers/cart_provider.dart';
// import 'package:provider/provider.dart';

// class ViewProduct extends StatefulWidget {
//   const ViewProduct({super.key});

//   @override
//   State<ViewProduct> createState() => _ViewProductState();
// }

// class _ViewProductState extends State<ViewProduct> {
//   @override
//   Widget build(BuildContext context) {
//     final arguments =
//         ModalRoute.of(context)!.settings.arguments as ProductsModel;
//     return Scaffold(
//       backgroundColor: const Color(0xFFeeedf2),
//       appBar: AppBar(
//         title: const Text("Product Details"),
//         scrolledUnderElevation: 0,
//         forceMaterialTransparency: true,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Image.network(
//               arguments.image,
//               height: 300,
//               width: double.infinity,
//               fit: BoxFit.contain,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     arguments.name,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                         fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Row(
//                     children: [
//                       Text(
//                         "Rs. ${arguments.old_price}",
//                         style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w500,
//                             color: Color.fromARGB(255, 97, 97, 97),
//                             decoration: TextDecoration.lineThrough),
//                       ),
//                       const SizedBox(
//                         width: 10,
//                       ),
//                       Text(
//                         "Rs. ${arguments.new_price}",
//                         style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.w800,
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 10,
//                       ),
//                       const Icon(
//                         Icons.arrow_downward,
//                         color: Color.fromARGB(255, 76, 175, 79),
//                         size: 20,
//                       ),
//                       Text(
//                         "${discountPercent(arguments.old_price, arguments.new_price)} %",
//                         style: const TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Color.fromARGB(255, 76, 175, 79)),
//                       )
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   arguments.maxQuantity == 0
//                       ? const Text(
//                           "Out of Stock",
//                           style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                               color: Color.fromARGB(255, 244, 67, 54)),
//                         )
//                       : Text(
//                           "Only ${arguments.maxQuantity} left in stock",
//                           style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                               color: Color.fromARGB(255, 76, 175, 79)),
//                         ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     arguments.description,
//                     style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                         color: Color.fromARGB(255, 97, 97, 97)),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: arguments.maxQuantity != 0
//           ? Row(
//               children: [
//                 SizedBox(
//                   height: 60,
//                   width: MediaQuery.of(context).size.width * .5,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Provider.of<CartProvider>(context, listen: false)
//                           .addToCart(
//                               CartModel(productId: arguments.id, quantity: 1));
//                       ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text("Added to cart")));
//                     },
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor:
//                             const Color.fromARGB(255, 30, 136, 229),
//                         foregroundColor:
//                             const Color.fromARGB(255, 255, 255, 255),
//                         shape: const RoundedRectangleBorder()),
//                     child: const Text("Add to Cart"),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 60,
//                   width: MediaQuery.of(context).size.width * .5,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Provider.of<CartProvider>(context, listen: false)
//                           .addToCart(
//                               CartModel(productId: arguments.id, quantity: 1));
//                       Navigator.pushNamed(context, "/checkout");
//                     },
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor:
//                             const Color.fromARGB(255, 255, 255, 255),
//                         foregroundColor:
//                             const Color.fromARGB(255, 30, 136, 229),
//                         shape: const RoundedRectangleBorder()),
//                     child: const Text("Buy Now"),
//                   ),
//                 ),
//               ],
//             )
//           : SizedBox(),
//     );
//   }
// }
