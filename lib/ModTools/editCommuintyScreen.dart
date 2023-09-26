import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reddit/Community/CommuintyMiodel.dart';
import 'package:reddit/Community/CommunityRepoditry.dart';
import 'package:reddit/Community/CummuintyContolller.dart';
import 'package:reddit/auth/UserModel.dart';
import 'package:reddit/auth/userContoller.dart';
import 'package:reddit/constants/constants.dart';
import 'package:reddit/constants/storagePhoto.dart';
import 'package:reddit/utils/LoderScreen.dart';
import 'package:reddit/utils/PickerImage.dart';
import 'package:reddit/utils/themeColor.dart';

class EditingComuintyScreen extends ConsumerStatefulWidget {
  final String uid;
  final String name;
  EditingComuintyScreen({required this.name, required this.uid, super.key});
  @override
  ConsumerState<EditingComuintyScreen> createState() {
    return _EditingComuintyScreen();
  }
}

class _EditingComuintyScreen extends ConsumerState<EditingComuintyScreen> {
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

  File? bannerProfileFile;
  void selectedbannerProfileImage() async {
    final res = await pickkImage();
    print(res);
    if (res != null) {
      setState(() {
        bannerProfileFile = File(res.files.first.path!);
      });
    }
  }

  void save(Community commuinty) {
    ref.watch(commuintyContoller.notifier).editCommuinty(
        bannerFile: bannerFile,
        context: context,
        profile: bannerProfileFile,
        community: commuinty);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(commuintyContoller);
    return StreamBuilder(
        stream: ref
            .watch(commuintyContoller.notifier)
            .getCommuintyNameDetails(widget.name),
        builder: (context, snapshot) => Scaffold(
              appBar: AppBar(
                title: Text("Edit Community"),
                actions: [
                  TextButton(
                      onPressed: () {
                        save(snapshot.data!);
                      },
                      child: Text('Save'))
                ],
              ),
              body: isLoading
                  ? LoderScreen()
                  : Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
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
                                        color:
                                            Color.fromARGB(255, 226, 202, 202),
                                        child: Container(
                                          width: double.infinity,
                                          height: 150,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child:isLoading?LoderScreen(): bannerFile != null
                                              ? Image.file(bannerFile!)
                                              : snapshot.data!.banner.isEmpty ||
                                                      snapshot.data!.banner ==
                                                          Constants
                                                              .bannerDefault
                                                  ? const Center(
                                                      child: Icon(
                                                        Icons
                                                            .camera_alt_outlined,
                                                        size: 40,
                                                      ),
                                                    )
                                                  : Image.network(
                                                      snapshot.data!.banner),
                                        ),
                                      ))),
                              Positioned(
                                  child: isLoading?LoderScreen(): IconButton(
                                      onPressed: selectedbannerProfileImage,
                                      icon: bannerProfileFile != null
                                          ? CircleAvatar(
                                              radius: 30,
                                              backgroundImage:
                                                  FileImage(bannerProfileFile!),
                                            )
                                          : CircleAvatar(
                                              radius: 30,
                                              backgroundImage: NetworkImage(
                                                  Constants.avatarDefault),
                                            )),
                                  top: 100,
                                  left: 30)
                            ],
                          ),
                        ),
                      ],
                    ),
            ));
  }
}
