import 'package:flutter/material.dart';
import 'package:petify/controllers/auth_service.dart';
import 'package:petify/providers/cart_provider.dart';
import 'package:petify/providers/user_pets_provider.dart';
import 'package:petify/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFeeedf2),
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        scrolledUnderElevation: 0,
        forceMaterialTransparency: true,
      ),
      body: Column(
        children: [
          Hero(
            tag: 'user-avatar',
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                image: const DecorationImage(
                  image: AssetImage("assets/images/user.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Consumer<UserProvider>(
            builder: (context, value, child) => Card(
              child: ListTile(
                title: Text(value.name),
                subtitle: Text(value.email),
                onTap: () {
                  Navigator.pushNamed(context, "/update_profile");
                },
                trailing: Icon(Icons.edit_outlined),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ListTile(
            title: Text("Orders"),
            leading: Icon(Icons.local_shipping_outlined),
            onTap: () {
              Navigator.pushNamed(context, "/orders");
            },
          ),
          Divider(
            thickness: 1,
            endIndent: 10,
            indent: 10,
          ),
          ListTile(
            title: Text("Discount & Offers"),
            leading: Icon(Icons.discount_outlined),
            onTap: () {
              Navigator.pushNamed(context, "/discount");
            },
          ),
          Divider(
            thickness: 1,
            endIndent: 10,
            indent: 10,
          ),
          ListTile(
            title: Text("Help & Support"),
            leading: Icon(Icons.support_agent),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Mail us at ecommerce@shop.com")));
            },
          ),
          Divider(
            thickness: 1,
            endIndent: 10,
            indent: 10,
          ),
          ListTile(
            title: Text("Logout"),
            leading: Icon(Icons.logout_outlined),
            onTap: () async {
              Provider.of<UserProvider>(context, listen: false)
                  .cancelProvider();
              Provider.of<CartProvider>(context, listen: false)
                  .cancelProvider();
              Provider.of<UserPetsProvider>(context, listen: false)
                  .cancelFetchingPets();

              await AuthService().logout();

              Navigator.pushNamedAndRemoveUntil(
                  context, "/login", (route) => true);
            },
          ),
        ],
      ),
    );
  }
}
