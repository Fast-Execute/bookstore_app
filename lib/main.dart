import 'package:flutter/material.dart';

import 'screens/admin_upload_screen.dart';

void main() => runApp(const BookStoreApp());

class BookStoreApp extends StatelessWidget {
  const BookStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Haven',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F5F0),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5B3A29)),
        fontFamily: 'Arial',
      ),
      home: const BookStoreHome(),
    );
  }
}

class BookStoreHome extends StatefulWidget {
  const BookStoreHome({super.key});

  @override
  State<BookStoreHome> createState() => _BookStoreHomeState();
}

class _BookStoreHomeState extends State<BookStoreHome> {
  String category = 'All';
  String search = '';

  final categories = const [
    'All',
    'Fiction',
    'Science',
    'Philosophy',
    'History',
    'Business',
    'Spirituality',
  ];

  final books = const [
    Book('The Silent Library', 'Maya Anderson', 249.99, 'Fiction', '📕', 4.7,
        'A mysterious journey through an ancient library.'),
    Book('The Mathematics of the Divine', 'Sello P. Baloyi', 329.99,
        'Philosophy', '📘', 4.9, 'An exploration of mathematics, patterns and the timeless question of cosmic order.'),
    Book('The Hidden Universe', 'Daniel Carter', 289.99, 'Science', '📗', 4.6,
        'A journey beyond the visible world.'),
    Book('The Art of Wealth', 'Marcus Reed', 219.99, 'Business', '📙', 4.5,
        'A practical guide to money, value and long-term growth.'),
  ];

  @override
  Widget build(BuildContext context) {
    final visible = books.where((book) {
      final matchesCategory = category == 'All' || book.category == category;
      final q = search.toLowerCase();
      final matchesSearch = q.isEmpty ||
          book.title.toLowerCase().contains(q) ||
          book.author.toLowerCase().contains(q) ||
          book.category.toLowerCase().contains(q);
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F5F0),
        title: const Row(children: [
          Icon(Icons.auto_stories_rounded, color: Color(0xFF5B3A29)),
          SizedBox(width: 10),
          Text('BOOK HAVEN', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.5)),
        ]),
        actions: [
          IconButton(
            tooltip: 'Admin upload',
            icon: const Icon(Icons.admin_panel_settings_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AdminUploadScreen()),
            ),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_bag_outlined)),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 40),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(36),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9DED1),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('DISCOVER YOUR\nNEXT GREAT READ', style: TextStyle(fontSize: 38, height: 1.1, fontWeight: FontWeight.w900, color: Color(0xFF2D211B))),
                    SizedBox(height: 16),
                    Text('Explore books that inspire imagination, knowledge and transformation.', style: TextStyle(fontSize: 17, height: 1.5, color: Color(0xFF5D4B40))),
                  ]),
                ),
                const SizedBox(height: 30),
                TextField(
                  onChanged: (value) => setState(() => search = value),
                  decoration: InputDecoration(
                    hintText: 'Search books, authors or subjects...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 28),
                const Text('Browse Categories', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                const SizedBox(height: 14),
                SizedBox(
                  height: 46,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 10),
                    itemBuilder: (_, index) {
                      final item = categories[index];
                      final selected = item == category;
                      return ChoiceChip(
                        label: Text(item),
                        selected: selected,
                        onSelected: (_) => setState(() => category = item),
                        selectedColor: const Color(0xFF5B3A29),
                        labelStyle: TextStyle(color: selected ? Colors.white : Colors.black87, fontWeight: FontWeight.w600),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text('Featured Books', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                  Text('${visible.length} books', style: const TextStyle(color: Colors.black54)),
                ]),
                const SizedBox(height: 16),
                LayoutBuilder(builder: (context, constraints) {
                  final columns = constraints.maxWidth >= 900 ? 4 : constraints.maxWidth >= 600 ? 3 : 2;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: visible.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 18,
                      mainAxisSpacing: 18,
                      childAspectRatio: .63,
                    ),
                    itemBuilder: (_, index) => BookCard(book: visible[index]),
                  );
                }),
              ]),
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), label: 'Books'),
          NavigationDestination(icon: Icon(Icons.favorite_border), label: 'Favorites'),
          NavigationDestination(icon: Icon(Icons.shopping_bag_outlined), label: 'Cart'),
        ],
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  final Book book;
  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BookDetailsPage(book: book))),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(color: const Color(0xFFE9DED1), borderRadius: BorderRadius.circular(14)),
                child: Stack(children: [
                  Center(child: Text(book.emoji, style: const TextStyle(fontSize: 70))),
                  Positioned(top: 8, right: 8, child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: Row(children: [const Icon(Icons.star, size: 15, color: Colors.amber), const SizedBox(width: 3), Text(book.rating.toString())]),
                  )),
                ]),
              ),
            ),
            const SizedBox(height: 12),
            Text(book.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 5),
            Text(book.author, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 8),
            Text('R ${book.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Color(0xFF5B3A29))),
          ]),
        ),
      ),
    );
  }
}

class BookDetailsPage extends StatelessWidget {
  final Book book;
  const BookDetailsPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Details')),
      body: ListView(padding: const EdgeInsets.all(24), children: [
        Container(height: 360, decoration: BoxDecoration(color: const Color(0xFFE9DED1), borderRadius: BorderRadius.circular(24)), child: Center(child: Text(book.emoji, style: const TextStyle(fontSize: 130)))),
        const SizedBox(height: 24),
        Text(book.category.toUpperCase(), style: const TextStyle(color: Color(0xFF5B3A29), fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text(book.title, style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Text('by ${book.author}', style: const TextStyle(fontSize: 18, color: Colors.black54)),
        const SizedBox(height: 16),
        Text(book.description, style: const TextStyle(fontSize: 16, height: 1.5)),
        const SizedBox(height: 22),
        Text('R ${book.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFF5B3A29))),
        const SizedBox(height: 20),
        FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.shopping_cart_outlined), label: const Text('Add to Cart')),
      ]),
    );
  }
}

class Book {
  final String title;
  final String author;
  final double price;
  final String category;
  final String emoji;
  final double rating;
  final String description;

  const Book(this.title, this.author, this.price, this.category, this.emoji, this.rating, this.description);
}
