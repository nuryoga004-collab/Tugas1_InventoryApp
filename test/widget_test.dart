
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_app/main.dart';

void main() {
  testWidgets('Inventory App menampilkan halaman login', 
      (WidgetTester tester) async {
    await tester.pumpWidget(const InventoryApp());

    expect(find.text('INVENTORY APP'), findsOneWidget);
    expect(find.text('MASUK'), findsOneWidget);
  });
}
