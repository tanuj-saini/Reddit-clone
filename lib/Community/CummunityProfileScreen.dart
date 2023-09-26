import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/Community/CommuintyMiodel.dart';
import 'package:reddit/Community/CommunityRepoditry.dart';
import 'package:reddit/Community/CummuintyContolller.dart';
import 'package:reddit/ModTools/modTools.dart';

class CommuintyProfileScreen extends ConsumerStatefulWidget {
  final String name;
  final String id;


  CommuintyProfileScreen({required this.id, required this.name, super.key});
  @override
  ConsumerState<CommuintyProfileScreen> createState() {
    return _CommuintyProfileScreen();
  }
}

class _CommuintyProfileScreen extends ConsumerState<CommuintyProfileScreen> {
  
  @override
  
  Widget build(BuildContext context) {

    void JoinCommity(Community community,String uid){
      
      ref.watch(commuintyContoller.notifier).addRemoveUser(community, context, uid);
    }
    return StreamBuilder(
      stream: ref.watch(communityRepositry).commuintyNameDetails(widget.name),
      builder: (context, snapshot) {
        print(widget.name);
          print(widget.id);
        final String memenbers = snapshot.data!.members.length.toString();
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
                      backgroundImage: NetworkImage(snapshot.data!.avatar),
                      radius: 30,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          snapshot.data!.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Align(
                            alignment: Alignment.topRight,
                            child: snapshot.data!.id != widget.id
                                ? TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (ctx) => ModTools(
                                                    uid: widget.id,
                                                    name: widget.name,
                                                  )));
                                    },
                                    child: Text("Mod Tools"))
                                : snapshot.data!.members.contains(widget.id)
                                    ? TextButton(
                                        onPressed: () =>JoinCommity(snapshot.data!, widget.id)
                                          
                                        , child: Text('Leave'))
                                    : TextButton(
                                        onPressed: () =>JoinCommity(snapshot.data!, widget.id),

                                         child: Text("Join")))
                      ]),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text('$memenbers memebers'),
                  )
                ])),
              ),
            ];
          },
          body: Container(),
        ));
      },
    );
  }
}
