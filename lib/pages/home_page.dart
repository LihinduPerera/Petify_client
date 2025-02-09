// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:petify/containers/user_pets_container.dart';
import 'package:petify/styles/greeting.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFeeedf2),
      body: SafeArea(
        child: ListView(
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
    );
  }
}
