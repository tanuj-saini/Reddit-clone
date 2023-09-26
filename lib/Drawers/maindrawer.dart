import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/Community/CommuintyScreen.dart';
import 'package:reddit/Community/CummuintyContolller.dart';
import 'package:reddit/Community/CummunityProfileScreen.dart';
import 'package:reddit/utils/LoderScreen.dart';
import 'package:reddit/utils/themeColor.dart';

class DrawerScreen extends ConsumerWidget {
  final String uid;
  DrawerScreen({required this.uid, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
        stream: ref.watch(commuintyContoller.notifier).getCommuintyDetails(
              uid,
            ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoderScreen();
          }
          return Drawer(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                   const SizedBox(
                      height: 100,
                    ),
                    ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => CommunityCreate(uid: uid)));
                        },
                        icon: Icon(Icons.add),
                        label: Text("Create a community")),
                   const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final commuintyData = snapshot.data![index];
                          return ListTile(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => CommuintyProfileScreen(id: uid,
                                      name: commuintyData.name)));
                            },
                            title: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>CommuintyProfileScreen(id: uid,name: commuintyData.name)));
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Pallete.blackColor),
                                icon: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(commuintyData.avatar),
                                ),
                                label: Text(commuintyData.name)),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
