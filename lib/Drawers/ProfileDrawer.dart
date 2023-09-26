import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/UserProfile/userProfileScreen.dart';
import 'package:reddit/auth/Userrepositry.dart';

class ProfileDrawer extends ConsumerStatefulWidget {
  final String photoUrl;
  final String name;
  final String id;
  ProfileDrawer({required this.id,required this.name, required this.photoUrl, super.key});
  @override
  ConsumerState<ProfileDrawer> createState() {

    return _ProfileDrawer();
  }
}

class _ProfileDrawer extends ConsumerState<ProfileDrawer> {
  void SignOut()async{
    ref.watch(authRepositry).signOutWithGoogle(context);
  }
  @override
  Widget build(BuildContext context) {

    return Drawer(
        child: Column(children: [SizedBox(height: 50,),
      CircleAvatar(
        backgroundImage: NetworkImage(widget.photoUrl),
        radius: 50,
      ),
      SizedBox(
        height: 10,
      ),
      Center(
        child: Text(
          widget.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(
        height: 40,
      ),
      ListTile(
        title: ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>UserProfileScreen(id: widget.id)));
          },
          icon: Icon(Icons.contacts),
          label: Text("My Profile"),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black87),
        ),
      ),
      ListTile(
        title: ElevatedButton.icon(
          onPressed: () {SignOut();},
          icon: Icon(Icons.logout),
          label: Text("LogOut"),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black87),
        ),
      ),
    ]));
  }
}
