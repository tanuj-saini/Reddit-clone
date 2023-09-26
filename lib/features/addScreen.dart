import 'package:flutter/material.dart';
import 'package:reddit/features/Container.dart';

class AddScreen extends StatefulWidget {
  final String username;
  final String uid;
  AddScreen({required this.uid, required this.username, super.key});
  @override
  State<StatefulWidget> createState() {
    return _AddScreen();
  }
}

class _AddScreen extends State<AddScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Containerr(uid: widget.uid, username: widget.username),
    );
  }
}
