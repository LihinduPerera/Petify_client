import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
          Container(
            child: Lottie.asset('assets/animations/groud_profile_lottie.json',
                height: 250, fit: BoxFit.contain),
          ),
          Consumer<UserProvider>(
            builder: (context, value, child) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                color: const Color.fromARGB(255, 246, 180, 255).withOpacity(0.4),
                elevation: 8,
                shadowColor: Colors.blueGrey.withOpacity(0.4),
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
          ),
          SizedBox(
            height: 30,
          ),
          Divider(),
          ListTile(
            title: Text("Orders"),
            leading: Icon(Icons.local_shipping_outlined,
            color: const Color.fromARGB(255, 131, 139, 250)),
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
            title: Text("Discount & Offers",),
            leading: Icon(Icons.discount_outlined,
            color: const Color.fromARGB(255, 122, 250, 122)),
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
            leading: Icon(Icons.support_agent,
            color: const Color.fromARGB(255, 248, 121, 121)),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: Duration(milliseconds: 6000),
                  content: Text("Mail me @lihindu.indudunu.perera@gmail.com")));
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
