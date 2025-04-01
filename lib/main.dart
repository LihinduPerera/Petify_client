import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:permission_handler/permission_handler.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:petify/controllers/auth_service.dart';
import 'package:petify/controllers/notification_service.dart';
import 'package:petify/pages/cart_page.dart';
import 'package:petify/pages/login.dart';
import 'package:petify/pages/page_selection.dart';
import 'package:petify/pages/signup.dart';
import 'package:petify/pages/sub_pages.dart/chat_page.dart';
import 'package:petify/pages/sub_pages.dart/checkout_page.dart';
import 'package:petify/pages/sub_pages.dart/no_internet.dart';
import 'package:petify/pages/sub_pages.dart/pet_health_and_medical_tracker.dart';
import 'package:petify/pages/sub_pages.dart/specific_products.dart';
import 'package:petify/pages/sub_pages.dart/update_profile.dart';
import 'package:petify/pages/sub_pages.dart/view_product.dart';
import 'package:petify/providers/Notification_provider.dart';
import 'package:petify/providers/cart_provider.dart';
import 'package:petify/providers/internet_connection_provider.dart';
import 'package:petify/providers/medical_provider.dart';
import 'package:petify/providers/shop_provider.dart';
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
  
  //init Notifications
  await NotificationService.init();

  //Turn off auto rotating
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    _,
  ) {
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
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => InternetConnectionProvider(),
        ),
        ChangeNotifierProvider(create: (_) => UserPetsProvider()),
        ChangeNotifierProvider(create: (_) => MedicalProvider()),
        ChangeNotifierProvider(create: (context) => ShopProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Poppins'),
        routes: {
          "/": (context) => CheckUser(),
          "/page_selection": (context) => PageSelection(
                defaultPage: 2,
              ),
          "/login": (context) => LoginPage(),
          "/signup": (context) => SingupPage(),
          "/specific": (context) => SpecificProducts(),
          "/view_product": (context) => ViewProduct(),
          "/cart": (context) => CartPage(),
          "/update_profile": (context) => UpdateProfile(),
          "/pet_health_and_medical_tracker": (context) =>PetHealthAndMedicalTrackerPage(),
          "/from_anyware_to_store": (context) => PageSelection(defaultPage: 1),
          "/from_anyware_to_cart": (context) => PageSelection(defaultPage: 0),
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
    requestPermissions();
    _checkUserAndLoadData();
  }
  
  Future<void> requestPermissions() async {

  loc.PermissionStatus locationPermission = await Permission.location.request();
  if (locationPermission.isGranted) {
    print('Location permission granted');
  } else {
    print('Location permission denied');
  }

  ph.PermissionStatus notificationPermission = await Permission.notification.request();
  if (notificationPermission.isGranted) {
    print('Notification permission granted');
  } else {
    print('Notification permission denied');
  }
}

  Future<void> _checkUserAndLoadData() async {
    var user = await AuthService().getCurrentUser();

    if (user != null) {
      String userId = user['user_id'];

      await Provider.of<CartProvider>(context, listen: false)
          .readCartData(userId);
      await Provider.of<UserPetsProvider>(context, listen: false)
          .fetchUserPets(userId);

      await _waitForPetsToLoad();

      await Provider.of<MedicalProvider>(context, listen: false)
          .initializeMedicals(context);

      Navigator.pushReplacementNamed(context, "/page_selection");
    } else {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  Future<void> _waitForPetsToLoad() async {
    await Future.doWhile(() async {
      if (Provider.of<UserPetsProvider>(context, listen: false).isLoading) {
        await Future.delayed(Duration(milliseconds: 200));
        return true;
      }
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isConnectedToInternet =
        Provider.of<InternetConnectionProvider>(context).isConnectedToInternet;

    return !isConnectedToInternet
        ? const NoInternet()
        : Scaffold(
            backgroundColor: const Color(0xFFeeedf2),
            body: Consumer<UserPetsProvider>(
              builder: (context, userPetsProvider, child) {
                if (userPetsProvider.isLoading) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: Colors.red,
                  ));
                } else {
                  return Center(
                      child: CircularProgressIndicator(
                    color: Colors.red,
                  ));
                }
              },
            ),
          );
  }
}
