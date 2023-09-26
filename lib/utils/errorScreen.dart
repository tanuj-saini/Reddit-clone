import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ErrorScreen extends StatefulWidget{
  final String message;
  ErrorScreen({required this.message,super.key})
;

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
@override
  Widget build(BuildContext context) {
    return SnackBar(content: Text(widget.message));
  }}
  
showSnackBar(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));}