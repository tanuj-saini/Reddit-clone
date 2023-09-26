import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/Community/CummuintyContolller.dart';
import 'package:reddit/ContainerNavigator/ContainerConttoller.dart';
import 'package:reddit/comments/CommentCard.dart';
import 'package:reddit/features/postCard.dart';
import 'package:reddit/utils/LoderScreen.dart';
import 'package:reddit/utils/errorScreen.dart';

class CommentScreen extends ConsumerStatefulWidget {
  final String Userid;
  final String PostId;
  CommentScreen({required this.Userid, required this.PostId, super.key});
  @override
  ConsumerState<CommentScreen> createState() {
    return _CommentScreen();
  }
}

class _CommentScreen extends ConsumerState<CommentScreen> {
  void AddComments(
      {required String comments,
      required BuildContext context,
      required String UserPhoto,
      required String Postid,
      required String UserID,
      required String CommuintyName}) async {
    ref.watch(containerProviderContoller.notifier).addComments(
        comments: comments,
        context: context,
        UserPhoto: UserPhoto,
        Postid: Postid,
        UserID: UserID,
        CommuintyName: CommuintyName);
        setState(() {
          commentContoller.text='';
        });
  }

  final TextEditingController commentContoller = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentContoller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoding = ref.watch(commuintyContoller);
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
        centerTitle: true,
      ),
      body: ref.watch(getPostUserDetailsId(widget.PostId)).when(
          data: (data) { 
            return SingleChildScrollView(
              child: Column(
              children: [
                PostCard(userid: widget.Userid, model: data),
                
                       
              TextField(controller: commentContoller,maxLength: 30,decoration: InputDecoration(hintText: "Comments",icon:IconButton(onPressed: (){
                AddComments(comments: commentContoller.text, context: context, UserPhoto: data.communityProfile, Postid: data.randomuid, UserID: data.uid, CommuintyName: data.commuintyName);
              }, icon: Icon(Icons.send))),),
                 ref.watch(getCOmments(widget.PostId)).when(data: (model){
                  return Expanded(
                    child: ListView.builder(itemCount: model.length,itemBuilder: (context, index) {
                      var mose=model[index];
                      return CommentCard(comment: mose);
                  
                    }),
                  );
            
                 }, error: (err,trace){print(err.toString());
                  return SizedBox(); }, loading: ()=>LoderScreen()),],
                      ),
            );
           

          },
            
          error: (err, trace) {
            print(err.toString());
            return SizedBox(); 
           
          },
          loading: () => LoderScreen()),
    );
  }
}
