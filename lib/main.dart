import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petify/controllers/auth_service.dart';
import 'package:petify/pages/cart_page.dart';
import 'package:petify/pages/login.dart';
import 'package:petify/pages/page_selection.dart';
import 'package:petify/pages/signup.dart';
import 'package:petify/pages/sub_pages.dart/chat_page.dart';
import 'package:petify/pages/sub_pages.dart/checkout_page.dart';
import 'package:petify/pages/sub_pages.dart/pet_health_and_medical_tracker.dart';
import 'package:petify/pages/sub_pages.dart/specific_products.dart';
import 'package:petify/pages/sub_pages.dart/update_profile.dart';
import 'package:petify/pages/sub_pages.dart/view_product.dart';
import 'package:petify/providers/cart_provider.dart';
import 'package:petify/providers/internet_connection_provider.dart';
import 'package:petify/providers/medical_provider.dart';
import 'package:petify/providers/user_pets_provider.dart';
import 'package:petify/providers/user_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Hide the status bar globally
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: const Color(0xFFeeedf2),
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_,) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => InternetConnectionProvider(),
        ),
        ChangeNotifierProvider(create: (_) => UserPetsProvider(userProvider: UserProvider())),
        ChangeNotifierProvider(create: (_) => MedicalProvider(userPetsProvider: UserPetsProvider(userProvider: UserProvider())))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Poppins'),
        routes: {
          "/": (context) => CheckUser(),
          "/page_selection": (context) => pageSelection(
                defaultPage: 2,
              ),
          "/login": (context) => LoginPage(),
          "/signup": (context) => SingupPage(),
          "/specific": (context) => SpecificProducts(),
          "/view_product": (context) => ViewProduct(),
          "/cart": (context) => CartPage(),
          "/update_profile": (context) => UpdateProfile(),
          "/pet_health_and_medical_tracker": (context) =>
              PetHealthAndMedicalTrackerPage(),
          "/from_anyware_to_store": (context) => pageSelection(defaultPage: 1),
          "/from_anyware_to_cart": (context) => pageSelection(defaultPage: 0),
          "/checkout": (context) => CheckoutPage(),
          "/chatbot": (context) => ChatPage(),
        },
      ),
    );
  }
}

class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  @override
  void initState() {
    super.initState();
    AuthService().getCurrentUser().then((user) {
      if (user != null) {

        String userId = user['user_id'];

        Provider.of<CartProvider>(context, listen: false).readCartData(userId);

        Navigator.pushReplacementNamed(context, "/page_selection");
      } else {
        Navigator.pushReplacementNamed(context, "/login");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
