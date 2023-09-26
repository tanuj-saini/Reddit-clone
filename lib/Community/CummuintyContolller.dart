import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/Community/CommuintyMiodel.dart';
import 'package:reddit/Community/CommunityRepoditry.dart';
import 'package:reddit/Community/CummunityProfileScreen.dart';
import 'package:reddit/auth/Userrepositry.dart';
import 'package:reddit/constants/constants.dart';
import 'package:reddit/constants/storagePhoto.dart';
import 'package:reddit/utils/errorScreen.dart';
import 'package:uuid/uuid.dart';

final commuintyContoller =
    StateNotifierProvider<CommuintyContoller, bool>((ref) {
  final CommunityRepositryy = ref.watch(communityRepositry);
  final StaorageMethodfile = ref.watch(StorageMethodProvider);

  return CommuintyContoller(
      communityRepositry: CommunityRepositryy,
      ref: ref,
      storageMethodProvider: StaorageMethodfile);
});





final commuintyDetailsss
=StreamProvider.family((ref,String uid){
  final commuintyProviderr=ref.watch(communityRepositry);
  return commuintyProviderr.commuintyDetails(uid);
});






final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  return ref.watch(commuintyContoller.notifier).getCommuintyNameDetails(name);
});

class CommuintyContoller extends StateNotifier<bool> {
  final CommunityRepositry communityRepositry;
  final Ref ref;
  final StorageMethod storageMethodProvider;

  CommuintyContoller(
      {required this.storageMethodProvider,
      required this.communityRepositry,
      required this.ref})
      : super(false);
  void createCommuinty(
      String CommuintyName, BuildContext context, String id) async {
    state = true;

    Community community = Community(
        id: CommuintyName,
        name: CommuintyName,
        banner: Constants.bannerDefault,
        avatar: Constants.avatarDefault,
        members: [id],
        modes: [id]);
    await communityRepositry.CommunitySendToFirebase(context, community);
    state = false;
    showSnackBar("Commuinty Created Sucessfully!", context);
    Navigator.of(context).pop();
  }

  Stream<List<Community>> getCommuintyDetails(String uid) {
    return communityRepositry.commuintyDetails(uid);
  }

  Stream<Community> getCommuintyNameDetails(String name) {
    return communityRepositry.commuintyNameDetails(name);
  }

  void editCommuinty(
      {required File? bannerFile,
      required BuildContext context,
      required File? profile,
      required Community community}) async {
    try {
      if (profile != null) {
        state = true;
        final prof = await storageMethodProvider.uploadFile(
            uid: community.name,
            context: context,
            childname: "community/profile/memes",
            file: profile);
        community = community.copyWith(avatar: prof);
        // showSnackBar("Sucessfully Updates", context

        state = false;
      }

      if (bannerFile != null) {
        state = true;
        final ref = await storageMethodProvider.uploadFile(
            uid: community.name,
            context: context,
            childname: "community/banner/memes",
            file: bannerFile);
        community = community.copyWith(banner: ref);
        showSnackBar("Sucessfully Updates", context);

        state = false;
        Navigator.of(context).pop();
      }
      await communityRepositry.editCommuinty(community, context);
      print("error");
    } on FirebaseException catch (e) {
      showSnackBar(e.message!, context);
    }
  }

  void sendToFireUd(String commuintyName,List<String> string,BuildContext context)async{
  await  communityRepositry.SendtoFirebaseUidmode(string, commuintyName, context);


  }

  Stream<List<Community>> listOFCommuinty(String queue) {
    return communityRepositry.commuintyName(queue);
  }

  void addRemoveUser(
      Community community, BuildContext context, String uid) async {
    print(uid);
    if (community.members.contains(uid)) {
      await communityRepositry.RemoveUser(
          name: community.name, id: uid, context: context);
      showSnackBar("Remove Sucessfully", context);
    } else {
      await communityRepositry.putUser(
          name: community.name, id: uid, context: context);
      showSnackBar("Remove Sucessfully", context);
    }
  }
}
