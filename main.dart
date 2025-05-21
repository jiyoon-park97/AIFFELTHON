import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'loading_page.dart';
import 'first_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FirstPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GalleryAppPage extends StatefulWidget {
  const GalleryAppPage({super.key});

  @override
  State<GalleryAppPage> createState() => _GalleryAppPageState();
}

class _GalleryAppPageState extends State<GalleryAppPage> {
  final TextEditingController _urlController = TextEditingController();

  List<String> imageUrls = [
    'https://picsum.photos/200/200?1',
    'https://picsum.photos/200/200?2',
    'https://picsum.photos/200/200?3',
  ];

  Future<void> _goToLoadingPage() async {
    final url = _urlController.text.trim();
    if (url.isNotEmpty) {
      final result = await Navigator.push<String>(
        context,
        MaterialPageRoute(builder: (context) => LoadingPage(url: url)),
      );

      if (result != null && !imageUrls.contains(result)) {
        setState(() {
          imageUrls.add(result);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'image/reviewtalk_logo.png',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _urlController,
                  onSubmitted: (_) => _goToLoadingPage(),
                  decoration: InputDecoration(
                    hintText: 'https://example.com/product-image.jpg',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),

          DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.3,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [BoxShadow(blurRadius: 12, color: Colors.black26)],
                ),
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  controller: scrollController,
                  itemCount: imageUrls.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final imageUrl = imageUrls[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ChatScreen(
                                  imageUrl: imageUrl,
                                  isNew: false,
                                ),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                color: Colors.grey[200],
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                ),
                              ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
