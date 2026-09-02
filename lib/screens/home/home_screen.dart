import 'package:flutter/material.dart';

import '../../data/models/book.dart';
import '../../data/repositories/book_repository.dart';
import '../admin/admin_login_screen.dart';
import '../admin/admin_upload_screen.dart';
import '../book_details/book_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BookRepository _repository = BookRepository();

  String category = 'All';
  String search = '';
  int _adminTapCount = 0;

  late Future<List<Book>> _booksFuture;

  final categories = const [
    'All',
    'Fiction',
    'Science',
    'Philosophy',
    'History',
    'Business',
    'Spirituality',
  ];

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  void _loadBooks() {
    _booksFuture = _repository.getPublishedBooks();
  }

  void _refreshBooks() {
    setState(() {
      _loadBooks();
    });
  }

  void _handleAdminTap() {
    _adminTapCount++;

    if (_adminTapCount >= 7) {
      _adminTapCount = 0;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const AdminLoginScreen(),
        ),
      );

      return;
    }

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _adminTapCount < 7) {
        setState(() {
          _adminTapCount = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F5F0),
        title: Row(
          children: [
            const Icon(
              Icons.auto_stories_rounded,
              color: Color(0xFF5B3A29),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _handleAdminTap,
              child: const Text(
                'BOOK HAVEN',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh catalogue',
            onPressed: _refreshBooks,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Admin upload',
            icon: const Icon(
              Icons.admin_panel_settings_outlined,
            ),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AdminUploadScreen(),
                ),
              );

              if (mounted) {
                _refreshBooks();
              }
            },
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_bag_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<List<Book>>(
          future: _booksFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return _ErrorState(
                message: snapshot.error.toString(),
                onRetry: _refreshBooks,
              );
            }

            final books = snapshot.data ?? [];

            final visible = books.where((book) {
              final matchesCategory =
                  category == 'All' || book.category == category;

              final q = search.trim().toLowerCase();

              final matchesSearch = q.isEmpty ||
                  book.title.toLowerCase().contains(q) ||
                  book.author.toLowerCase().contains(q) ||
                  book.category.toLowerCase().contains(q);

              return matchesCategory && matchesSearch;
            }).toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 40),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 1200,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(36),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9DED1),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DISCOVER YOUR\nNEXT GREAT READ',
                              style: TextStyle(
                                fontSize: 38,
                                height: 1.1,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF2D211B),
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Explore books that inspire imagination, knowledge and transformation.',
                              style: TextStyle(
                                fontSize: 17,
                                height: 1.5,
                                color: Color(0xFF5D4B40),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            search = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText:
                              'Search books, authors or subjects...',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'Browse Categories',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
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
                          itemBuilder: (_, index) {
                            final item = categories[index];
                            final selected = item == category;

                            return ChoiceChip(
                              label: Text(item),
                              selected: selected,
                              onSelected: (_) {
                                setState(() {
                                  category = item;
                                });
                              },
                              selectedColor:
                                  const Color(0xFF5B3A29),
                              labelStyle: TextStyle(
                                color: selected
                                    ? Colors.white
                                    : Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Featured Books',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            '${visible.length} books',
                            style: const TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (books.isEmpty)
                        const _EmptyCatalogue()
                      else if (visible.isEmpty)
                        const _NoResults()
                      else
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final columns =
                                constraints.maxWidth >= 900
                                    ? 4
                                    : constraints.maxWidth >= 600
                                        ? 3
                                        : 2;

                            return GridView.builder(
                              shrinkWrap: true,
                              physics:
                                  const NeverScrollableScrollPhysics(),
                              itemCount: visible.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns,
                                crossAxisSpacing: 18,
                                mainAxisSpacing: 18,
                                childAspectRatio: .63,
                              ),
                              itemBuilder: (_, index) {
                                return BookCard(
                                  book: visible[index],
                                );
                              },
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            label: 'Books',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Cart',
          ),
        ],
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({
    super.key,
    required this.book,
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
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BookDetailsScreen(book: book),
          ),
        ),
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
                        child: book.coverPath == null
                            ? const Text(
                                '📚',
                                style: TextStyle(fontSize: 70),
                              )
                            : const Icon(
                                Icons.menu_book_rounded,
                                size: 70,
                                color: Color(0xFF5B3A29),
                              ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.auto_stories,
                            size: 16,
                            color: Color(0xFF5B3A29),
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
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
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
                'R ${book.priceZar.toStringAsFixed(2)}',
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

class _EmptyCatalogue extends StatelessWidget {
  const _EmptyCatalogue();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.library_books_outlined,
            size: 60,
            color: Color(0xFF5B3A29),
          ),
          SizedBox(height: 16),
          Text(
            'The library is waiting for its first books.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Publish a book from the admin area and it will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Text(
          'No books match your search.',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 64,
              color: Color(0xFF5B3A29),
            ),
            const SizedBox(height: 18),
            const Text(
              'Could not load the Book Haven catalogue.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}




