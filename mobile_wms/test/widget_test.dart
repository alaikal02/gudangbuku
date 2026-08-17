import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_wms/main.dart';
import 'package:mobile_wms/services/warehouse_stock_service.dart';
import 'package:mobile_wms/services/theme_service.dart';

void main() {
  testWidgets('WMS App Smoke Test', (WidgetTester tester) async {
    final stockService = WarehouseStockService();
    final themeService = ThemeService();
    await tester.pumpWidget(WmsMobileApp(
      stockService: stockService,
      themeService: themeService,
    ));
    expect(find.byType(WmsMobileApp), findsOneWidget);
  });
}
