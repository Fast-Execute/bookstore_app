import 'package:flutter_test/flutter_test.dart';

import 'package:bookstore_app/main.dart';

void main() {
  testWidgets('Book Haven app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const BookStoreApp());

    expect(find.text('BOOK HAVEN'), findsOneWidget);
    expect(find.text('Featured Books'), findsOneWidget);
  });
}
