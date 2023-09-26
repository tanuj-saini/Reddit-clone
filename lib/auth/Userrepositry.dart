import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit/auth/LoginScreen.dart';
import 'package:reddit/auth/UserModel.dart';
import 'package:reddit/constants/constants.dart';
import 'package:reddit/HomeScreen.dart';
import 'package:reddit/utils/errorScreen.dart';
import 'package:reddit/utils/failuer.dart';

final authRepositry = Provider((ref) => AuthRepositry(
    signIn: GoogleSignIn(),
    firebaseFirestore: FirebaseFirestore.instance,
    firebaseAuth: FirebaseAuth.instance));

class AuthRepositry {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn signIn;

  AuthRepositry(
      {required this.signIn,
      required this.firebaseFirestore,
      required this.firebaseAuth});
  void signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await signIn.signIn();
      final credential = GoogleAuthProvider.credential(
        accessToken: (await googleUser?.authentication)?.accessToken,
        idToken: (await googleUser?.authentication)?.idToken,
      );
      UserCredential usercredential =
          await firebaseAuth.signInWithCredential(credential);
      print(usercredential.user?.email);
      String userName = usercredential.user!.displayName ?? 'No Name';

      String photoUrlUser = usercredential.user!.photoURL ?? "eoe";
      UserDetails userD;
      if (usercredential.additionalUserInfo!.isNewUser) {
        userD = UserDetails(
            userName: userName,
            photoURL: photoUrlUser,
            banner: Constants.bannerDefault,
            uid: usercredential.user!.uid,
            isAuthenticated: true,
            awards: [],
            Karma: 0);

        await firebaseFirestore
            .collection('users')
            .doc(firebaseAuth.currentUser!.uid)
            .set(userD.toMap());
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => TestDart(userId: firebaseAuth.currentUser!.uid)));
      }
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => TestDart(userId: firebaseAuth.currentUser!.uid)));
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    } catch (e) {
      e.toString();
    }
  }

  void signOutWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await signIn.signOut();

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => LoginScreen()));
    } on FirebaseAuthException catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  Future<UserDetails?> getUserDetails() async {
    var userData = await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser?.uid)
        .get();
    UserDetails? user;
    if (userData.data() != null) {
      user = UserDetails.fromMap(userData.data()!);
    }

    return user;
  }

  Future<UserDetails?> getUserDetailsbyId(String uid) async {
    var userData = await firebaseFirestore.collection('users').doc(uid).get();
    UserDetails? user;
    if (userData.data() != null) {
      user = UserDetails.fromMap(userData.data()!);
    }

    return user;
  }

  Future editProfileImage({required UserDetails userDetails}) async {
    await firebaseFirestore
        .collection('users')
        .doc(userDetails.uid)
        .update(userDetails.toMap());
  }

  Stream<UserDetails> getUserData(String userId) {
    return firebaseFirestore
        .collection("users")
        .doc(userId)
        .snapshots()
        .asyncMap((event) async {
      UserDetails user = await UserDetails.fromMap(event.data()!);
      return user;
    });
  }

  Future<String?> getUsernameByUserId(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        return userDoc.data()?['username'];
      } else {
        return null; // User not found
      }
    } catch (e) {
      print('Error getting username: $e');
      return null;
    }
  }

  Stream<UserDetails> userData(String userId) {
    return firebaseFirestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((event) => UserDetails.fromMap(event.data()!));
  }

  Stream<List<UserDetails>> commuintyDetails() {
    return firebaseFirestore
        .collection('users')
        .snapshots()
        .asyncMap((event) async {
      List<UserDetails> listC = [];

      for (var document in event.docs) {
        listC.add(UserDetails.fromMap(document.data()));
      }
      return listC;
    });
  }
}
