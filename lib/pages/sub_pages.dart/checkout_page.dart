import 'package:flutter/material.dart';
import 'package:petify/providers/cart_provider.dart';
import 'package:petify/providers/user_provider.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int discount = 0;
  bool paymentSuccess = false;
  Map<String, dynamic> dataOfOrder = {};

  Future<void> mockPaymentProcess(int cost) async {
    try {
      await Future.delayed(Duration(seconds: 3), () {
        paymentSuccess = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment Failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    
    final userData = Provider.of<UserProvider>(context);
    final cartData = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Checkout",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        scrolledUnderElevation: 0,
        forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Delivery Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .65,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userData.name,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Text(userData.email),
                          Text(userData.address),
                          Text(userData.phone),
                        ],
                      ),
                    ),
                    Spacer(),
                    IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/update_profile");
                        },
                        icon: Icon(Icons.edit_outlined))
                  ],
                ),
              ),
              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 10),
              Text(
                "Total Quantity of Products: ${cartData.totalQuantity}",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "Sub Total: Rs ${cartData.totalCost}",
                style: TextStyle(fontSize: 16),
              ),
              Divider(),
              Text(
                "Extra Discount: - Rs $discount",
                style: TextStyle(fontSize: 16),
              ),
              Divider(),
              Text(
                "Total Payable: Rs ${cartData.totalCost - discount}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          child: Text("Proceed to Pay"),
          onPressed: () async {
            final user = Provider.of<UserProvider>(context, listen: false);
            if (user.address == "" ||
                user.phone == "" ||
                user.name == "" ||
                user.email == "") {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Please fill in your delivery details.")));
              return;
            }

            await mockPaymentProcess(cartData.totalCost - discount);

            if (paymentSuccess) {

              final cart = Provider.of<CartProvider>(context, listen: false);

              Map<String, dynamic> orderData = {
                "user_id": user.userId,
                "name": user.name,
                "email": user.email,
                "address": user.address,
                "phone": user.phone,
                "discount": discount,
                "total": cart.totalCost - discount,
                "status": "PAID",
                "created_at": DateTime.now().millisecondsSinceEpoch
              };

              dataOfOrder = orderData;

              print("Order Data: $dataOfOrder");

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  "Payment Successful",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.green,
              ));

              await cartData.emptyCart();

              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  "Payment Failed",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.redAccent,
              ));
            }
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, foregroundColor: Colors.white),
        ),
      ),
    );
  }
}
