import 'package:flutter/material.dart';

// ✅ 전체 채팅 히스토리
final Map<String, List<Map<String, dynamic>>> chatHistory = {};

class ChatScreen extends StatefulWidget {
  final String imageUrl;
  final bool isNew;

  const ChatScreen({super.key, required this.imageUrl, this.isNew = false});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  List<Map<String, dynamic>> get _currentChats =>
      chatHistory[widget.imageUrl] ?? [];

  @override
  void initState() {
    super.initState();
    if (widget.isNew) {
      chatHistory[widget.imageUrl] = [];
    } else {
      chatHistory.putIfAbsent(widget.imageUrl, () => []);
    }
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      chatHistory[widget.imageUrl]!.add({"text": text, "isUser": true});
    });

    _controller.clear();

    // 🤖 AI 응답 예시
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        chatHistory[widget.imageUrl]!.add({
          "text": "🤖 '${widget.imageUrl}' 관련 AI 응답입니다!",
          "isUser": false,
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('리뷰 챗봇'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, widget.imageUrl); // ✅ main으로 전달
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                widget.imageUrl,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) =>
                        const Icon(Icons.broken_image),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _currentChats.length,
              itemBuilder: (context, index) {
                final msg = _currentChats[index];
                final isUser = msg['isUser'] as bool;
                final text = msg['text'] as String;

                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.deepPurple[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(text),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: '메시지를 입력하세요',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
