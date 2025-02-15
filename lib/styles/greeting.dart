import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:petify/pages/sub_pages.dart/profile_page.dart';
import 'package:petify/providers/user_provider.dart';
import 'package:petify/styles/app_styles.dart';
import 'package:petify/styles/default_search_bar.dart';
import 'package:provider/provider.dart';

class Greeting extends StatelessWidget {
  const Greeting({super.key});

  @override
  Widget build(BuildContext context) {
    final int currentHour = DateTime.now().hour;

    String greetingMessage;
    if (currentHour < 12) {
      greetingMessage = "Good Morning";
    } else if (currentHour < 17) {
      greetingMessage = "Good Afternoon";
    } else {
      greetingMessage = "Good Evening";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(greetingMessage, style: AppStyles.headlineStyle3),
                  const SizedBox(
                    height: 5,
                  ),
                  Consumer<UserProvider>(
                    builder: (context, value, child) => Text(
                      value.name,
                      style: AppStyles.headlineStyle1,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(),
                    ),
                  );
                },
                child: Lottie.asset(
                    'assets/animations/male_profile_lottie.json',
                    height: 120,
                    fit: BoxFit.fill),
              )
            ],
          ),
          const DefaultSearchBar()
        ],
      ),
    );
  }
}
