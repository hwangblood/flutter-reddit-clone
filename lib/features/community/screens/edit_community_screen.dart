import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/constants/assets_constants.dart';
import 'package:reddit_clone/core/utils/file_picker_util.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  // name of the community
  final String name;
  const EditCommunityScreen({
    super.key,
    required this.name,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerFile;
  File? profileFile;

  Future<void> selectBannerImage() async {
    final res = await FilePickerUtil.pickImage();
    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  Future<void> selectProfileImage() async {
    final res = await FilePickerUtil.pickImage();
    if (res != null) {
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getCommunityByNameProvider(widget.name)).when(
          data: (community) {
            return Scaffold(
              appBar: AppBar(
                centerTitle: false,
                title: const Text('Edit Community'),
                actions: [
                  TextButton(
                    // TODO: only save edited community when data is available
                    onPressed: bannerFile == null && profileFile == null
                        ? null
                        : () {},
                    child: const Text('Save'),
                  ),
                ],
              ),
              body: ListView(
                padding: const EdgeInsets.all(8.0),
                children: [
                  SizedBox(
                    height: 200,
                    child: Stack(
                      children: [
                        GestureDetector(
                          // top to select a banner image
                          onTap: selectBannerImage,
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(10),
                            dashPattern: const [10, 4],
                            strokeCap: StrokeCap.round,
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color!,
                            child: Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: bannerFile != null
                                  ? Image.file(
                                      bannerFile!,
                                      fit: BoxFit.cover,
                                    )
                                  : community.banner.isEmpty ||
                                          community.banner ==
                                              AssetsConstants.bannerDefault
                                      ? const Center(
                                          child: Icon(
                                            Icons.camera_alt_outlined,
                                            size: 40,
                                          ),
                                        )
                                      : Image.network(
                                          community.banner,
                                          fit: BoxFit.cover,
                                        ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 20,
                          child: GestureDetector(
                            onTap: selectProfileImage,
                            child: profileFile != null
                                ? CircleAvatar(
                                    backgroundImage: FileImage(profileFile!),
                                    radius: 32,
                                  )
                                : CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(community.avatar),
                                    radius: 32,
                                  ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          error: (error, stackTrace) => ErrorText(message: error.toString()),
          loading: () => const Loader(),
        );
  }
}
