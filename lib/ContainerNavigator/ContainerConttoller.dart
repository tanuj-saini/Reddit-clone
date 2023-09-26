import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/Community/CommuintyMiodel.dart';
import 'package:reddit/ContainerNavigator/CommentsModel.dart';
import 'package:reddit/ContainerNavigator/ContainerModel.dart';
import 'package:reddit/ContainerNavigator/ContainerREpositry.dart';
import 'package:reddit/constants/storagePhoto.dart';
import 'package:riverpod/src/framework.dart';
import 'package:uuid/uuid.dart';

final containerProviderContoller = StateNotifierProvider<ContainereContoller,bool>((ref) {
  final ContainerRepo = ref.watch(containerPRovider);
  return ContainereContoller(ref: ref, containerRepositry: ContainerRepo);
});
final postContainerContoller=StreamProvider.family((ref,List<Community>community) {
  final postCOntoller=ref.watch(containerPRovider);
  return postCOntoller.getDetailsPost(community);
});


final getCOmments=StreamProvider.family((ref,String PostID) {
  final postCOntoller=ref.watch(containerPRovider);
  return postCOntoller.getListOfComments(PostID: PostID);



});


final getUserPostDetails =StreamProvider.family((ref,String uid) {
  final postcontoller=ref.watch(containerPRovider);
  return postcontoller.getUserPostDetails( uid);

} );

final getPostUserDetailsId=StreamProvider.family((ref,String id) {
    final postcontoller=ref.watch(containerPRovider);
    return postcontoller.getPostByUserDetails(id);
});





class ContainereContoller extends StateNotifier<bool> {
  final Ref ref;
  final ContainerRepositry containerRepositry;

  ContainereContoller({required this.ref, required this.containerRepositry}):super(false) ;

  void setDetailsPostTOFirebase(
      {required String userName,
      required BuildContext context,
      required String Useruid,
      required Community community,
      required File? post,
      required String title}) async {
    if (post != null) {
      state=true;
      String uuid = Uuid().v1();
      final ppost = await ref.watch(StorageMethodProvider).uploadFile(
          uid: userName,
          context: context,
          childname: 'Post/Image/$uuid',
          file: post);
      containerRepositry.setToFirebase(type: 'photo',
          context: context,
          userName: userName,
          community: community,
          Useruid: Useruid,
          Link: ppost,
          title: title);
          state=false;
    }
    
  }
  void deletePost({required String uid,required BuildContext context})async{
 await containerRepositry.deletePost(uid,context);

}

void UpvotePost({required ContainerModel model,required String uid})async{
  await containerRepositry.UpvotePost(model, uid);

  

}

void DownvotePost({required ContainerModel model,required String uid})async{
  await containerRepositry.DownvotePost(model,uid);
  
  

}
  void setDetailsTOFirebase(
      {required String userName,
      required BuildContext context,
      required String Useruid,
      required Community community,
      required String Link,
      required String title}) async {
    if (title.isNotEmpty && Link.isNotEmpty) {
      state=true;
      containerRepositry.setToFirebase(type: "text",
          context: context,
          userName: userName,
          community: community,
          Useruid: Useruid,
          Link: Link,
          title: title);
          state=false;
    }
      }


       void setDetailsTextTOFirebase(
      {required String userName,
      required BuildContext context,
      required String Useruid,
      required Community community,
      required String Link,
      required String title}) async {
    if (title.isNotEmpty && Link.isNotEmpty) {
      state=true;
      containerRepositry.setToFirebase(type: "Link",
          context: context,
          userName: userName,
          community: community,
          Useruid: Useruid,
          Link: Link,
          title: title);
          state=false;
    }
      }
  Stream<List<ContainerModel>> getPostDetails(List<Community> commuinty){
    if(commuinty.isNotEmpty){
    return containerRepositry.getDetailsPost(commuinty);
    }
  
  return Stream.value([]);
} 

Stream<ContainerModel> getUserId(String id){
  return containerRepositry.getPostByUserDetails(id);
}

void addComments({required String comments,
      required BuildContext context,
      required String UserPhoto,
      required String Postid,
      required String UserID,
      required String CommuintyName}){
  containerRepositry.saveComments(PostID: Postid,comments: comments, context: context, UserPhoto: UserPhoto,  UserID: UserID, CommuintyName: CommuintyName);

}

Stream<List<ContainerModel>> getUserPostDetails ({required String uid,required BuildContext context}){
  return containerRepositry.getUserPostDetails(uid);
  

}
Stream<List<Comments>> getCommentsDetails({required String PostID}){
  return containerRepositry.getListOfComments(PostID:PostID );
}


}