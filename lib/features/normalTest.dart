import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/Community/CommuintyMiodel.dart';
import 'package:reddit/Community/CummuintyContolller.dart';
import 'package:reddit/ContainerNavigator/ContainerConttoller.dart';
import 'package:reddit/features/postCard.dart';
import 'package:reddit/utils/LoderScreen.dart';
import 'package:reddit/utils/errorScreen.dart';

class TestScreen extends ConsumerWidget {
  final String uid;
  TestScreen({required this.uid, super.key});
  
 

  @override 
  Widget build(BuildContext context,WidgetRef ref) {
    return Scaffold(body:
     ref.watch(commuintyDetailsss(uid)).when(
        data: (data) {
          return ref.watch(postContainerContoller(data)).when(
              data: (model) {
               return ListView.builder(
                  itemCount: model.length,
                  itemBuilder: (context, index) {
                    final titile = model[index];
                  
                   
                     return Text('fkndsklfn');
                     // PostCard(userid: uid, model: titile);
                    
                  },
                );
              },
              error: (err, trace) {
                print(err); return Center(child: Text(err.toString()),);
              
              },
              loading: () => LoderScreen());
        },
        error: (err, trace) {
          showSnackBar(err.toString(), context);
          return Center(child: Text(err.toString()),);
        },
        loading: () => LoderScreen()));
  }
}
