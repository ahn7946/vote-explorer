import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      // title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: const TextTheme(
          titleMedium: TextStyle(fontSize: 20),
          bodyMedium: TextStyle(fontSize: 16),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
