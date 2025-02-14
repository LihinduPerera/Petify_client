import 'package:flutter/material.dart';
import 'package:petify/contants/discount.dart';
import 'package:petify/controllers/db_service.dart';
import 'package:petify/models/products_model.dart';

class SpecificProducts extends StatefulWidget {
  const SpecificProducts({super.key});

  @override
  State<SpecificProducts> createState() => _SpecificProductsState();
}

class _SpecificProductsState extends State<SpecificProducts> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      backgroundColor: Color(0xFFeeedf2),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        forceMaterialTransparency: true,
        title: Text(
            "${args["name"].substring(0, 1).toUpperCase()}${args["name"].substring(1)} "),
      ),
      body: StreamBuilder(
        stream: DbService().readProducts(args["name"]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ProductsModel> products =
                ProductsModel.fromJsonList(snapshot.data!.docs);
            if (products.isEmpty) {
              return const Center(
                child: Text("No products found."),
              );
            } else {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 6.0,
                  mainAxisSpacing: 15,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/view_product",
                          arguments: product);
                    },
                    child: Card(
                      // margin: EdgeInsets.only(left: 10, right: 10),
                      color: const Color.fromARGB(255, 224, 224, 224),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 224, 224, 224),
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                        image: NetworkImage(product.image),
                                        fit: BoxFit.fitHeight)),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  "Rs.${product.old_price}",
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.lineThrough),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  "Rs.${product.new_price}",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                const Icon(
                                  Icons.arrow_downward,
                                  color: Color.fromARGB(255, 76, 175, 79),
                                  size: 14,
                                ),
                                Text(
                                  "${discountPercent(product.old_price, product.new_price)}%",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 76, 175, 79)),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
