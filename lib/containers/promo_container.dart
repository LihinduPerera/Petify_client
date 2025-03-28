// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:petify/controllers/db_service.dart';
// import 'package:petify/models/promo_banners_model.dart';
// import 'package:shimmer/shimmer.dart';

// class PromoContainer extends StatefulWidget {
//   final bool routeToTheStore;
//   const PromoContainer({super.key, required this.routeToTheStore});

//   @override
//   State<PromoContainer> createState() => _PromoContainerState();
// }

// class _PromoContainerState extends State<PromoContainer> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<List<PromoBannersModel>>(
//       stream: DBService().readPromos(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Shimmer(
//             gradient: LinearGradient(
//               colors: [
//                 Color.fromARGB(255, 238, 238, 238),
//                 Color.fromARGB(255, 255, 255, 255)
//               ],
//             ),
//             child: SizedBox(
//               height: 300,
//               width: double.infinity,
//             ),
//           );
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else if (snapshot.hasData) {
//           List<PromoBannersModel> promos = snapshot.data!;
          
//           if (promos.isEmpty) {
//             return const SizedBox(); 
//           } else {
//             return CarouselSlider(
//               items: promos
//                   .map((promo) => GestureDetector(
//                         onTap: () {
//                           !widget.routeToTheStore
//                               ? Navigator.pushNamed(context, "/specific",
//                                   arguments: {"name": promo.category})
//                               : Navigator.pushReplacementNamed(
//                                   context, "/from_anyware_to_store");
//                         },
//                         child: Image.network(
//                           promo.image,
//                           fit: BoxFit.fitWidth,
//                         ),
//                       ))
//                   .toList(),
//               options: CarouselOptions(
//                 autoPlay: true,
//                 autoPlayInterval: const Duration(seconds: 5),
//                 aspectRatio: 16 / 8,
//                 viewportFraction: 5,
//                 enlargeCenterPage: false,
//                 scrollDirection: Axis.horizontal,
//               ),
//             );
//           }
//         } else {
//           return const SizedBox();
//         }
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:petify/providers/shop_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PromoContainer extends StatelessWidget {
  final bool routeToTheStore;
  const PromoContainer({super.key, required this.routeToTheStore});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopProvider>(
      builder: (context, shopProvider, child) {
        if (shopProvider.isLoading) {
          return const Shimmer(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 238, 238, 238),
                Color.fromARGB(255, 255, 255, 255),
              ],
            ),
            child: SizedBox(
              height: 300,
              width: double.infinity,
            ),
          );
        }

        if (shopProvider.promos.isEmpty) {
          return const SizedBox();
        }

        return CarouselSlider(
          items: shopProvider.promos.map((promo) {
            return GestureDetector(
              onTap: () {
                if (!routeToTheStore) {
                  Navigator.pushNamed(context, "/specific", arguments: {"name": promo.category});
                } else {
                  Navigator.pushReplacementNamed(context, "/from_anyware_to_store");
                }
              },
              child: Image.network(
                promo.image,
                fit: BoxFit.fitWidth,
              ),
            );
          }).toList(),
          options: CarouselOptions(
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            aspectRatio: 16 / 8,
            viewportFraction: 5,
            enlargeCenterPage: false,
            scrollDirection: Axis.horizontal,
          ),
        );
      },
    );
  }
}
