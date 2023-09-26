import 'package:flutter/material.dart';
import 'package:reddit/ContainerNavigator/LinkContainer.dart';
import 'package:reddit/ContainerNavigator/PhotoContainer.dart';
import 'package:reddit/ContainerNavigator/TextNavigator.dart';

class Containerr extends StatefulWidget {
  final String username;
  final String uid;
  Containerr({required this.uid,required this.username,super.key});
  @override
  State<Containerr> createState() {
    return _Containerr();
  }
}

class _Containerr extends State<Containerr> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {},
            child: Container(
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => PhotoContainer(uid: widget.uid, username: widget.username)));
                  },
                  icon: Icon(
                    Icons.image,
                    color: Colors.black,
                    size: 50,
                  )),
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Shadow color
                    spreadRadius:
                        5, // Spread radius (controls the size of the shadow)
                    blurRadius:
                        10, // Blur radius (controls the blurriness of the shadow)
                    offset:
                        Offset(0, 3), // Offset from the top left corner (x, y)
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {},
            child: Container(
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => TextContainer(uid: widget.uid, username:widget.username)));
                  },
                  icon: Icon(
                    Icons.text_fields_sharp,
                    color: Colors.black,
                    size: 50,
                  )),
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Shadow color
                    spreadRadius:
                        5, // Spread radius (controls the size of the shadow)
                    blurRadius:
                        10, // Blur radius (controls the blurriness of the shadow)
                    offset:
                        Offset(0, 3), // Offset from the top left corner (x, y)
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {},
            child: Container(
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => LinkContainer(uid: widget.uid, username: widget.username)));
                  },
                  icon: Icon(
                    Icons.link,
                    color: Colors.black,
                    size: 50,
                  )),
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Shadow color
                    spreadRadius:
                        5, // Spread radius (controls the size of the shadow)
                    blurRadius:
                        10, // Blur radius (controls the blurriness of the shadow)
                    offset:
                        Offset(0, 3), // Offset from the top left corner (x, y)
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
