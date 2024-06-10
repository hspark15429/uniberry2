import 'dart:convert';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart'; // 실제 SDK 경로에 맞게 조정
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class DMChatGPTPage extends StatefulWidget {
  const DMChatGPTPage({super.key});

  @override
  _DMChatGPTPageState createState() => _DMChatGPTPageState();
}

class _DMChatGPTPageState extends State<DMChatGPTPage> {
  final TextEditingController _controller = TextEditingController();
  List<String> messages = [];

  late OpenAI openAI;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _sendMessage() async {
    final userMessage = _controller.text;
    if (userMessage.trim().isEmpty) {
      return;
    }
    setState(() {
      messages.add('You: $userMessage');
      _controller.clear();
    });
    
   // OpenAI GPT API 호출
    final response = await fetchGPTResponse(userMessage);

    // API 응답 처리
    if (response != null) {
      setState(() {
        messages.add('GPT: $response');
      });
    }
  }

  Future<String?> fetchGPTResponse(String prompt) async {
    const apiKey = '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';
    final url = Uri.parse('https://api.openai.com/v1/completions');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
      'model': 'text-davinci-003',
      'prompt': prompt,
      'max_tokens': 1000,
      'temperature': 0,
      'top_p': 1,
      'frequency_penalty': 0,
      'presence_penalty': 0,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

    } else {
      print('Failed to fetch response: ${response.body}');
      return null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with UniberryAI', style: TextStyle(color: Colors.white)),
       backgroundColor: const Color(0xFFFF6B6B), // 코랄 색상을 RGB 코드로 정의
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) => Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: index % 2 == 0 ? Colors.blue[50] : Colors.green[50],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(messages[index], style: const TextStyle(fontSize: 16)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Type a message',
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: const CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 0, 21, 58),
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
