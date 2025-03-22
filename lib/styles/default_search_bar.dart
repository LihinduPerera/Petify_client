import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:petify/controllers/db_service.dart';
import 'package:petify/models/products_model.dart';

class DefaultSearchBar extends StatefulWidget {
  const DefaultSearchBar({super.key});

  @override
  State<DefaultSearchBar> createState() => _DefaultSearchBarState();
}

class _DefaultSearchBarState extends State<DefaultSearchBar> {
  TextEditingController _controller = TextEditingController();
  List<ProductsModel> searchResults = [];
  final DBService dbService = DBService();

  void _searchProducts(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults.clear();
      });
      return;
    }
    
    List<ProductsModel> results = await dbService.searchProductsByName(query);

    setState(() {
      searchResults = results;
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
              hintText: 'Search Products',
              hintStyle: const TextStyle(color: Color.fromARGB(255, 139, 137, 137), fontSize: 14),
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
                          child: Icon(FluentSystemIcons.ic_fluent_clear_formatting_filled),
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
              padding: const EdgeInsets.only(top: 10),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        "/view_product",
                        arguments: searchResults[index],
                      );
                    },
                    child: Card(
                      elevation: 2, 
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), 
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                searchResults[index].image,
                                width: 60, 
                                height: 60, 
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 12), 
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    searchResults[index].name,
                                    style: TextStyle(
                                      fontSize: 14, 
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '\$${searchResults[index].newPrice}',
                                    style: TextStyle(
                                      fontSize: 13, 
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  if (searchResults[index].oldPrice > 0)
                                    Text(
                                      '\$${searchResults[index].oldPrice}',
                                      style: TextStyle(
                                        fontSize: 12, 
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
