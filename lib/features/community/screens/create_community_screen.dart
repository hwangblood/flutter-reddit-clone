import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final communityNameController = TextEditingController();

  @override
  void dispose() {
    communityNameController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a community'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text('Community name'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: communityNameController,
            decoration: const InputDecoration(
              prefixText: 'r/',
              hintText: 'Community_name',
              filled: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16.0),
            ),
            maxLength: 21,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: null,
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
