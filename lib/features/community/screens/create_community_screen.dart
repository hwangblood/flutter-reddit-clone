import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final communityNameController = TextEditingController();

  bool canCreate = false;

  void handleNameChange(String value) {
    if (value.trim().isNotEmpty) {
      canCreate = true;
      setState(() {});
    }
  }

  @override
  void dispose() {
    communityNameController.clear();
    super.dispose();
  }

  void createCommunity() {
    ref.read(communityControllerProvider.notifier).createCommunity(
          context,
          communityNameController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a community'),
      ),
      body: isLoading
          ? const Loader()
          : ListView(
              padding: const EdgeInsets.all(12.0),
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text('Community name'),
                ),
                const SizedBox(height: 10),
                TextField(
                  autofocus: true,
                  controller: communityNameController,
                  decoration: const InputDecoration(
                    prefixText: 'r/',
                    hintText: 'Community_name',
                    filled: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.0),
                  ),
                  maxLength: 21,
                  onChanged: handleNameChange,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: !canCreate ? null : createCommunity,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Create community',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
    );
  }
}
