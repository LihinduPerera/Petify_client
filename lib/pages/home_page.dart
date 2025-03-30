import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:petify/containers/medical_container.dart';
import 'package:petify/containers/promo_container.dart';
import 'package:petify/containers/user_pets_container.dart';
import 'package:petify/pages/sub_pages.dart/no_internet.dart';
import 'package:petify/providers/internet_connection_provider.dart';
import 'package:petify/styles/greeting.dart';
import 'package:petify/widgets/cart_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                        height: 25,
                      ),
                      const UserPetsContainer(),
                      const SizedBox(
                        height: 25,
                      ),
                      const MedicalContainer(
                        defineHeight: 260,
                        defineWeight: 250,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
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
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 175,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, "/chatbot");
                                  },
                                  child: Container(
                                    height: 150,
                                    decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 193, 127, 231).withOpacity(0.4),
                                        borderRadius: BorderRadius.circular(20)),
                                    child: Row(
                                      children: [
                                        Lottie.asset(
                                            "assets/animations/mr_bot.json"),
                                        Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Text(
                                            "Ask Anything !! \n mr.BOT is here",
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(context, "/from_anyware_to_store");
                                  },
                                  child: Container(
                                    height: 175,
                                    child: Row(
                                      children: [
                                        Lottie.asset(
                                            'assets/animations/shop_now.json'),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 10),
                                          child: Text("Get Crazy Discounts \n SHOP NOW !", textAlign: TextAlign.center,),
                                        )
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 155, 253, 146).withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(20)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ]),
              ),
            ),
          );
  }
}
