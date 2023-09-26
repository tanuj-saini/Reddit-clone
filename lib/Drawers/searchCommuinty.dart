import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/Community/CommuintyMiodel.dart';
import 'package:reddit/Community/CommunityRepoditry.dart';
import 'package:reddit/Community/CummuintyContolller.dart';
import 'package:reddit/Community/CummunityProfileScreen.dart';

class SearchCommuinty extends SearchDelegate {
  final WidgetRef ref;

  SearchCommuinty(this.ref);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder(
      stream: ref.watch(commuintyContoller.notifier).listOFCommuinty(query),
      builder: (context, snapshot) {
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final community = snapshot.data![index];
            return ListTile(
              leading:
                  CircleAvatar(backgroundImage: NetworkImage(community.avatar)),
              title: Text(community.name),
              onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>CommuintyProfileScreen(id: community.id, name:community.name )));},
            );
          },
        );
      },
    );
  }
}
