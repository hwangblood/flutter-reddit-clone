import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  void navigateToCreateCommunity(BuildContext context) {
    // close drawer before navigating
    Scaffold.of(context).closeDrawer();

    Routemaster.of(context).push('/create-community');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: const Text('Create a community'),
              leading: const Icon(Icons.add),
              onTap: () => navigateToCreateCommunity(context),
            ),
            ref.watch(userCommunitiesProvider).when(
                  data: (communities) => Expanded(
                    // ListView would take the full height of the screen
                    child: ListView.builder(
                      // physics: const NeverScrollableScrollPhysics(),
                      itemCount: communities.length,
                      itemBuilder: (context, index) {
                        final community = communities.elementAt(index);
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(community.banner),
                          ),
                          title: Text('r/${community.name}'),
                          onTap: () {
                            // TODO: on tap community tile
                          },
                        );
                      },
                    ),
                  ),
                  error: (error, stackTrace) =>
                      ErrorText(message: error.toString()),
                  loading: () => const Loader(),
                ),
          ],
        ),
      ),
    );
  }
}
