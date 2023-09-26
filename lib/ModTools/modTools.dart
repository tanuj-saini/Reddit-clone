import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/ModTools/editCommuintyScreen.dart';
import 'package:reddit/features/editModel.dart';

class ModTools extends ConsumerStatefulWidget{
  final String uid;
   final String name;
  ModTools({required this.name,required this.uid,super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ModTools();
  }
}
class _ModTools extends ConsumerState<ModTools>{
  @override
  Widget build(BuildContext context) {
   return Scaffold(appBar: AppBar(title:Text('ModTools'),centerTitle: true,),
   body: Column(children: [
    ListTile(title: Text("Add Moderators"),leading: Icon(Icons.add_moderator),
    onTap: (){
      Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>editModel(name: widget.name, uid: widget.uid)));
    },),
     ListTile(title: Text("Edit Community"),leading: Icon(Icons.edit),
    onTap: (){
      Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>EditingComuintyScreen(name: widget.name,uid: widget.uid,)));
    },),
   ],),);
  }
}