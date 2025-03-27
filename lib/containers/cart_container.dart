import 'package:flutter/material.dart';
import 'package:petify/constants/discount.dart';
import 'package:petify/models/cart_model.dart';
import 'package:petify/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CartContainer extends StatefulWidget {
  final String image, name, productId;
  final int new_price, old_price, maxQuantity, selectedQuantity;
  const CartContainer(
      {super.key,
      required this.image,
      required this.name,
      required this.productId,
      required this.new_price,
      required this.old_price,
      required this.maxQuantity,
      required this.selectedQuantity});

  @override
  State<CartContainer> createState() => _CartContainerState();
}

class _CartContainerState extends State<CartContainer> {
  int count = 1;

  increaseCount(int max) async {
    if (count >= max) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Maximum Quantity reached"),
      ));
      return;
    } else {
      final userId = Provider.of<CartProvider>(context, listen: false).userId;
      Provider.of<CartProvider>(context, listen: false).addToCart(CartModel(
          productId: widget.productId, quantity: count, userId: userId));
      setState(() {
        count++;
      });
    }
  }

  decreaseCount() async {
    if (count > 1) {
      Provider.of<CartProvider>(context, listen: false)
          .decreaseCount(widget.productId);
      setState(() {
        count--;
      });
    }
  }

  @override
  void initState() {
    count = widget.selectedQuantity;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        // color: Colors.grey.shade300,
        color: const Color.fromARGB(255, 216, 184, 241).withOpacity(0.4),
        elevation: 8,
        shadowColor: Colors.blueGrey.withOpacity(0.4),
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 80,
                      width: 80,
                      child: Image.network(widget.image)),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            child: Text(
                          widget.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        )),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              "Rs.${widget.old_price}",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.lineThrough),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "Rs.${widget.new_price}",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Icon(
                              Icons.arrow_downward,
                              color: const Color.fromARGB(255, 26, 156, 31),
                              size: 20,
                            ),
                            Text(
                              "${discountPercent(widget.old_price, widget.new_price)}%",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 46, 199, 51)),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        Provider.of<CartProvider>(context, listen: false)
                            .deleteItem(widget.productId);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: const Color.fromARGB(255, 219, 90, 88),
                      ))
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Text(
                    "Quantity:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 161, 157, 218),
                    ),
                    child: IconButton(
                        onPressed: () async {
                          increaseCount(widget.maxQuantity);
                        },
                        icon: Icon(Icons.add)),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "$count",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 161, 157, 218),
                    ),
                    child: IconButton(
                        onPressed: () async {
                          decreaseCount();
                        },
                        icon: Icon(Icons.remove)),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Spacer(),
                  Text("Total:"),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Rs.${widget.new_price * count}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
