import 'package:fintrack_app/newssection/newsapi.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(NewsApp());
}

class NewsApp extends StatelessWidget{
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Fintrack News",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NewsPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}