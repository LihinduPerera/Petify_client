import 'package:flutter/material.dart';
import 'package:petify/consts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final GenerativeModel _model;
  late final ChatSession _chat;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _message = [];

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(model: 'gemini-1.5 flash', apiKey: GEMINI_API_KEY);
    _chat = _model.startChat();
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 750), curve: Curves.easeOutCirc));
  }

  Future<void> _sentChatMessage(String message) async {
    setState(() {
      _message.add(ChatMessage(text: message, isUser: true));
    });
    try {
      final response  = await _chat.sendMessage(Content.text(message));
      final text = response.text;

      setState(() {
        _message.add(ChatMessage(text: text!, isUser: false));
        _scrollDown();
      });
    } catch (e) {
      setState(() {
        _message.add(ChatMessage(text: "Error occured", isUser: false));
      });
    } finally {
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}

//Bubble widget
class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
