

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/Community/CummuintyContolller.dart';
import 'package:reddit/auth/Userrepositry.dart';
import 'package:reddit/auth/userContoller.dart';
import 'package:reddit/utils/LoderScreen.dart';
import 'package:reddit/utils/errorScreen.dart';

class editModel extends ConsumerStatefulWidget {
  final String name;
  final String uid;

  editModel({required this.name, required this.uid, super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _editModel();
  }
}

class _editModel extends ConsumerState<editModel> {
  Set<String> list={};
    void sendToFIrebase(List<String> string,String commuintyName)async{
      ref.watch(commuintyContoller.notifier).sendToFireUd(commuintyName, string, context);
    }
     int cout=0;
  void addUser (String uid){
    
    setState(() {
      list.add(uid);
    });
 
  }
  void RemoveUser (String uid){
    setState(() {
      list.remove(uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Select Contact"),
          centerTitle: true,
          actions: [
            IconButton(onPressed: () {
              sendToFIrebase(list.toList(), widget.name);
            }, icon: Icon(Icons.check)),
          ],
        ),
        body: ref.watch(getCommunityByNameProvider(widget.name)).when(
            data: (commuinty) => ListView.builder(
                  itemCount: commuinty.members.length,
                  itemBuilder: (context, index) {
                    final userID = commuinty.members[index];

                   return   ref.watch(getUserDataProvider(userID)).when(
                        data: (username) {
                          if(commuinty.members.contains(userID)&&cout==0){
                             list.add(userID);
                             cout++;
                          }
                           return CheckboxListTile(
                              value: list.contains(username.uid),
                              onChanged: (val) {
                                if(val!){
                                  addUser(username.uid);
                                }
                                else{
                                  RemoveUser(username.uid);
                                }
                              
                            
                              },
                              
                              title: Text(username.userName),
                          );
                             
                          },


                          
                        error: (err, trace) {
                          showSnackBar(err.toString(), context);
                        },
                        loading: () => LoderScreen());
                  },
                ),
            error: (err, trace) {
              showSnackBar(err.toString(), context);
            },
            loading: () => LoderScreen()));
  }
}
