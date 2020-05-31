import 'package:flutter/material.dart';

class MonthlyScreen extends StatefulWidget {
  @override
  _MonthlyScreenState createState() => _MonthlyScreenState();
}

class _MonthlyScreenState extends State<MonthlyScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text('MonthlyScreen'
        , style: TextStyle(
          fontSize: 30, 
        ),)
    );
  }
}