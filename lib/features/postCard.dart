import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/Community/CummuintyContolller.dart';
import 'package:reddit/Community/CummunityProfileScreen.dart';
import 'package:reddit/ContainerNavigator/ContainerConttoller.dart';
import 'package:reddit/ContainerNavigator/ContainerModel.dart';
import 'package:reddit/UserProfile/userProfileScreen.dart';
import 'package:reddit/comments/commentScreen.dart';
import 'package:reddit/utils/LoderScreen.dart';
import 'package:reddit/utils/errorScreen.dart';

class PostCard extends ConsumerWidget {
  final String userid;
  final ContainerModel model;
  PostCard({required this.userid, required this.model, super.key});

  Widget build(BuildContext context, WidgetRef ref) {


    void deletePost(String uid) async {
      ref
          .watch(containerProviderContoller.notifier)
          .deletePost(uid: uid, context: context);
      showSnackBar("Deleted Sucessfully", context);
    }

    void UpVote(String uid) async {
      ref
          .watch(containerProviderContoller.notifier)
          .UpvotePost(uid: uid, model: model);
    }

    void DownVote(String uid) async {
      ref
          .watch(containerProviderContoller.notifier)
          .DownvotePost(uid: uid, model: model);
    }

    String username = model.username;
    print(model.Link);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(model.communityProfile),
                  radius: 17,
                ),
                SizedBox(
                  width: 3,
                ),
                Column(
                  children: [
                    Text(
                      model.commuintyName,
                      semanticsLabel: '$username',
                    ),
                    Text(
                      username,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            model.uid == userid
                ? IconButton(
                    onPressed: () {deletePost(userid);},
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ))
                : SizedBox(),
          ],
        ),
        SizedBox(
          height: 3,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              model.title,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
        model.type == "photo"
            ? AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(model.Link!),
              )
            : model.type == "text" && model.type == "Link"
                ? AnyLinkPreview(
                    link: model.Link!,
                    displayDirection: UIDirection.uiDirectionHorizontal,
                  )
                : ListTile(
                    title: Text(
                      model.Link!,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(onPressed: (){UpVote(userid);}, icon: Icon(
                    Icons.arrow_upward,color:model.upVotes.contains(userid)? Colors.red:Colors.grey,
                    size: 30,),),
                SizedBox(
                  width: 4,
                ),
                Text(
                  'Vote',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  width: 14,
                ),
                IconButton(onPressed: (){DownVote(userid);}, icon: Icon(
                  Icons.arrow_downward,color:model.downVotes.contains(userid)? Colors.blue:Colors.grey,
                  size: 30,
                ),)
              ],
            ),
            ElevatedButton.icon(
                onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>CommentScreen( Userid: model.uid,PostId: model.randomuid)));},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                icon: Icon(Icons.message, size: 30),
                label: Text('Comment')),
                IconButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>UserProfileScreen(id: userid)));
                }, icon: Icon(Icons.group))
          ],

        )
      ],
    );
  }
}
