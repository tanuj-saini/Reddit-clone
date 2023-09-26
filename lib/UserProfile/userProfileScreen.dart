import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/ContainerNavigator/ContainerConttoller.dart';
import 'package:reddit/UserProfile/userProfileEdit.dart';
import 'package:reddit/auth/userContoller.dart';
import 'package:reddit/features/postCard.dart';
import 'package:reddit/utils/LoderScreen.dart';
import 'package:reddit/utils/PickerImage.dart';
import 'package:reddit/utils/errorScreen.dart';

class UserProfileScreen extends ConsumerStatefulWidget{
  final String id;
  UserProfileScreen({required this.id,super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _UserProfileScreen();
  }
}
class _UserProfileScreen extends ConsumerState<UserProfileScreen>{

  @override
  Widget build(BuildContext context) {
   
return  StreamBuilder(stream: ref.watch(authContoller).userData(widget.id), builder: (context, snapshot) {
  return Scaffold(
            body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 150,
                floating: true,
                snap: true,
                flexibleSpace: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        snapshot.data!.banner,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.all(16),
                sliver: SliverList(
                    delegate: SliverChildListDelegate([
                  Align(
                    alignment: Alignment.topLeft,
                    child: CircleAvatar(
                      backgroundImage:NetworkImage(snapshot.data!.photoURL),
                      radius: 30,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton(onPressed: (){ Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (ctx) =>UserProfileEdit(uid: widget.id)
                                                  )
                                                  );}, child: Text("Edit Profile")),
                
                  SizedBox(
                    height: 10,
                  ),
                  
                ])),
              ),
            ];
          },
          body: ref.watch(getUserPostDetails(widget.id)).when(data: (data){
                              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final model = data[index];
                  return PostCard(userid: widget.id,model: model);

                      
                    
                  },
                );


                            }, error: (err,trace){
                              print(err);
                              return showSnackBar(err.toString(), context);
                            }, loading: ()=>LoderScreen()),
        ));
},);

      }
  
  
}
