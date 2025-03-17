import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:petify/pages/cart_page.dart';
import 'package:petify/pages/home_page.dart';
import 'package:petify/pages/more_page.dart';
import 'package:petify/pages/pet_ride.dart';
import 'package:petify/pages/store_page.dart';

class pageSelection extends StatefulWidget {
  final int defaultPage;
  const pageSelection({super.key, required this.defaultPage});

  @override
  State<pageSelection> createState() => _pageSelectionState();
}

class _pageSelectionState extends State<pageSelection> {

  final applicationPages = [
    // const CartPage(),
    // const StorePage(),
    // const homePage(),
    // const PetRidePage(),
    // const MorePage()
  ];

  late int selectedPageIndex;

  @override
  void initState() {
    selectedPageIndex = widget.defaultPage;
    super.initState();
  }

  void _pageSelection(int index) {
    setState(() {
      selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFeeedf2),
      bottomNavigationBar: Container(
        height: 75,
        decoration: BoxDecoration(
          color: Color(0xFFeeedf2),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              spreadRadius: 3,
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          currentIndex: selectedPageIndex,
          onTap: _pageSelection,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color.fromARGB(255, 121, 143, 255),
          unselectedItemColor: Colors.grey[600],
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(FluentSystemIcons.ic_fluent_store_microsoft_filled),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.store),
              label: 'Store',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.delivery_dining_outlined),
              label: 'Pet Ride',
            ),
            BottomNavigationBarItem(
              icon: Icon(FluentSystemIcons.ic_fluent_more_filled),
              label: 'More',
            ),
          ],
        ),
      ),
      body: applicationPages[selectedPageIndex],
    );
  }
}
