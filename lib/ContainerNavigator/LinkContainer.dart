import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/Community/CommuintyMiodel.dart';
import 'package:reddit/Community/CummuintyContolller.dart';
import 'package:reddit/ContainerNavigator/ContainerConttoller.dart';
import 'package:reddit/utils/LoderScreen.dart';
import 'package:reddit/utils/errorScreen.dart';

class LinkContainer extends ConsumerStatefulWidget {
  final String username;
  final String uid;
  LinkContainer({required this.uid, required this.username, super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _LinkContainer();
  }
}

class _LinkContainer extends ConsumerState<LinkContainer> {
  final TextEditingController titleContoller = TextEditingController();
  final TextEditingController linkContoller = TextEditingController();
  List<Community> commuintyName = [];
  Community? selectedCommuinty;
  void sendTofirebase(
      {required String userName,
      required String uid,
      required String title,
      required Community community,
      required String Link}) {
    ref.watch(containerProviderContoller.notifier).setDetailsTextTOFirebase(
        userName: userName,
        context: context,
        Useruid: uid,
        community: community,
        Link: Link,
        title: title);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleContoller.dispose();
    linkContoller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoding = ref.watch(commuintyContoller);
    return Scaffold(
      appBar: AppBar(
        title: Text("PostLink"),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () {
                sendTofirebase(
                    userName: widget.username,
                    uid: widget.uid,
                    title: titleContoller.text,
                    community: selectedCommuinty!,
                    Link: linkContoller.text);
              },
              child: Text("Share")),
        ],
      ),
      body: isLoding
          ? LoderScreen()
          : Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  TextField(
                    controller: titleContoller,
                    maxLength: 30,
                    decoration: InputDecoration(
                      hintText: "Enter Title Here",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: linkContoller,
                    decoration: InputDecoration(
                      hintText: "Enter Link Here",
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Select Commuinty",
                        style: TextStyle(fontSize: 18),
                      )),
                  ref.watch(commuintyDetailsss(widget.uid)).when(
                      data: (data) {
                        commuintyName = data;
                        if (data.isEmpty) {
                          return const SizedBox();
                        }
                        return Align(
                          alignment: Alignment.topLeft,
                          child: DropdownButton(
                              value: selectedCommuinty ?? data[0],
                              items: data
                                  .map((e) => DropdownMenuItem(
                                      value: e, child: Text(e.name)))
                                  .toList(),
                              onChanged: (val) {
                               
                                setState(() {
                                  selectedCommuinty = val;
                                });
                              }),
                        );
                      },
                      error: (err, trace) {
                        return showSnackBar(err.toString(), context);
                      },
                      loading: () => LoderScreen())
                ],
              ),
            ),
    );
  }
}
