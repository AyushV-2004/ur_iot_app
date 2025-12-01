import 'dart:convert';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ur_iot_app/main.dart'; // contains GEMINI_API_KEY

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final ChatUser _currentUser =
   ChatUser(id: "1", firstName: "User", lastName: "");

  final ChatUser _botUser =
   ChatUser(id: "2", firstName: "Gemini", lastName: "");

  final List<ChatMessage> _messages = [];
  final List<ChatUser> _typingUsers = [];

  static const String _model = "gemini-1.5-flash-latest";
  static const String _endpoint =
      "https://generativelanguage.googleapis.com/v1/models/$_model:generateContent";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("C H A T B O T"),
        centerTitle: true,
      ),
      body: DashChat(
        messages: _messages,
        currentUser: _currentUser,
        typingUsers: _typingUsers,
        onSend: (m) => _sendMsg(m),
        messageOptions: const MessageOptions(
          currentUserContainerColor: Colors.black,
          containerColor: Colors.blueAccent,
          textColor: Colors.white,
        ),
      ),
    );
  }

  Future<void> _sendMsg(ChatMessage message) async {
    setState(() {
      _messages.insert(0, message);
      _typingUsers.add(_botUser);
    });

    // Full conversation prompt
    final fullPrompt = _messages.reversed
        .map((m) => "${m.user.firstName}: ${m.text}")
        .join("\n");

    final body = {
      "contents": [
        {
          "parts": [
            {"text": fullPrompt}
          ]
        }
      ]
    };

    try {
      final response = await http.post(
        Uri.parse("$_endpoint?key=$GEMINI_API_KEY"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final reply = data["candidates"]?[0]?["content"]?[0]?["parts"]?[0]
        ?["text"] ??
            "No response";

        setState(() {
          _messages.insert(
            0,
            ChatMessage(
              user: _botUser,
              createdAt: DateTime.now(),
              text: reply,
            ),
          );
        });
      } else {
        setState(() {
          _messages.insert(
            0,
            ChatMessage(
              user: _botUser,
              createdAt: DateTime.now(),
              text: "Error: ${response.body}",
            ),
          );
        });
      }
    } catch (e) {
      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            user: _botUser,
            createdAt: DateTime.now(),
            text: "Error: $e",
          ),
        );
      });
    }

    setState(() {
      _typingUsers.remove(_botUser);
    });
  }
}
