import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:petify/providers/feedback_provider.dart';
import 'package:petify/models/feedback_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _feedbackController = TextEditingController();

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 750),
            curve: Curves.easeOutCirc));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFeeedf2),
      appBar: AppBar(
        title: const Text("Give Feedback"),
        backgroundColor: const Color(0xFFeeedf2),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 1.8,
                child: Lottie.asset("assets/animations/feedback.json"),
              ),
            ],
          ),
          const Text(
            "Share your thoughts with us",
            style: TextStyle(fontSize: 18),
          ),
          Consumer<FeedbackProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: provider.feedbacks.length,
                    itemBuilder: (context, index) {
                      FeedbackModel feedback = provider.feedbacks[index];
                      return FeedbackBubble(
                        feedback: feedback.feedback,
                        time: feedback.time,
                        feedbackId: feedback.id,
                        onDelete: () {
                          provider.deleteFeedback(feedback.id);
                        },
                      );
                    },
                  ),
                );
              }
            },
          ),
          Consumer<FeedbackProvider>(
            builder: (context, provider, child) {
              return Container(
                color: const Color(0xFFeeedf2),
                child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 20, top: 5, left: 15, right: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _feedbackController,
                          decoration: InputDecoration(
                            hintText: "Write your feedback here",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: const Color.fromARGB(255, 243, 33, 243),
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (_feedbackController.text.isNotEmpty) {
                            FeedbackModel newFeedback = FeedbackModel(
                              id: DateTime.now().toString(),
                              user: provider.userId,
                              feedback: _feedbackController.text,
                              time: DateTime.now(),
                            );
                            provider.addFeedback(newFeedback);
                            _feedbackController.clear();
                            _scrollDown();
                          }
                        },
                        icon: Icon(
                          FluentSystemIcons.ic_fluent_send_filled,
                          color: const Color.fromARGB(255, 243, 33, 243),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class FeedbackBubble extends StatelessWidget {
  final String feedback;
  final DateTime time;
  final String feedbackId;
  final VoidCallback onDelete;

  const FeedbackBubble({
    Key? key,
    required this.feedback,
    required this.time,
    required this.feedbackId,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      alignment: Alignment.centerRight,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.25),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.zero,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              feedback,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              DateFormat.yMMMd().add_jm().format(time),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
                size: 18,
              ),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
