import 'package:flutter/foundation.dart'; // For compute
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
  late Future<List<Widget>> categoryContainerFuture;
  late Future<List<Widget>> homePageMakerContainerFuture;

  @override
  void initState() {
    super.initState();
    categoryContainerFuture = _loadCategoryContainer();
    homePageMakerContainerFuture = _loadHomePageMakerContainer();
  }

  // Load CategoryContainer asynchronously using an isolate
  Future<List<Widget>> _loadCategoryContainer() async {
    return await compute(_loadCategoryWidgets, null);
  }

  // Load HomePageMakerContainer asynchronously using an isolate
  Future<List<Widget>> _loadHomePageMakerContainer() async {
    return await compute(_loadHomePageWidgets, null);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFeeedf2),
      body: SafeArea(
        child: RepaintBoundary(
          child: ListView(
            cacheExtent: 3000,
            scrollDirection: Axis.vertical,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    RepaintBoundary(
                      child: Text(
                        "What are\n you looking for?",
                        style: AppStyles.headlineStyle1.copyWith(fontSize: 35),
                      ),
                    ),
                    const SizedBox(height: 10),
                    RepaintBoundary(child: _buildCategoryButtons(size)),
                    const SizedBox(height: 10),
                    const DefaultSearchBar(),
                    const SizedBox(height: 10),
                    const RepaintBoundary(child: PromoContainer()),
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
              FutureBuilder<List<Widget>>(
                future: categoryContainerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Text('Error loading categories'));
                  } else {
                    return RepaintBoundary(
                        child: Column(children: snapshot.data!));
                  }
                },
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<Widget>>(
                future: homePageMakerContainerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Text('Error loading home page maker'));
                  } else {
                    return RepaintBoundary(
                        child: Column(children: snapshot.data!));
                  }
                },
              ),
            ],
          ),
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

  // Simulate loading category widgets in a separate isolate
  static List<Widget> _loadCategoryWidgets(_) {
    return const [
      CategoryContainer(),
    ];
  }

  // Simulate loading home page maker widgets in a separate isolate
  static List<Widget> _loadHomePageWidgets(_) {
    return const [
      HomePageMakerContainer(),
    ];
  }
}
