import 'dart:math';

import 'package:flutter/material.dart';
import 'package:petify/constants/discount.dart';
import 'package:petify/controllers/db_service.dart';
import 'package:petify/models/products_model.dart';
import 'package:shimmer/shimmer.dart';

class ZoneContainer extends StatefulWidget {
  final String category;
  const ZoneContainer({super.key, required this.category});

  @override
  State<ZoneContainer> createState() => _ZoneContainerState();
}

class _ZoneContainerState extends State<ZoneContainer> {
  Widget specialQuote({required int price, required int dis}) {
    int random = Random().nextInt(2);

    List<String> quotes = ["Starting at RS.$price", "Get upto $dis% off"];

    return Text(
      quotes[random],
      style: const TextStyle(color: Color.fromARGB(255, 76, 175, 79)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductsModel>>(
      future: DBService().getProductsByCategory(widget.category),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Shimmer(
            gradient: const LinearGradient(colors: [
              Color.fromARGB(255, 238, 238, 238),
              Color.fromARGB(255, 255, 255, 255)
            ]),
            child: Container(
              height: 400,
              width: double.infinity,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          List<ProductsModel> products = snapshot.data!;
          if (products.isEmpty) {
            return const Center(
              child: Text("No Products Found"),
            );
          } else {
            return Container(
              margin: const EdgeInsets.all(4),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              color: const Color.fromARGB(255, 232, 245, 233),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        Text(
                          widget.category.substring(0, 1).toUpperCase() + widget.category.substring(1),
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/specific", arguments: {"name": widget.category});
                          },
                          child: const Text(
                            "See all",
                            style: TextStyle(
                                color: Color.fromARGB(255, 33, 149, 243), fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // show max 4 products
                  Wrap(
                    spacing: 4,
                    children: [
                      for (int i = 0; i < (products.length > 4 ? 4 : products.length); i++)
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/view_product", arguments: products[i]);
                          },
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * .43,
                            padding: const EdgeInsets.all(8),
                            height: 180,
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: const Color.fromARGB(255, 224, 224, 224)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Image.network(
                                    products[i].image,
                                    height: 120,
                                  ),
                                ),
                                Text(
                                  products[i].name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                ),
                                specialQuote(
                                    price: products[i].newPrice,
                                    dis: int.parse(discountPercent(products[i].oldPrice, products[i].newPrice)))
                              ],
                            ),
                          ),
                        )
                    ],
                  )
                ],
              ),
            );
          }
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}
