// import 'package:flutter/material.dart';
// import 'package:petify/containers/cart_container.dart';
// import 'package:petify/pages/sub_pages.dart/no_internet.dart';
// import 'package:petify/providers/cart_provider.dart';
// import 'package:petify/providers/internet_connection_provider.dart';
// import 'package:provider/provider.dart';

// class CartPage extends StatefulWidget {
//   const CartPage({super.key});

//   @override
//   State<CartPage> createState() => _CartPageState();
// }

// class _CartPageState extends State<CartPage> {
//   @override
//   Widget build(BuildContext context) {
//     final isConnectedToInternet = Provider.of<InternetConnectionProvider>(context).isConnectedToInternet;

//     return !isConnectedToInternet
//     ? const NoInternet()
//     : Scaffold(
//       backgroundColor: const Color(0xFFeeedf2),
//       appBar: AppBar(
//         title: const Text(
//           "Your Cart",
//           style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
//         ),
//         scrolledUnderElevation: 0,
//         forceMaterialTransparency: true,
//       ),
//       body: Consumer<CartProvider>(
//         builder: (context, value, child) {
//           if (value.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else {
//             if (value.carts.isEmpty) {
//               return const Center(child: Text("No items in cart"));
//             } else {
//               if (value.products.isNotEmpty) {
//                 return ListView.builder(
//                     itemCount: value.carts.length,
//                     itemBuilder: (context, index) {
//                       return CartContainer(
//                           image: value.products[index].image,
//                           name: value.products[index].name,
//                           new_price: value.products[index].newPrice,
//                           old_price: value.products[index].oldPrice,
//                           maxQuantity: value.products[index].maxQuantity,
//                           selectedQuantity: value.carts[index].quantity,
//                           productId: value.products[index].id);
//                     });
//               } else {
//                 return Text("No items in cart");
//               }
//             }
//           }
//         },
//       ),
//       bottomNavigationBar: Consumer<CartProvider>(
//         builder: (context, value, child) {
//           if (value.carts.isEmpty) {
//             return SizedBox();
//           } else {
//             return Container(
//               width: double.infinity,
//               height: 60,
//               padding: const EdgeInsets.all(8),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Total : Rs.${value.totalCost} ",
//                     style: const TextStyle(
//                         fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.pushNamed(context, "/checkout");
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color.fromARGB(255, 13, 64, 105),
//                       foregroundColor: const Color.fromARGB(255, 255, 255, 255),
//                     ),
//                     child: const Text("Procced to Checkout"),
//                   )
//                 ],
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:petify/containers/cart_container.dart';
import 'package:petify/models/cart_model.dart';
import 'package:petify/pages/sub_pages.dart/no_internet.dart';
import 'package:petify/providers/cart_provider.dart';
import 'package:petify/providers/internet_connection_provider.dart';
import 'package:petify/providers/user_provider.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<UserProvider, String>(
      selector: (context, userProvider) => userProvider.userId,
      builder: (context, userId, child) {
        return ChangeNotifierProvider<CartProvider>(
          create: (_) => CartProvider(userProvider: context.read<UserProvider>()),
          child: Scaffold(
            backgroundColor: const Color(0xFFeeedf2),
            appBar: AppBar(
              title: const Text(
                "Your Cart",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              scrolledUnderElevation: 0,
              forceMaterialTransparency: true,
            ),
            body: Consumer<InternetConnectionProvider>(
              builder: (context, internetProvider, child) {
                final isConnectedToInternet = internetProvider.isConnectedToInternet;

                if (!isConnectedToInternet) {
                  return const NoInternet();
                }

                return Consumer<CartProvider>(
                  builder: (context, cartProvider, child) {
                    if (cartProvider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      if (cartProvider.carts.isEmpty) {
                        return const Center(child: Text("No items in cart"));
                      } else {
                        if (cartProvider.products.isNotEmpty) {
                          return ListView.builder(
                            itemCount: cartProvider.carts.length,
                            itemBuilder: (context, index) {
                              return CartContainer(
                                image: cartProvider.products[index].image,
                                name: cartProvider.products[index].name,
                                new_price: cartProvider.products[index].newPrice,
                                old_price: cartProvider.products[index].oldPrice,
                                maxQuantity: cartProvider.products[index].maxQuantity,
                                selectedQuantity: cartProvider.carts[index].quantity,
                                productId: cartProvider.products[index].id,
                              );
                            },
                          );
                        } else {
                          return const Center(child: Text("No items in cart"));
                        }
                      }
                    }
                  },
                );
              },
            ),
            bottomNavigationBar: Selector<CartProvider, int>(
              selector: (context, cartProvider) => cartProvider.totalCost,
              builder: (context, totalCost, child) {
                return Selector<CartProvider, List<CartModel>>(
                  selector: (context, cartProvider) => cartProvider.carts,
                  builder: (context, carts, child) {
                    if (carts.isEmpty) {
                      return const SizedBox();
                    } else {
                      return Container(
                        width: double.infinity,
                        height: 60,
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total: Rs.$totalCost",
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, "/checkout");
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 13, 64, 105),
                                foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                              ),
                              child: const Text("Proceed to Checkout"),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
