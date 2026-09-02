import 'package:flutter/material.dart';

import '../../data/models/book.dart';

class BookDetailsScreen extends StatelessWidget {
  final Book book;

  const BookDetailsScreen({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Book Details',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 900,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 360,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9DED1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: book.coverPath == null
                        ? const Text(
                            '📚',
                            style: TextStyle(fontSize: 110),
                          )
                        : const Icon(
                            Icons.menu_book_rounded,
                            size: 110,
                            color: Color(0xFF5B3A29),
                          ),
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  book.title,
                  style: const TextStyle(
                    fontSize: 34,
                    height: 1.15,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF2D211B),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'by ${book.author}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9DED1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        book.category,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF5B3A29),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'R ${book.priceZar.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF5B3A29),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                const Text(
                  'About this book',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  book.description.isEmpty
                      ? 'No description has been added for this book yet.'
                      : book.description,
                  style: const TextStyle(
                    fontSize: 17,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Cart functionality is coming next.',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.shopping_bag_outlined,
                    ),
                    label: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      child: Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
