import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:petify/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CartWidget extends StatefulWidget {
  const CartWidget({super.key});

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<CartProvider>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (value.carts.isEmpty) {
              return const Center(
                child: Text("No Items in Cart"),
              );
            } else {
              if (value.products.isNotEmpty) {
                return GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 215, 253),
                        // color: const Color.fromARGB(255, 177, 198, 255),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color.fromARGB(255, 255, 101, 247),
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Lottie.asset('assets/animations/cart_lottie.json',
                            height: 145,fit: BoxFit.fitWidth),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Your Cart", style: TextStyle(fontSize: 19),),
                              SizedBox(height: 10,),
                              Text("Items: ${value.totalQuantity}"
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text("Total : ${value.totalCost}"
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, "/from_anyware_to_cart");
                  },
                );
              } else {
                return Text("No items in cart");
              }
            }
          }
        },
      ),
    );
  }
}
