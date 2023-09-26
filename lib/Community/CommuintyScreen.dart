import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/Community/CummuintyContolller.dart';
import 'package:reddit/utils/LoderScreen.dart';

class CommunityCreate extends ConsumerStatefulWidget {
  final String uid;
  CommunityCreate({required this.uid,super.key});
  @override
  ConsumerState<CommunityCreate> createState() {
    return _CommunityCreate();
  }
}

class _CommunityCreate extends ConsumerState<CommunityCreate> {
  void CreateCommuinty(String id)async {
   ref.watch(commuintyContoller.notifier).createCommuinty(
          CommunityNameContoller.text.trim(),
          context,id
        );
  }

  final TextEditingController CommunityNameContoller = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    CommunityNameContoller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoding=ref.watch(commuintyContoller);

    return 
    Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Create a Community",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )),
      body:isLoding?LoderScreen(): Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Community Name",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: CommunityNameContoller,
              showCursor: true,
              maxLength: 21,
              decoration: InputDecoration(
                hintText: "r/Community_name",
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
                onPressed: () {
                  CreateCommuinty(widget.uid);

                },
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50)),
                child:
                    Text("Create Community", style: TextStyle(fontSize: 15))),
          )
        ],
      ),
    );
  }
}
