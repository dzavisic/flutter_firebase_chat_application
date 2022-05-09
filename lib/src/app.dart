import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_application/src/components/landing.component.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Example Application',
            theme: ThemeData(primarySwatch: Colors.orange),
            darkTheme: ThemeData.dark(),
            themeMode: currentMode,
            home: const LandingComponent(title: 'Registration Form'),
          );
        });
  }
}
