import 'package:flutter/material.dart';
import 'features/stock_opname/presentation/opname_dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WmsMobileApp());
}

class WmsMobileApp extends StatelessWidget {
  const WmsMobileApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WMS Gudang Buku',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF1E1E2E),
        scaffoldBackgroundColor: const Color(0xFF181825),
        colorScheme: const ColorScheme.dark(
          primary: Colors.cyanAccent,
          secondary: Colors.greenAccent,
          surface: Color(0xFF1E1E2E),
        ),
      ),
      home: const MainNavigationShell(),
    );
  }
}
