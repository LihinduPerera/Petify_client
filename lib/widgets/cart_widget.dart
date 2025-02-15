import 'package:flutter/material.dart';
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
        builder: (context, value , child){
          if (value.isLoading) {
            return const Center(child: CircularProgressIndicator(),);
          } else {
            if (value.carts.isEmpty) {
              return const Center(child: Text("No Items in Cart"),);
            } else {
              if (value.products.isNotEmpty) {
                return Card(
                  child: Column(
                    children: [
                      Text("Item Count : ${value.totalQuantity}"),
                      SizedBox(height: 4,),
                      Text("Total : ${value.totalCost}")
                    ],
                  ),
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