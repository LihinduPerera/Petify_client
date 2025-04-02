import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFeeedf2),
      appBar: AppBar(title: Text("Give Feedback"),backgroundColor: const Color(0xFFeeedf2),),
      body:  SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 1.8,
                  child: Lottie.asset(
                    "assets/animations/feedback.json"
                  ),
                ),
              ],
            ),
            Text(
              "Share your thoughts with us",
              style: TextStyle(
                fontSize: 18
              ),
            ),
          ],
        ),
      ),
    );
  }
}