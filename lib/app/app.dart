import 'package:flutter/material.dart';

import '../features/home/presentation/pages/home_page.dart';


class FlirtPlayApp extends StatelessWidget
{
  const FlirtPlayApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: 'FlirtPlay',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        fontFamily: 'Poppins',
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}