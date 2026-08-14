import 'package:breakify/breakify.dart';
import 'package:example/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BreakifyExampleApp());
}

class BreakifyExampleApp extends StatelessWidget {
  const BreakifyExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BreakifyScope(
      breakpoints: BreakifyBreakpoints.defaults,
      child: MaterialApp(
        title: 'Flexify Example',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
        home: HomeScreen(),
      ),
    );
  }
}
