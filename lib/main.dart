import 'package:flutter/material.dart';
import 'package:light_bulb_effect/light_bulb_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LightBulbPage(
        lightColor: Color.fromARGB(255, 242, 229, 108),
      ),
    );
  }
}
