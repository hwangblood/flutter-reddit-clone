import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/home/delegates/search_community_delegate.dart';
import 'package:reddit_clone/features/home/drawers/community_list_drawer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  /// require the context from scaffold's child
  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // it shouldn't be null, when user is logged in
    final user = ref.watch(userProvider)!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Home'),
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => displayDrawer(context),
              icon: const Icon(Icons.menu),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchCommunityDelegate(ref),
              );
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: CircleAvatar(
              backgroundImage: NetworkImage(user.profilePic),
            ),
          ),
        ],
      ),
      body: Center(
        child: Text(user.name),
      ),
      drawer: const CommunityListDrawer(),
    );
  }
}
