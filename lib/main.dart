import 'package:flutter/material.dart';

void main() {
  runApp(const BookStoreApp());
}

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5B3A29),
        ),
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
  int selectedIndex = 0;
  String selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Fiction',
    'Science',
    'Philosophy',
    'History',
    'Business',
    'Spirituality',
  ];

  final List<Book> books = [
    Book(
      title: 'The Silent Library',
      author: 'Maya Anderson',
      price: 249.99,
      category: 'Fiction',
      emoji: '📕',
      rating: 4.7,
      description:
          'A mysterious journey through an ancient library where every book '
          'contains a forgotten memory. A story about discovery, courage and '
          'the power of knowledge.',
    ),
    Book(
      title: 'The Mathematics of the Divine',
      author: 'Sello P. Baloyi',
      price: 329.99,
      category: 'Philosophy',
      emoji: '📘',
      rating: 4.9,
      description:
          'An exploration of mathematics, patterns, numbers and the timeless '
          'question of whether the universe contains a deeper mathematical order.',
    ),
    Book(
      title: 'The Hidden Universe',
      author: 'Daniel Carter',
      price: 289.99,
      category: 'Science',
      emoji: '📗',
      rating: 4.6,
      description:
          'Journey beyond the visible world and explore the discoveries that '
          'continue to reshape our understanding of space, matter and reality.',
    ),
    Book(
      title: 'The Art of Wealth',
      author: 'Marcus Reed',
      price: 219.99,
      category: 'Business',
      emoji: '📙',
      rating: 4.5,
      description:
          'A practical guide to understanding money, creating value and '
          'developing the habits required for long-term financial growth.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredBooks = selectedCategory == 'All'
        ? books
        : books.where((book) => book.category == selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F5F0),
        elevation: 0,
        title: const Row(
          children: [
            Icon(
              Icons.auto_stories_rounded,
              color: Color(0xFF5B3A29),
              size: 30,
            ),
            SizedBox(width: 10),
            Text(
              'BOOK HAVEN',
              style: TextStyle(
                color: Color(0xFF2D211B),
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_bag_outlined),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 40),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // HERO
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(36),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9DED1),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final compact = constraints.maxWidth < 650;

                        return Flex(
                          direction:
                              compact ? Axis.vertical : Axis.horizontal,
                          children: [
                            Expanded(
                              flex: compact ? 0 : 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'DISCOVER YOUR\nNEXT GREAT READ',
                                    style: TextStyle(
                                      fontSize: 38,
                                      height: 1.1,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF2D211B),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Explore books that inspire imagination, '
                                    'knowledge and transformation.',
                                    style: TextStyle(
                                      fontSize: 17,
                                      height: 1.5,
                                      color: Color(0xFF5D4B40),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  FilledButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.explore_outlined),
                                    label: const Text('Explore Books'),
                                    style: FilledButton.styleFrom(
                                      backgroundColor:
                                          const Color(0xFF5B3A29),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (compact) const SizedBox(height: 30),
                            if (!compact) const SizedBox(width: 30),
                            Expanded(
                              flex: compact ? 0 : 2,
                              child: Container(
                                height: 230,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF5B3A29),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: const Center(
                                  child: Text(
                                    '📚',
                                    style: TextStyle(fontSize: 100),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 36),

                  // SEARCH
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search books, authors or subjects...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 18),
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    'Browse Categories',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2D211B),
                    ),
                  ),

                  const SizedBox(height: 14),

                  SizedBox(
                    height: 46,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final selected = category == selectedCategory;

                        return ChoiceChip(
                          label: Text(category),
                          selected: selected,
                          onSelected: (_) {
                            setState(() {
                              selectedCategory = category;
                            });
                          },
                          selectedColor: const Color(0xFF5B3A29),
                          labelStyle: TextStyle(
                            color:
                                selected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 36),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Featured Books',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2D211B),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('View all'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      int columns = 2;

                      if (constraints.maxWidth >= 900) {
                        columns = 4;
                      } else if (constraints.maxWidth >= 600) {
                        columns = 3;
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredBooks.length,
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: 18,
                          mainAxisSpacing: 18,
                          childAspectRatio: 0.63,
                        ),
                        itemBuilder: (context, index) {
                          final book = filteredBooks[index];

                          return BookCard(
                            book: book,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      BookDetailsPage(book: book),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // NAVIGATION
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Books',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag),
            label: 'Cart',
          ),
        ],
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;

  const BookCard({
    super.key,
    required this.book,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9DED1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          book.emoji,
                          style: const TextStyle(fontSize: 70),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 15,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                book.rating.toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                book.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                book.author,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'R ${book.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF5B3A29),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookDetailsPage extends StatefulWidget {
  final Book book;

  const BookDetailsPage({
    super.key,
    required this.book,
  });

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final book = widget.book;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
        backgroundColor: const Color(0xFFF7F5F0),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 700;

                final cover = Container(
                  height: compact ? 380 : 500,
                  width: compact ? double.infinity : 360,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9DED1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Text(
                      book.emoji,
                      style: const TextStyle(fontSize: 140),
                    ),
                  ),
                );

                final details = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9DED1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        book.category,
                        style: const TextStyle(
                          color: Color(0xFF5B3A29),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      book.title,
                      style: const TextStyle(
                        fontSize: 38,
                        height: 1.15,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF2D211B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'by ${book.author}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${book.rating} / 5',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Text(
                      book.description,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Color(0xFF5D4B40),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'R ${book.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF5B3A29),
                      ),
                    ),
                    const SizedBox(height: 22),

                    // QUANTITY
                    Row(
                      children: [
                        const Text(
                          'Quantity:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 14),
                        IconButton(
                          onPressed: quantity > 1
                              ? () {
                                  setState(() {
                                    quantity--;
                                  });
                                }
                              : null,
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                        Text(
                          '$quantity',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              quantity++;
                            });
                          },
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${book.title} added to cart',
                              ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.shopping_bag_outlined,
                        ),
                        label: Text(
                          'Add $quantity to Cart',
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF5B3A29),
                          padding: const EdgeInsets.symmetric(
                            vertical: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                );

                if (compact) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      cover,
                      const SizedBox(height: 30),
                      details,
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    cover,
                    const SizedBox(width: 50),
                    Expanded(child: details),
                  ],
                );
              },
            ),
          ),
        ),
      ),
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

  const Book({
    required this.title,
    required this.author,
    required this.price,
    required this.category,
    required this.emoji,
    required this.rating,
    required this.description,
  });
}