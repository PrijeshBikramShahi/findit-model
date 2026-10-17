import 'package:flutter_test/flutter_test.dart';
import 'package:findit/main.dart';

void main() {
  testWidgets('shows the product onboarding experience', (tester) async {
    await tester.pumpWidget(const FindItApp());

    expect(find.text('See it.\nFind it.\nBuy it.'), findsOneWidget);
    expect(find.text('Get started'), findsOneWidget);
  });
}
