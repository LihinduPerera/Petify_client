import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:petify/pages/cart_page.dart';
import 'package:petify/pages/home_page.dart';
import 'package:petify/pages/more_page.dart';
import 'package:petify/pages/pet_delivery_page.dart';
import 'package:petify/pages/store_page.dart';

class pageSelection extends StatefulWidget {
  const pageSelection({super.key});

  @override
  State<pageSelection> createState() => _pageSelectionState();
}

class _pageSelectionState extends State<pageSelection> {
  final applicationPages = [
    const CartPage(),
    const ShopPage(),
    const homePage(),
    const PetDeliveryPage(),
    const MorePage()
  ];

  int selectedPageIndex = 2;

  void _pageSelection(int index) {
    setState(() {
      selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: 2,
        height: 54,
        buttonBackgroundColor: const Color(0xff92A3FD),
        backgroundColor: const Color(0xff92A3FD),
        color: const Color.fromARGB(255, 209, 196, 233),
        //animationDuration: Duration(milliseconds: 400),
        onTap: _pageSelection,
        items: const [
          Icon(
            FluentSystemIcons.ic_fluent_store_microsoft_filled,
            size: 27,
          ),
          Icon(
            Icons.store,
            size: 27,
          ),
          Icon(
            Icons.home,
            size: 27,
          ),
          Icon(
            Icons.delivery_dining_outlined,
            size: 27,
          ),
          Icon(
            FluentSystemIcons.ic_fluent_more_vertical_filled,
            size: 27,
          )
        ],
      ),
      body: applicationPages[selectedPageIndex],
    );
  }
}
