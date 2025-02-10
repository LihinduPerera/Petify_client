import 'package:flutter/material.dart';
import 'package:petify/controllers/auth_service.dart';
import 'package:petify/pages/sub_pages.dart/pet_health_page.dart';
import 'package:petify/pages/sub_pages.dart/profile_page.dart';
import 'package:petify/providers/cart_provider.dart';
import 'package:petify/providers/user_provider.dart';
import 'package:provider/provider.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFeeedf2),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            SizedBox(
              height: 15,
            ),
            Container(
              padding: EdgeInsets.only(left: 18),
              child: Text("More",
                  style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3b3b3b))),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile & Account Settings'),
              subtitle: Text('Manage your profile and pet details'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(),
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.health_and_safety),
              title: Text('Pet Health & Wellness Tracker'),
              subtitle: Text('Track pet health data and appointments'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PetHealthPage()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Pet Care Education Center'),
              subtitle: Text('Learn about proper pet care'),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.group),
              title: Text('Pet Community & Forum'),
              subtitle: Text('Join discussions with other pet owners'),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Customized Shopping Experience'),
              subtitle: Text('Get product recommendations'),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.card_giftcard),
              title: Text('Loyalty Program & Rewards'),
              subtitle: Text('Earn points and redeem rewards'),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Pet-Friendly Locations Finder'),
              subtitle: Text('Find pet-friendly restaurants, parks, etc.'),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications & Alerts'),
              subtitle: Text('Manage app notifications'),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('App Settings'),
              subtitle: Text('Manage app preferences'),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.feedback),
              title: Text('Give Feedback'),
              subtitle: Text('Share your thoughts with us'),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Log Out'),
              subtitle: Text('Sign out of your account'),
              onTap: () {}
            ),
          ],
        ),
      ),
    );
  }
}
