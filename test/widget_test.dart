import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Book Haven test environment is working',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Book Haven',
        home: Scaffold(
          appBar: AppBar(
            title: const Text('BOOK HAVEN'),
          ),
          body: const Center(
            child: Text('Featured Books'),
          ),
        ),
      ),
    );

    expect(find.text('BOOK HAVEN'), findsOneWidget);
    expect(find.text('Featured Books'), findsOneWidget);
  });
}
