import 'dart:developer';
import 'package:photo_manager/photo_manager.dart';

import '../../pagination/pagination_helper.dart';

class PickerAssetHelper {
  PaginationHelper<AssetEntity>? paginationHelper;
  final Function()? onRefresh;
  final RequestType requestType;
  AssetPathEntity? currentPath;

  PickerAssetHelper({
    this.onRefresh,
    this.paginationHelper,
    required this.requestType,
  });

  Future<PermissionState> init() {
    return PhotoManager.requestPermissionExtend().then((permission) async {
      log('requestPermissionExtend -- $permission');
      if (permission == PermissionState.authorized) {
        try {
          final albums = await PhotoManager.getAssetPathList(
              //If true, Return only one album with all resources -- Recent Album
              onlyAll: true,
              type: requestType);
          if (albums.isNotEmpty) {
            currentPath = albums.first;
            paginationHelper = PaginationHelper(asyncTask: (config) {
              return _getListImage(config, 20).then((data) {
                config.canLoadMore = data.length == 20;
                return (data);
              }).catchError((e) {
                log(e.toString());
                throw e;
              });
            }, onRefresh: () {
              onRefresh?.call();
            });
            paginationHelper?.run();
          }
        } catch (e) {
          return Future.error(e);
        }
      }
      return Future.value(permission);
    }, onError: (e) {
      return Future.value(e);
    });
  }

  Future<List<AssetEntity>> _getListImage(
      PaginationConfig config, int limit) async {
    if (currentPath != null) {
      return await currentPath!.getAssetListPaged(
        page: config.offset ~/ limit,
        size: limit,
      );
    } else {
      return Future.error('please_provide_permission');
    }
  }
}
