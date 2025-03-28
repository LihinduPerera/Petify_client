// import 'package:flutter/material.dart';
// import 'package:petify/containers/banner_container.dart';
// import 'package:petify/containers/zone_container.dart';
// import 'package:petify/controllers/db_service.dart';
// import 'package:petify/models/categories_model.dart';
// import 'package:petify/models/promo_banners_model.dart';
// import 'package:shimmer/shimmer.dart';

// class HomePageMakerContainer extends StatefulWidget {
//   const HomePageMakerContainer({super.key});

//   @override
//   State<HomePageMakerContainer> createState() => _HomePageMakerContainerState();
// }

// class _HomePageMakerContainerState extends State<HomePageMakerContainer> {
//   // A function to calculate the minimum length between two lists
//   int getMinLength(int a, int b) {
//     return a < b ? a : b;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<List<CategoriesModel>>(
//       stream: DBService().readCategories(),
//       builder: (context, categorySnapshot) {
//         if (categorySnapshot.connectionState == ConnectionState.waiting) {
//           return Shimmer(
//             gradient: const LinearGradient(
//               colors: [
//                 Color.fromARGB(255, 238, 238, 238),
//                 Color.fromARGB(255, 255, 255, 255)
//               ],
//             ),
//             child: const SizedBox(
//               height: 400,
//               width: double.infinity,
//             ),
//           );
//         }

//         if (categorySnapshot.hasError) {
//           return const Center(child: Text('Error loading categories'));
//         }

//         if (categorySnapshot.hasData) {
//           List<CategoriesModel> categories = categorySnapshot.data!;
//           if (categories.isEmpty) {
//             return const SizedBox();
//           }

//           return StreamBuilder<List<PromoBannersModel>>(
//             stream: DBService().readBanners(),
//             builder: (context, bannerSnapshot) {
//               if (bannerSnapshot.connectionState == ConnectionState.waiting) {
//                 return Shimmer(
//                   gradient: const LinearGradient(
//                     colors: [
//                       Color.fromARGB(255, 238, 238, 238),
//                       Color.fromARGB(255, 255, 255, 255)
//                     ],
//                   ),
//                   child: const SizedBox(
//                     height: 400,
//                     width: double.infinity,
//                   ),
//                 );
//               }

//               if (bannerSnapshot.hasError) {
//                 return const Center(child: Text('Error loading banners'));
//               }

//               if (bannerSnapshot.hasData) {
//                 List<PromoBannersModel> banners = bannerSnapshot.data!;
//                 if (banners.isEmpty) {
//                   return const SizedBox();
//                 }

//                 int minLength = getMinLength(categories.length, banners.length);

//                 return Column(
//                   children: List.generate(minLength, (i) {
//                     return Column(
//                       children: [
//                         ZoneContainer(category: categories[i].name),
//                         BannerContainer(
//                           image: banners[i].image,
//                           category: banners[i].category,
//                         ),
//                       ],
//                     );
//                   }),
//                 );
//               } else {
//                 return const SizedBox();
//               }
//             },
//           );
//         } else {
//           return const SizedBox();
//         }
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:petify/containers/banner_container.dart';
import 'package:petify/containers/zone_container.dart';
import 'package:petify/controllers/db_service.dart';
import 'package:petify/models/categories_model.dart';
import 'package:petify/models/promo_banners_model.dart';
import 'package:petify/providers/shop_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';

class HomePageMakerContainer extends StatefulWidget {
  const HomePageMakerContainer({super.key});

  @override
  State<HomePageMakerContainer> createState() => _HomePageMakerContainerState();
}

class _HomePageMakerContainerState extends State<HomePageMakerContainer> {
  // A function to calculate the minimum length between two lists
  int getMinLength(int a, int b) {
    return a < b ? a : b;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopProvider>( // Use Consumer to access ShopProvider
      builder: (context, provider, child) {
        List<CategoriesModel> categories = provider.categories;
        bool isLoading = provider.isLoading;

        if (isLoading) {
          return Shimmer(
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 238, 238, 238),
                Color.fromARGB(255, 255, 255, 255)
              ],
            ),
            child: const SizedBox(
              height: 400,
              width: double.infinity,
            ),
          );
        }

        if (categories.isEmpty) {
          return const SizedBox();
        }

        return StreamBuilder<List<PromoBannersModel>>(
          stream: DBService().readBanners(),
          builder: (context, bannerSnapshot) {
            if (bannerSnapshot.connectionState == ConnectionState.waiting) {
              return Shimmer(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 238, 238, 238),
                    Color.fromARGB(255, 255, 255, 255)
                  ],
                ),
                child: const SizedBox(
                  height: 400,
                  width: double.infinity,
                ),
              );
            }

            if (bannerSnapshot.hasError) {
              return const Center(child: Text('Error loading banners'));
            }

            if (bannerSnapshot.hasData) {
              List<PromoBannersModel> banners = bannerSnapshot.data!;
              if (banners.isEmpty) {
                return const SizedBox();
              }

              int minLength = getMinLength(categories.length, banners.length);

              return Column(
                children: List.generate(minLength, (i) {
                  return Column(
                    children: [
                      ZoneContainer(category: categories[i].name),
                      BannerContainer(
                        image: banners[i].image,
                        category: banners[i].category,
                      ),
                    ],
                  );
                }),
              );
            } else {
              return const SizedBox();
            }
          },
        );
      },
    );
  }
}

