import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/providers/storage_repository_provider.dart';
import 'package:reddit_clone/core/type_defs.dart';
import 'package:reddit_clone/core/utils/snack_bar_util.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/repository/community_repository.dart';
import 'package:reddit_clone/models/community_model.dart';

final userCommunitiesProvider = StreamProvider<List<CommunityModel>>((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getUserCommunities();
});

final getCommunityByNameProvider =
    StreamProvider.family<CommunityModel, String>(
  (ref, String name) =>
      ref.watch(communityControllerProvider.notifier).getCommunityByName(name),
);

final communityControllerProvider =
    StateNotifierProvider<CommunityController, IsLoading>(
  (ref) => CommunityController(
    communityRepository: ref.watch(communityRepositoryProvider),
    storageRepository: ref.watch(storageRepositoryProvider),
    ref: ref,
  ),
);

class CommunityController extends StateNotifier<IsLoading> {
  final CommunityRepository _communityRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;

  CommunityController({
    required CommunityRepository communityRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  })  : _communityRepository = communityRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  void createCommunity(BuildContext context, String name) async {
    state = true;

    final uid = _ref.read(userProvider)?.uid ?? '';
    final community = CommunityModel(
      id: name,
      name: name,
      banner: AssetsConstants.bannerDefault,
      avatar: AssetsConstants.avatarDefault,
      members: [uid],
      mods: [uid],
    );

    final res = await _communityRepository.createCommunity(community);
    state = false;

    res.fold(
      (l) => SnackBarUtil.showSnackBar(context, message: l.message),
      (r) {
        SnackBarUtil.showSnackBar(
          context,
          message: 'Community created successfully!',
        );
        Routemaster.of(context).pop();
      },
    );
  }

  Stream<List<CommunityModel>> getUserCommunities() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommunities(uid);
  }

  Stream<CommunityModel> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }

  /// update the community , avatar or banner
  void editCommunity(
    BuildContext context, {
    required File? profileFile,
    required File? bannerFile,
    required CommunityModel community,
  }) async {
    state = true;

    if (profileFile != null) {
      // * communities/profile/:name.jpg
      final res = await _storageRepository.storeFile(
        path: 'communities/profile',
        id: community.name,
        file: profileFile,
      );
      res.fold(
        (l) => SnackBarUtil.showSnackBar(context, message: l.message),
        (url) => community = community.copyWith(avatar: url),
      );
    }
    if (bannerFile != null) {
      // * communities/banner/:name.jpg
      final res = await _storageRepository.storeFile(
        path: 'communities/banner',
        id: community.name,
        file: bannerFile,
      );
      res.fold(
        (l) => SnackBarUtil.showSnackBar(context, message: l.message),
        (url) => community = community.copyWith(banner: url),
      );
    }

    final res = await _communityRepository.editCommunity(community);

    state = false;
    res.fold(
      (l) => SnackBarUtil.showSnackBar(context, message: l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }
}
