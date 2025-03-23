import 'package:flutter/material.dart';
import 'package:petify/containers/promo_container.dart';
import 'package:petify/containers/user_pets_container.dart';
import 'package:petify/pages/sub_pages.dart/no_internet.dart';
import 'package:petify/providers/internet_connection_provider.dart';
import 'package:petify/styles/greeting.dart';
import 'package:petify/widgets/cart_widget.dart';
import 'package:provider/provider.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  Widget build(BuildContext context) {
    final isConnectedToInternet =
        Provider.of<InternetConnectionProvider>(context).isConnectedToInternet;

    return !isConnectedToInternet
        ? const NoInternet()
        : Scaffold(
            backgroundColor: const Color(0xFFeeedf2),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Greeting(),
                      const SizedBox(
                        height: 10,
                      ),
                      const UserPetsContainer(),
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 10, top: 18),
                      //   child: TrackersContainer(height: 170, isAddable: false, petName: "",),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, top: 10, bottom: 10),
                        child: Row(
                          children: [
                            const Icon(Icons.storefront_outlined,
                                color: Color.fromARGB(255, 92, 81, 245)),
                            SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "Check The Store",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 150,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            Container(
                              height: 150,
                              width: 250,
                              child: PromoContainer(
                                routeToTheStore: true,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 250,
                              child: CartWidget(),
                            ),
                          ],
                        ),
                      ),
                    ]),
              ),
            ),
          );
  }
}
