import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:petify/controllers/db_service.dart';
import 'package:petify/models/promo_banners_model.dart';
import 'package:shimmer/shimmer.dart';

class PromoContainer extends StatefulWidget {
  const PromoContainer({super.key});

  @override
  State<PromoContainer> createState() => _PromoContainerState();
}

class _PromoContainerState extends State<PromoContainer> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DbService().readPromos(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<PromoBannersModel> promos =
              PromoBannersModel.fromJsonList(snapshot.data!.docs);
          if (promos.isEmpty) {
            return const SizedBox();
          } else {
            return CarouselSlider(
                items: promos
                    .map((promo) => GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/specific",
                              arguments: {"name": promo.category});
                        },
                        child: Image.network(
                          promo.image,
                          fit: BoxFit.fitWidth,
                        )))
                    .toList(),
                options: CarouselOptions(
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 5),
                  aspectRatio: 16 / 8,
                  viewportFraction: 5,
                  enlargeCenterPage: false,
                  scrollDirection: Axis.horizontal,
                ));
          }
        } else {
          return const Shimmer(
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 238, 238, 238),
                Color.fromARGB(255, 255, 255, 255)
              ]),
              child: SizedBox(
                height: 300,
                width: double.infinity,
              ));
        }
      },
    );
  }
}
