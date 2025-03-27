import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:petify/controllers/auth_service.dart';
import 'package:petify/pages/sub_pages.dart/profile_page.dart';
import 'package:petify/providers/cart_provider.dart';
import 'package:petify/providers/medical_provider.dart';
import 'package:petify/providers/user_pets_provider.dart';
import 'package:petify/providers/user_provider.dart';
import 'package:provider/provider.dart';

class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this)
      ..duration = Duration(milliseconds: 9000)
      ..repeat(reverse: false);

    _animationController.addListener(() {});
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFeeedf2),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              Container(
                child: Row(
                  children: [
                    Container(
                      child: Lottie.asset(
                          'assets/animations/more_lottie_in_more.json',
                          height: 70,
                          fit: BoxFit.contain,
                          controller: _animationController,
                          repeat: true,
                          animate: true,
                          frameRate: FrameRate(60)),
                    ),
                    Text("More",
                        style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3b3b3b))),
                  ],
                ),
              ),
              Divider(),
              ListTile(
                title: Row(
                  children: [
                    Container(
                      child: Lottie.asset(
                          'assets/animations/easter_profile.json',
                          height: 110,
                          fit: BoxFit.fitHeight,
                          controller: _animationController,
                          repeat: true,
                          animate: true,
                          frameRate: FrameRate(60)),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text('Profile & Account Settings'),
                  ],
                ),
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
              SizedBox(
                height: 10,
              ),
              Divider(),
              ListTile(
                  title: Row(
                    children: [
                      Container(
                        child: Lottie.asset(
                            'assets/animations/health_lottie_for_homepage.json',
                            height: 55,
                            fit: BoxFit.contain,
                            controller: _animationController,
                            repeat: true,
                            animate: true,
                            frameRate: FrameRate(60)),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text('Pet Health & medical Tracker'),
                    ],
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                        context, "/pet_health_and_medical_tracker");
                  }),
              Divider(),
              ListTile(
                title: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FluentSystemIcons.ic_fluent_chat_filled,
                        color: const Color.fromARGB(255, 196, 131, 250),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Ask from Mr.Bot PETIFY'),
                    ],
                  ),
                ),
                subtitle: Container(
                  child: Lottie.asset('assets/animations/mr_bot.json',
                      height: 200,
                      fit: BoxFit.fitHeight,
                      controller: _animationController,
                      repeat: true,
                      animate: true,
                      frameRate: FrameRate(60)),
                ),
                onTap: () {
                  Navigator.pushNamed(context, "/chatbot");
                },
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.notifications,
                    color: const Color.fromARGB(255, 131, 250, 137)),
                title: Text('Notifications & Alerts'),
                onTap: () {},
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.settings,
                    color: const Color.fromARGB(255, 131, 139, 250)),
                title: Text('App Settings'),
                subtitle: Text('Manage app preferences'),
                onTap: () {},
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.feedback,
                    color: const Color.fromARGB(255, 250, 131, 131)),
                title: Text('Give Feedback'),
                subtitle: Text('Share your thoughts with us'),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: Duration(milliseconds: 6000),
                      content:
                          Text("Mail me @lihindu.indudunu.perera@gmail.com")));
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Log Out'),
                subtitle: Text('Sign out of your account'),
                onTap: () async {
                  Provider.of<UserProvider>(context, listen: false)
                      .cancelProvider();
                  Provider.of<UserPetsProvider>(context, listen: false)
                      .cancelProvider();
                  Provider.of<MedicalProvider>(context, listen: false)
                      .cancelProvider();
                  Provider.of<CartProvider>(context, listen: false)
                      .cancelProvider();

                  await AuthService().logout();

                  Navigator.pushNamedAndRemoveUntil(
                      context, "/login", (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
