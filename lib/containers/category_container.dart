import 'package:flutter/material.dart';
import 'package:petify/controllers/db_service.dart';
import 'package:petify/models/categories_model.dart';
import 'package:shimmer/shimmer.dart';

class CategoryContainer extends StatefulWidget {
  const CategoryContainer({super.key});

  @override
  State<CategoryContainer> createState() => _CategoryContainerState();
}

class _CategoryContainerState extends State<CategoryContainer> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CategoriesModel>>(
      stream: DBService().readCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Shimmer(
            gradient: const LinearGradient(colors: [
              Color.fromARGB(255, 238, 238, 238),
              Color.fromARGB(255, 255, 255, 255),
            ]),
            child: SizedBox(
              height: 90,
              width: double.infinity,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          List<CategoriesModel> categories = snapshot.data!;
          if (categories.isEmpty) {
            return const SizedBox();
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories
                    .map((cat) =>
                        CategoryButton(imagepath: cat.image, name: cat.name))
                    .toList(),
              ),
            );
          }
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String imagepath, name;
  const CategoryButton({super.key, required this.imagepath, required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        "/specific",
        arguments: {"name": name},
      ),
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(4),
        height: 95,
        width: 95,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 238, 238, 238),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              imagepath,
              height: 50,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "${name.substring(0, 1).toUpperCase()}${name.substring(1)}",
            ),
          ],
        ),
      ),
    );
  }
}