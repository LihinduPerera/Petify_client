import 'package:flutter/material.dart';
import 'package:petify/containers/user_pets_container.dart';
import 'package:petify/pages/sub_pages.dart/no_internet.dart';
import 'package:petify/providers/internet_connection_provider.dart';
import 'package:petify/styles/greeting.dart';
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    const Greeting(),
                    const SizedBox(
                      height: 10,
                    ),
                    const UserPetsContainer(),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
