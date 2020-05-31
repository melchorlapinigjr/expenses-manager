import 'package:flutter/material.dart';

class YearlyScreen extends StatefulWidget {
  @override
  _YearlyScreenState createState() => _YearlyScreenState();
}

class _YearlyScreenState extends State<YearlyScreen> {
  @override
  Widget build(BuildContext context) {
      return Center(
      child: Text("Yearly Scren",
      style: TextStyle(fontSize: 20),
      ),      
    );
  }
}