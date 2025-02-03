import 'package:flutter/material.dart';
import 'package:petify/containers/category_container.dart';
import 'package:petify/containers/home_page_store_maker_container.dart';
import 'package:petify/containers/promo_container.dart';
import 'package:petify/styles/app_styles.dart';
import 'package:petify/styles/default_search_bar.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFeeedf2),
      body: SafeArea(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Text(
                    "What are\n you looking for?",
                    style: AppStyles.headlineStyle1.copyWith(fontSize: 35),
                  ),
                  const SizedBox(height: 10),
                  _buildCategoryButtons(size),
                  const SizedBox(height: 10),
                  const DefaultSearchBar(),
                  const SizedBox(height: 10),
                  const PromoContainer(),
                  const Text(
                    "Categories 🐶",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            CategoryContainer(),
            HomePageMakerContainer(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButtons(Size size) {
    final List<Map<String, String>> categories = [
      {'label': 'Food', 'route': '/specific', 'argument': 'cat foods'},
      {'label': 'Toys', 'route': '/specific', 'argument': 'pet toys'},
      {'label': 'Collars', 'route': '/specific', 'argument': 'collars'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: categories.map((category) {
        return _buildCategoryButton(
          size,
          category['label']!,
          category['route']!,
          category['argument']!,
        );
      }).toList(),
    );
  }

  Widget _buildCategoryButton(
    Size size,
    String label,
    String route,
    String argument,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      width: size.width * 0.25,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(context, route,
              arguments: {"name": argument}),
          child: Text(label),
        ),
      ),
    );
  }
}
