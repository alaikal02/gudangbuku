import 'package:flutter/material.dart';
import 'services/warehouse_stock_service.dart';
import 'services/theme_service.dart';
import 'screens/main_navigation_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final stockService = WarehouseStockService();
  final themeService = ThemeService();
  runApp(WmsMobileApp(stockService: stockService, themeService: themeService));
}

class WmsMobileApp extends StatefulWidget {
  final WarehouseStockService stockService;
  final ThemeService themeService;

  const WmsMobileApp({
    super.key,
    required this.stockService,
    required this.themeService,
  });

  @override
  State<WmsMobileApp> createState() => _WmsMobileAppState();
}

class _WmsMobileAppState extends State<WmsMobileApp> {
  @override
  void initState() {
    super.initState();
    widget.themeService.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    widget.themeService.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gudang Darussholah WMS',
      debugShowCheckedModeBanner: false,
      theme: widget.themeService.currentTheme,
      home: MainNavigationScreen(
        stockService: widget.stockService,
        themeService: widget.themeService,
      ),
    );
  }
}
