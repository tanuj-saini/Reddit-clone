import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/Community/CommuintyMiodel.dart';
import 'package:reddit/Community/CummuintyContolller.dart';
import 'package:reddit/ContainerNavigator/CommentsModel.dart';
import 'package:reddit/ContainerNavigator/ContainerModel.dart';
import 'package:reddit/HomeScreen.dart';
import 'package:reddit/features/HomeLayout.dart';
import 'package:reddit/utils/errorScreen.dart';
import 'package:uuid/uuid.dart';

final containerPRovider = Provider(
    (ref) => ContainerRepositry(firebaseFirestore: FirebaseFirestore.instance));

class ContainerRepositry {
  final FirebaseFirestore firebaseFirestore;

  ContainerRepositry({required this.firebaseFirestore});

  void setToFirebase(
      {required BuildContext context,
      required String userName,
      required Community community,
      required String type,
      required String Useruid,
      required String Link,
      required String title}) async {
    String randomuid = Uuid().v1();
    ContainerModel user = ContainerModel(
        type: type,
        randomuid: randomuid,
        CreatedAt: DateTime.now().microsecondsSinceEpoch,
        commuintyName: community.name,
        communityProfile: community.avatar,
        Link: Link,
        title: title,
        upVotes: [],
        downVotes: [],
        commentCount: 0,
        username: userName,
        uid: Useruid,
        awards: []);

    await firebaseFirestore
        .collection("Posts")
        .doc(randomuid)
        .set(user.toMap());

    showSnackBar("Sucessfully Updated", context);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => TestDart(userId: Useruid)));
  }

  Stream<List<ContainerModel>> getDetailsPost(List<Community> community) {
    return firebaseFirestore
        .collection("Posts")
        .where('communityName', whereIn: community.map((e) => e.name).toList())
        .orderBy('CreatedAt', descending: true)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => ContainerModel.fromMap(e.data())).toList());
  }

  Future deletePost(String uid, BuildContext context) async {
    try {
      await firebaseFirestore.collection('Posts').doc(uid).delete();
    } on FirebaseException catch (e) {
      showSnackBar(e.message!, context);
    }
  }

  Future UpvotePost(ContainerModel model, String uid) async {
    if (model.downVotes.contains(uid)) {
      await firebaseFirestore.collection('Posts').doc(model.randomuid).update({
        "downVotes": FieldValue.arrayRemove([uid]),'upVotes':FieldValue.arrayRemove([uid])
      });
    }
    if (model.upVotes.contains(uid)) {
      await firebaseFirestore.collection('Posts').doc(model.randomuid).update({
        "upVotes": FieldValue.arrayRemove([uid])
      });
    } else {
      await firebaseFirestore.collection('Posts').doc(model.randomuid).update({
        "upVotes": FieldValue.arrayUnion([uid])
      });
    }
  }

  Future DownvotePost(ContainerModel model, String uid) async {
    if (model.downVotes.contains(uid)) {
      await firebaseFirestore.collection('Posts').doc(model.randomuid).update({
        "downVotes": FieldValue.arrayRemove([uid])
      });
    }
    if (model.upVotes.contains(uid)) {
      await firebaseFirestore.collection('Posts').doc(model.randomuid).update({
        "upVotes": FieldValue.arrayRemove([uid]),"downVotes":FieldValue.arrayUnion([uid]),
      });
    } else {
      await firebaseFirestore.collection('Posts').doc(model.randomuid).update({
        "downVotes": FieldValue.arrayUnion([uid])
      });
    }
  }

  Stream<ContainerModel> getPostByUserDetails(String PostId) {
    return firebaseFirestore
        .collection('Posts')
        .doc(PostId)
        .snapshots()
        .asyncMap((event) async {
      ContainerModel model = ContainerModel.fromMap(event.data()!);
      return model;
    });
  }

  void saveComments(
      {required String comments,
      required BuildContext context,
      required String UserPhoto,
      required String UserID,
      required String PostID,
      required String CommuintyName}) async {
    String CommentsId = Uuid().v1();
    try {
      Comments coomments = Comments(
          ProfileUrl: UserPhoto,
          CreatedAt: DateTime.now(),
          UserId: UserID,
          PostId: PostID,
          comments: comments,
          CommentsId: CommentsId,
          CommuintyName: CommuintyName);
      await firebaseFirestore
          .collection('Comments')
          .doc(CommentsId)
          .set(coomments.toMap());
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  Stream<List<Comments>> getListOfComments({required String PostID}) {
    return firebaseFirestore
        .collection('Commments')
        .where("PostId", isEqualTo: PostID)
        .snapshots()
        .asyncMap((event) {
      List<Comments> comm = [];
      for (var document in event.docs) {
        comm.add(Comments.fromMap(document.data()));
      }
      return comm;
    });
  }

  Stream<List<ContainerModel>> getUserPostDetails(String uid) {
    return firebaseFirestore
        .collection("Posts")
        .where("")
        .snapshots()
        .map((event) {
      List<ContainerModel> post = [];

      for (var document in event.docs) {
        post.add(ContainerModel.fromMap(document.data()));
      }
      return post;
    });
  }
}
