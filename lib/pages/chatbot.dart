import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Color color = Colors.white;

  List<Message> messages = [
    Message(
      text: "Hi Jane!",
      date: DateTime.now().subtract(const Duration(days: 3, minutes: 1)),
      isSendByMe: false,
    ),
    Message(
      text: "How can I assist you?",
      date: DateTime.now().subtract(const Duration(days: 3, minutes: 1)),
      isSendByMe: false,
    ),
    Message(
      text: "What is depression",
      date: DateTime.now().subtract(const Duration(days: 3, minutes: 1)),
      isSendByMe: true,
    ),
    Message(
      text: "  .... ",
      date: DateTime.now().subtract(const Duration(days: 3, minutes: 1)),
      isSendByMe: false,
    ),
    // Additional messages...
  ];

  @override
  void initState() {
    super.initState();
    _scrollToBottom();
  }


  //get response from the chatbot
  Future<void> getResponse(String message) async {
    final response = await http.get(Uri.parse('https://api.abc.com/chatbot?message=$message'));
    if (response.statusCode == 200 || response.statusCode == 201) {
      var decodedResponse = jsonDecode(response.body);
    } else {
      throw Exception('Failed to load response');
    }
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void changeColor() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: color,
              onColorChanged: (Color newColor) {
                setState(() {
                  color = newColor;
                });
              },
              availableColors: const [
                Colors.red,
                Colors.pink,
                Colors.purple,
                Colors.deepPurple,
                Colors.indigo,
                Colors.blue,
                Colors.lightBlue,
                Colors.cyan,
                Colors.teal,
                Colors.green,
                Colors.lightGreen,
                Colors.lime,
                Colors.yellow,
                Colors.amber,
                Colors.orange,
                Colors.deepOrange,
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Got it'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70.0),
          child: AppBar(
            backgroundColor: color,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('images/HeyJoylogo.png', width: 95, height: 95,),
                SvgPicture.asset(
                    'images/Group.svg',
                    semanticsLabel: 'Acme Logo',
                  ),
                Text(
                  'JOY',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.blue, size: 40,),
                  onPressed: changeColor,
                ),
              ],
            )
          ),
        ),
        body: Stack(
          children: [
            // Background image
            Image.asset(
              'images/bg.png',
              fit: BoxFit.cover,
            ),
            Container(
              color: Colors.blue.withOpacity(0.3),
            ),
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        SizedBox(height: 380,),
                        ListView.builder(
                          padding: const EdgeInsets.all(8),
                          shrinkWrap: true, // Added to prevent layout overflow
                          physics: NeverScrollableScrollPhysics(), // Disable internal scrolling
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment: message.isSendByMe
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  if (!message.isSendByMe)
                                    SvgPicture.asset(
                                      'images/Group.svg',
                                      semanticsLabel: 'Acme Logo',
                                      width: 50,
                                      height: 50,
                                    ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: message.isSendByMe ? Colors.blue : color,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        message.text,
                                        style: TextStyle(
                                          color: message.isSendByMe ? Colors.white : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  if (message.isSendByMe)
                                    Image(image: AssetImage('images/user.png'))
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  padding: const EdgeInsets.all(30.0),
                  color: color,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.file_copy_outlined, color: Colors.blue),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: 'Ask something...',
                            border: InputBorder.none,
                          ),
                          onSubmitted: (text) {
                            final message = Message(
                              text: text,
                              date: DateTime.now(),
                              isSendByMe: true,
                            );
                            setState(() {
                              messages.add(message);
                            });
                            _controller.clear();
                            _scrollToBottom(); // Scroll to the bottom when a new message is added
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.blue),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Message {
  final String text;
  final DateTime date;
  final bool isSendByMe;

  const Message({
    required this.text,
    required this.date,
    required this.isSendByMe,
  });
}
