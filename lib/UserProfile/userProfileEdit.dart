import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/ContainerNavigator/ContainerConttoller.dart';
import 'package:reddit/auth/UserModel.dart';
import 'package:reddit/auth/userContoller.dart';
import 'package:reddit/constants/constants.dart';
import 'package:reddit/features/postCard.dart';
import 'package:reddit/utils/LoderScreen.dart';
import 'package:reddit/utils/PickerImage.dart';
import 'package:reddit/utils/errorScreen.dart';

class UserProfileEdit extends ConsumerStatefulWidget {
  final String uid;
  UserProfileEdit({required this.uid, super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _UserProfileEdit();
  }
}

class _UserProfileEdit extends ConsumerState<UserProfileEdit> {
  File? bannerProfileFile;
  File? bannerFile;

  void selectedbannerImage() async {
    final res = await pickkImage();
    print(res);
    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void selectedbannerProfileImage() async {
    final res = await pickkImage();
    if (res != null) {
      setState(() {
        bannerProfileFile = File(res.files.first.path!);
      });
    }
  }

  void save(UserDetails userDetails) {
    ref.watch(authContoller).editProfilePic(
        bannerFile: bannerFile,
        bannnerProfile: bannerProfileFile,
        userDetails: userDetails,
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authContoller);
    
    return StreamBuilder(
      stream: ref.watch(authContoller).userData(widget.uid),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Text("My Profile"),
            centerTitle: true,
            actions: [
              TextButton(
                  onPressed: () => save(snapshot.data!), child: Text("Save")),
            ],
          ),
          body: GestureDetector(
            onTap: () {
              selectedbannerImage();
            },
            child: Stack(
              children: [
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: () {
                          selectedbannerImage();
                        },
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          dashPattern: const [10, 4],
                          strokeCap: StrokeCap.round,
                          color: Color.fromARGB(255, 226, 202, 202),
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            //size
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: bannerFile != null
                                ? Image.file(bannerFile!)
                                : snapshot.data!.banner.isEmpty ||
                                        snapshot.data!.banner ==
                                            Constants.bannerDefault
                                    ? const Center(
                                        child: Icon(
                                          Icons.camera_alt_outlined,
                                          size: 40,
                                        ),
                                      )
                                    : Image.network(snapshot.data!.banner),
                          ),
                        ))),
                Positioned(
                    child: IconButton(
                        onPressed: selectedbannerProfileImage,
                        icon: bannerProfileFile != null
                            ? CircleAvatar(
                                radius: 30,
                                backgroundImage: FileImage(bannerProfileFile!),
                              )
                            : CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    NetworkImage(Constants.avatarDefault),
                              )),
                    top: 100,
                    left: 30),
              ],
            ),
          ),
        );
      },
    );
  }
}
