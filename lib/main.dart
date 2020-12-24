import 'package:flutter/material.dart';

import 'package:cartelera/src/pages/home_page.dart';
import 'package:cartelera/src/pages/film_details.dart';
import 'package:flutter_config/flutter_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cartelera',
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => HomePage(),
        'details': (BuildContext context) => FilmDetails()
      },
    );
  }
}
