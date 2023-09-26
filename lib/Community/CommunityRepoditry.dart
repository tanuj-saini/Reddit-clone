import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/Community/CommuintyMiodel.dart';
import 'package:reddit/utils/errorScreen.dart';
import 'package:reddit/utils/type_def.dart';

final communityRepositry = Provider((ref) => CommunityRepositry(
    firebaseFirestore: FirebaseFirestore.instance,
    firebaseAuth: FirebaseAuth.instance));

class CommunityRepositry {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;

  CommunityRepositry(
      {required this.firebaseFirestore, required this.firebaseAuth});

  Future CommunitySendToFirebase(
      BuildContext context, Community community) async {
    try {
      var commuintDoc = await firebaseFirestore
          .collection("Commuinty")
          .doc(community.name)
          .get();
      if (commuintDoc.exists) {
        return showSnackBar("Commuinty Name Already exits", context);
      }

      await firebaseFirestore
          .collection('Commuinty')
          .doc(community.name)
          .set(community.toMap());
    } on FirebaseAuthException catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  Future putUser(
      {required String name,
      required String id,
      required BuildContext context}) async {
    try {
      print(id);
      print(name);
      return firebaseFirestore.collection("Commuinty").doc(name).update(
        {
          'members': FieldValue.arrayUnion([id])
        },
      );
    } catch (e) {
      return showSnackBar(e.toString(), context);
    }
  }

  Future SendtoFirebaseUidmode(
      List<String> string, String name, BuildContext context) async {
    await firebaseFirestore.collection('Commuinty').doc(name).update({
      'members': string,
    });
    showSnackBar("Sucessfully Updated", context);
  }

  Future RemoveUser(
      {required String name,
      required String id,
      required BuildContext context}) async {
    try {
      print(id);
      print(name);
      return firebaseFirestore.collection("Commuinty").doc(name).update(
        {
          'members': FieldValue.arrayRemove([id])
        },
      );
    } catch (e) {
      return showSnackBar(e.toString(), context);
    }
  }

  Stream<List<Community>> commuintyDetails(String uid) {
    print(uid);
    return firebaseFirestore
        .collection('Commuinty')
        .where('members', arrayContains: uid)
        .snapshots()
        .asyncMap((event) async {
      List<Community> listC = [];

      for (var document in event.docs) {
        listC.add(Community.fromMap(document.data()));
      }
      return listC;
    });
  }

  Stream<Community> commuintyNameDetails(String name) {
    return firebaseFirestore
        .collection('Commuinty')
        .doc(name)
        .snapshots()
        .map((event) => Community.fromMap(event.data()!));
  }

  Future editCommuinty(Community community, BuildContext context) async {
    try {
      return await firebaseFirestore
          .collection("Commuinty")
          .doc(community.name)
          .update(community.toMap());
    } on FirebaseAuthException catch (e) {
      return showSnackBar(e.message!, context);
    }
  }

  Stream<List<Community>> commuintyName(String queue) {
    return firebaseFirestore
        .collection('Commuinty')
        .where('name',
            isGreaterThanOrEqualTo: queue.isEmpty ? 0 : queue,
            isLessThan: queue.isEmpty
                ? null
                : queue.substring(0, queue.length - 1) +
                    String.fromCharCode(
                      queue.codeUnitAt(queue.length - 1) + 1,
                    ))
        .snapshots()
        .map((event) {
      List<Community> commuinties = [];
      for (var document in event.docs) {
        var commuinty = Community.fromMap(document.data());
        commuinties.add(commuinty);
      }
      return commuinties;
    });
  }
}
