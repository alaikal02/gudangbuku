import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_wms/main.dart';

void main() {
  testWidgets('WMS App Smoke Test', (WidgetTester tester) async {
    await tester.pumpWidget(const WmsMobileApp());
    expect(find.byType(WmsMobileApp), findsOneWidget);
  });
}
