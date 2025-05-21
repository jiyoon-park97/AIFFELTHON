import 'dart:async';
import 'package:flutter/material.dart';
import 'chat_screen.dart';

class LoadingPage extends StatefulWidget {
  final String url;
  const LoadingPage({super.key, required this.url});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();

    // ✅ 2초 로딩 후 ChatScreen으로 전환
    Future.delayed(const Duration(seconds: 2), () async {
      final result = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(imageUrl: widget.url, isNew: true),
        ),
      );

      // ✅ ChatScreen에서 받은 imageUrl을 main.dart로 전달
      Navigator.pop(context, result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('AI가 리뷰를 읽고 있어요', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
