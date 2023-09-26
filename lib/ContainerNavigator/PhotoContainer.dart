import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/Community/CommuintyMiodel.dart';
import 'package:reddit/Community/CummuintyContolller.dart';
import 'package:reddit/ContainerNavigator/ContainerConttoller.dart';
import 'package:reddit/utils/LoderScreen.dart';
import 'package:reddit/utils/PickerImage.dart';
import 'package:reddit/utils/errorScreen.dart';

class PhotoContainer extends ConsumerStatefulWidget {
  final String username;
  final String uid;
  PhotoContainer({required this.uid,required this.username,super.key});
  @override
  ConsumerState<PhotoContainer> createState() {
    return _PhotoContainer();
  }
}

class _PhotoContainer extends ConsumerState<PhotoContainer> {
    List<Community> commuintyName = [];
  Community? selectedCommuinty;
  File? image;

  get storageMethodProvider => null;
  void selectedbannerImage() async {
    final res = await pickkImage();
    print(res);
    if (res != null) {
      setState(() {
        image = File(res.files.first.path!);
      });
    }
  }
  void sendTofirebase({required String userName,
    required String uid,
    required String title,
  required File? post,
    required Community community,
    })async{
    ref.watch(containerProviderContoller.notifier).setDetailsPostTOFirebase(userName: userName, context: context, Useruid: uid, community: community, post: post, title: title);

  }

  final TextEditingController titleContoller = TextEditingController();
  @override
  Widget build(BuildContext context) {
     final isLoding=ref.watch(containerProviderContoller);
    return Scaffold(
      appBar: AppBar(
          title: Text("PostPhoto"),
          centerTitle: true,
          actions: [TextButton(onPressed: () {
            sendTofirebase(userName: widget.username, uid: widget.uid, title: titleContoller.text, post:image, community:selectedCommuinty! );
          }, child: Text("Share"))]
          ),
      body:isLoding?LoderScreen(): SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: TextField(
              controller: titleContoller,
              maxLength: 30,
              decoration: InputDecoration(
                hintText: "Enter Tilte Here",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
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
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: image != null
                          ? Image.file(image!)
                          : Center(
                              child: Icon(
                                Icons.camera_alt_outlined,
                                size: 40,
                              ),
                            ))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: Align(
                alignment: Alignment.topLeft, child: Text("Select Commuinty",style: TextStyle(fontSize: 18),)),
                
          ),
           ref.watch(commuintyDetailsss(widget.uid)).when(
                  data: (data) {
                    commuintyName = data;
                    if (data.isEmpty) {
                      return const SizedBox();
                    }
                    return Align(alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: DropdownButton(
                            value: selectedCommuinty??data[0],
                            items: data
                                .map((e) => DropdownMenuItem(
                                    value: e, child: Text(e.name)))
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                selectedCommuinty = val;
                              });
                            }),
                      ),
                    );
                  },
                  error: (err, trace) {
                    return showSnackBar(err.toString(), context);
                  },
                  loading: () => LoderScreen())
        ]),
      ),
    );
  }
}
