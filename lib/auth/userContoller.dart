import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/auth/UserModel.dart';
import 'package:reddit/auth/Userrepositry.dart';
import 'package:reddit/constants/storagePhoto.dart';
import 'package:reddit/utils/errorScreen.dart';

final authContoller = Provider((ref) {
  final authRepo = ref.read(authRepositry);
  final StaorageMethodfile = ref.watch(StorageMethodProvider);
  return AuthController(
      storageMethodProvider: StaorageMethodfile,
      ref: ref,
      authRepositry: authRepo);
});

final userDataAuthProvider = FutureProvider((ref) {
  final authContoller = ref.watch(authRepositry);
  return authContoller.getUserDetails();
});

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authRepositry);
  return authController.getUserData(uid);
});

class AuthController {
  final ProviderRef ref;
  final AuthRepositry authRepositry;
  final StorageMethod storageMethodProvider;
  AuthController(
      {required this.storageMethodProvider,
      required this.ref,
      required this.authRepositry});
  void signInWIthGoogle(BuildContext context) {
    authRepositry.signInWithGoogle(context);
  }

  Future<UserDetails?> getUserDetails() async {
    UserDetails? user = await authRepositry.getUserDetails();

    return user;
  }

  Future<UserDetails?> getUserDetailsbiId(String uid) async {
    UserDetails? user = await authRepositry.getUserDetailsbyId(uid);

    return user;
  }

  Future<String?> getUserDetailsbyUserId(String uid) async {
    String? user = await authRepositry.getUsernameByUserId(uid);
    return user;
  }

  void signOUtWithGoogle(BuildContext context) {
    authRepositry.signOutWithGoogle(context);
  }

  Stream<UserDetails> userData(String userId) {
    return authRepositry.getUserData(userId);
  }

  Stream<List<UserDetails>> listUsers() {
    return authRepositry.commuintyDetails();
  }

  void editProfilePic({
    required File? bannerFile,
    required File? bannnerProfile,
    required UserDetails userDetails,
    required BuildContext context,
  }) async {
    if (bannnerProfile != null) {
      String uidd = userDetails.uid;
      var prof = await ref.watch(StorageMethodProvider).uploadFile(
          uid: userDetails.uid,
          context: context,
          childname: 'UserImage/Profile/$uidd',
          file: bannnerProfile);

      userDetails = userDetails.copyWith(photoURL: prof);
      showSnackBar('Sucessfully Uploded', context);
    }
    if (bannerFile != null) {
      String uidd = userDetails.uid;
      var bannerF = await ref.watch(StorageMethodProvider).uploadFile(
          uid: userDetails.uid,
          context: context,
          childname: 'UserImage/backGroundImage/$uidd',
          file: bannerFile);
      userDetails = userDetails.copyWith(banner: bannerF);
      showSnackBar('Sucessfully Uploded', context);
      Navigator.of(context).pop();
    }
    await authRepositry.editProfileImage(userDetails: userDetails);
  }
}
