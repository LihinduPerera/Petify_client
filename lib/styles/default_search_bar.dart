import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:petify/models/products_model.dart';  // Ensure this import is added

class DefaultSearchBar extends StatefulWidget {
  const DefaultSearchBar({super.key});

  @override
  State<DefaultSearchBar> createState() => _DefaultSearchBarState();
}

class _DefaultSearchBarState extends State<DefaultSearchBar> {
  TextEditingController _controller = TextEditingController();
  List<ProductsModel> searchResults = [];

  void _searchProducts(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults.clear();
      });
      return;
    }

    var productsSnapshot = await FirebaseFirestore.instance
        .collection('shop_products')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    setState(() {
      searchResults = ProductsModel.fromJsonList(productsSnapshot.docs);
    });
  }

  void _clearSearch() {
    _controller.clear();
    _searchProducts('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: const Color(0x0ff1d617).withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 0.0)
      ]),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            onChanged: _searchProducts,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromARGB(255, 255, 255, 255),
              contentPadding: const EdgeInsets.all(15),
              hintText: 'Search in store',
              hintStyle:
                  const TextStyle(color: Color(0xffDDDADA), fontSize: 14),
              prefixIcon: const Icon(
                FluentSystemIcons.ic_fluent_search_regular,
                color: Color(0xFFBFC285),
              ),
              suffixIcon: SizedBox(
                width: 100,
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const VerticalDivider(
                        color: Color.fromARGB(255, 0, 0, 0),
                        indent: 10,
                        endIndent: 10,
                        thickness: 0.2,
                      ),
                      GestureDetector(
                        onTap: _clearSearch,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(FluentSystemIcons
                              .ic_fluent_clear_formatting_filled),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          if (searchResults.isNotEmpty) ...[
            Container(
              height: 200,
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(searchResults[index].name),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        "/view_product",
                        arguments: searchResults[index],
                      );
                    },
                  );
                },
              ),
            ),
          ]
        ],
      ),
    );
  }
}
