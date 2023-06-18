import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/type_defs.dart';
import 'package:reddit_clone/core/utils/snack_bar_util.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/repository/community_repository.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

final communityControllerProvider =
    StateNotifierProvider<CommunityController, IsLoading>(
  (ref) => CommunityController(
    communityRepository: ref.watch(communityRepositoryProvider),
    ref: ref,
  ),
);

class CommunityController extends StateNotifier<IsLoading> {
  final CommunityRepository _communityRepository;
  final Ref _ref;
  CommunityController({
    required CommunityRepository communityRepository,
    required Ref ref,
  })  : _communityRepository = communityRepository,
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
}
