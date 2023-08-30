import 'package:flutter/material.dart';
import 'package:platformview_test/platformview_test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Widget version = Text('');
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              version,
              Text("Flutter text top"),
              Text("Flutter text middle"),
              Text("Flutter text bottom"),
              const SizedBox(
                height: 300,
                width: 300,
                child: MapView(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
