import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/Community/CummunityProfileScreen.dart';
import 'package:reddit/Drawers/ProfileDrawer.dart';
import 'package:reddit/Drawers/maindrawer.dart';
import 'package:reddit/Drawers/searchCommuinty.dart';
import 'package:reddit/auth/LoginScreen.dart';
import 'package:reddit/auth/UserModel.dart';
import 'package:reddit/auth/userContoller.dart';
import 'package:reddit/features/HomeLayout.dart';
import 'package:reddit/features/addScreen.dart';
import 'package:reddit/utils/LoderScreen.dart';

class TestDart extends ConsumerStatefulWidget {
  final String userId;
  TestDart({required this.userId, super.key});
  @override
  ConsumerState<TestDart> createState() {
    return _TestDart();
  }
}

class _TestDart extends ConsumerState<TestDart> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void displayEndDra(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return StreamBuilder(
      stream: ref.watch(authContoller).userData(widget.userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          LoderScreen();
        }
        final List<Widget> _screens = [
          HomeLayoutScreen(uid: widget.userId),
          AddScreen(uid: widget.userId, username: snapshot.data!.userName),
        ];
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Home",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    showSearch(
                        context: context, delegate: SearchCommuinty(ref));
                  },
                  icon: Icon(Icons.search)),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data!.photoURL),
                      radius: 12,
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => ProfileDrawer(
                              id: widget.userId,
                              name: snapshot.data!.userName,
                              photoUrl: snapshot.data!.photoURL)));
                    }),
              )
            ],
          ),
          //Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> ProfileDrawer(name: snapshot.data!.userName, photoUrl: snapshot.data!.photoURL)));
          endDrawer: ProfileDrawer(
              id: widget.userId,
              name: snapshot.data!.userName,
              photoUrl: snapshot.data!.photoURL),
          drawer: DrawerScreen(
            uid: widget.userId,
          ),
          body: _screens[_currentIndex],

          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: 'Add',
              ),
            ],
          ),
        );
      },
    );
  }
}
