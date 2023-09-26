

import 'package:flutter/material.dart';

class LoderScreen extends StatefulWidget{
  LoderScreen({super.key});
  @override
  State<LoderScreen> createState() {
   return _ErrorScreen();
  }
}
class _ErrorScreen extends State<LoderScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Container(child: CircularProgressIndicator())),);
  }
}