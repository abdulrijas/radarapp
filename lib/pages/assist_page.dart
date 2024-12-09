import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AssistPage extends StatefulWidget {
  const AssistPage({Key? key}) : super(key: key);

  @override
  _AssistPageState createState() => _AssistPageState();
}

class _AssistPageState extends State<AssistPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages =
      []; // Stores messages as a list of maps

  final String chatbotEndpoint =
      'http://10.0.2.2:5002/'; // Ensure "http://" prefix
  final ScrollController scrollController = ScrollController();

  void _scrollToBottom() {
    if (!mounted) return;
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> sendQuestion() async {
    String question = _messageController.text.trim();
    _messageController.clear();
    if (question.isEmpty) return;

    setState(() {
      _messages.add({"sender": "user", "text": question});
    });
    _scrollToBottom();

    try {
      final uri = Uri.parse(chatbotEndpoint);
      var response = await http.post(
        uri,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'question': question},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var answer = data['answer'];
        setState(() {
          _messages.add({"sender": "bot", "text": answer});
        });
        _scrollToBottom();
      } else {
        print("Failed to send question. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: Image.asset(
            'assets/images/dashb.jpg', // Replace with your image path
            fit: BoxFit.cover, // Ensures the image covers the entire screen
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent, // Makes scaffold transparent
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(10.0),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final isUser = message["sender"] == "user";

                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5.0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            gradient: isUser
                                ? const LinearGradient(colors: [
                                    Colors.blueAccent,
                                    Colors.lightBlue,
                                  ])
                                : const LinearGradient(colors: [
                                    Colors.grey,
                                    Colors.grey,
                                  ]),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(15.0),
                              topRight: const Radius.circular(15.0),
                              bottomLeft: Radius.circular(isUser ? 15.0 : 0.0),
                              bottomRight: Radius.circular(isUser ? 0.0 : 15.0),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4.0,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                          child: Text(
                            message["text"]!,
                            style: TextStyle(
                              color: isUser ? Colors.white : Colors.black,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(height: 1.0),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Type your message...',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            suffixIcon: const Icon(Icons.keyboard),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Material(
                        shape: const CircleBorder(),
                        color: Colors.blue,
                        elevation: 3.0,
                        child: IconButton(
                          onPressed: () async => await sendQuestion(),
                          icon: const Icon(Icons.send),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
