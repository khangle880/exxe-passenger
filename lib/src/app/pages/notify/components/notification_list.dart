import '../../../../data/data.dart';
import '../../../../utils/export/ui_export.dart';
import 'item_read.dart';

class NotificationListWidget extends StatefulWidget {
  const NotificationListWidget({
    Key? key,
    required this.groupTypes,
  }) : super(key: key);
  final MapEntry<NotificationTypeGroup, List<NotificationType>> groupTypes;

  @override
  State<NotificationListWidget> createState() => _NotificationListWidgetState();
}

class _NotificationListWidgetState extends State<NotificationListWidget> {
  late final INotificationRepo repo;
  late RemoveListener removeListener;
  late PaginationHelper<NotificationModel> controller;

  @override
  void initState() {
    super.initState();
    repo = GetIt.I();
    initController();
    _listenAppState();
  }

  @override
  void dispose() {
    super.dispose();
    removeListener();
  }

  List<int> getNotiIds(List<NotificationModel> list) {
    return list.map((e) => e.id?.ceil()).whereNotNull().toList();
  }

  void _listenAppState() {
    final appState = GetIt.I.get<AppState>();
    removeListener = appState.addListener((state) {
      if (state.isNewAction) {
        if (state.payload is NotificationTypeGroup &&
            state.payload == widget.groupTypes.key) {
          final promotionNotis = controller.items.where((element) =>
              element.type == NotificationType.promotionNotification);
          final transactionNotis = controller.items.where((element) =>
              element.type == NotificationType.transactionNotification);
          final compoundingNotis = controller.items.where((element) =>
              element.type == NotificationType.compoundingNotification);

          if (state.action == ActionStateEnum.readAllNoti) {
            /// read current tab
            _readNotification(
              promotionId: getNotiIds(promotionNotis.toList()),
              transactionId: getNotiIds(transactionNotis.toList()),
              compoundingId: getNotiIds(compoundingNotis.toList()),
            ).then((value) {
              /// update from server
              appState.createAction(ActionStateEnum.forceRefreshNoti);
            });

            /// read from local
            appState.createAction(ActionStateEnum.readAllNoti,
                object: List<NotificationModel>.from(controller.items));
          } else if (state.action == ActionStateEnum.deleteAllNoti) {
            /// delete current tab
            _deleteNotification(
              promotionId: getNotiIds(promotionNotis.toList()),
              transactionId: getNotiIds(transactionNotis.toList()),
              compoundingId: getNotiIds(compoundingNotis.toList()),
            ).then((value) {
              /// update from server
              appState.createAction(ActionStateEnum.forceRefreshNoti);
            });

            /// delete local
            appState.createAction(ActionStateEnum.deleteAllNoti,
                object: List<NotificationModel>.from(controller.items));
          }
        } else if (state.payload is List<NotificationModel>) {
          /// get noti in list
          final notis = state.payload as List<NotificationModel>;
          notisContain(NotificationModel noti) {
            return notis.firstWhereOrNull((e) => e == noti) != null;
          }

          /// sync local with read all
          if (state.action == ActionStateEnum.readAllNoti) {
            for (var element in controller.items) {
              if (notisContain(element)) {
                element.read = true;
              }
            }
            controller.callListeners();

            /// sync local with delete all
          } else if (state.action == ActionStateEnum.deleteAllNoti) {
            controller.items.removeWhere((element) => notisContain(element));
            if (controller.items.isEmpty) controller.run();
            controller.callListeners();
          }

          /// force refresh
        } else if (state.action == ActionStateEnum.forceRefreshNoti) {
          controller.refresh();

          /// sync read one noti
        } else if (state.action == ActionStateEnum.readNoti) {
          if (state.payload is NotificationModel) {
            final noti = state.payload as NotificationModel;
            _readNotification(
              promotionId: noti.type == NotificationType.promotionNotification
                  ? [noti.id!.ceil()]
                  : null,
              transactionId:
                  noti.type == NotificationType.transactionNotification
                      ? [noti.id!.ceil()]
                      : null,
              compoundingId:
                  noti.type == NotificationType.compoundingNotification
                      ? [noti.id!.ceil()]
                      : null,
            ).then((value) {
              GetIt.I<AppState>().updateNotificationCount(
                  GetIt.I.get<AppState>().currentState.notificationCount - 1);
            });
            controller.items.firstWhereOrNull((e) => e == noti)?.read = true;
            controller.callListeners();
          }

          /// sync delete one noti
        } else if (state.action == ActionStateEnum.deleteNoti) {
          if (state.payload is NotificationModel) {
            final noti = state.payload as NotificationModel;
            _deleteNotification(
              promotionId: noti.type == NotificationType.promotionNotification
                  ? [noti.id!.ceil()]
                  : null,
              transactionId:
                  noti.type == NotificationType.transactionNotification
                      ? [noti.id!.ceil()]
                      : null,
              compoundingId:
                  noti.type == NotificationType.compoundingNotification
                      ? [noti.id!.ceil()]
                      : null,
            ).then((value) {
              if (noti.read == false) {
                GetIt.I<AppState>().updateNotificationCount(
                    GetIt.I.get<AppState>().currentState.notificationCount - 1);
              }
            });
            controller.items.removeWhere((element) => element == noti);
            controller.callListeners();
          }
        }
      }
    });
  }

  void initController() {
    controller = PaginationHelper<NotificationModel>(
      limit: 20,
      shouldShow: (value) => value.shouldShow,
      asyncTask: (config) {
        return getNotifications(config).then((data) {
          config.canLoadMore = data.length == 20;
          return (data);
        }).catchError((e) {
          log(e.toString());
          throw e;
        });
      },
    );
    controller.run();
  }

  Future<List<NotificationModel>> getNotifications(
      PaginationConfig config) async {
    var result = await repo.getListNotification(
        offset: config.offset, notificationType: widget.groupTypes.value);
    return result.fold(
      (failure) {
        return Future.error(failure);
      },
      (data) {
        return data.notifications ?? [];
      },
    );
  }

  Future _readNotification({
    List<int>? promotionId,
    List<int>? transactionId,
    List<int>? compoundingId,
  }) async {
    var result = await repo.readNotification(
      promotionId: promotionId,
      transactionId: transactionId,
      compoundingId: compoundingId,
    );
    return result.fold(
      (failure) {
        return Future.error(failure);
      },
      (data) {
        return data;
      },
    );
  }

  Future _deleteNotification({
    List<int>? promotionId,
    List<int>? transactionId,
    List<int>? compoundingId,
  }) async {
    var result = await repo.deleteNotification(
      promotionId: promotionId,
      transactionId: transactionId,
      compoundingId: compoundingId,
    );
    return result.fold(
      (failure) {
        return Future.error(failure);
      },
      (data) {
        return data;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PaginationListView(
      emptyBuilder: (_) => Center(
        child: Text('Không có thông báo gần đây', style: AppStyles.s16w6),
      ),
      loadingEffectItemBuilder: (_, index) => ItemRead.shimmer(),
      length: () => controller.canShowItems.length,
      itemBuilder: (BuildContext context, int index) {
        final item = controller.canShowItems[index];
        return ItemRead(
          index: index,
          data: item,
          onDelete: (index) async {
            GetIt.I<AppState>()
                .createAction(ActionStateEnum.deleteNoti, object: item);
          },
        ).inkWell(
          onTap: () async {
            GetIt.I<AppState>()
                .createAction(ActionStateEnum.readNoti, object: item);
            if (item.type == NotificationType.transactionNotification) {
              Navigator.pushNamed(
                context,
                Routes.transactionDetail,
                arguments: {
                  'paymentId': item.id!,
                  'responseCode': '00',
                },
              );
            } else if (item.type == NotificationType.promotionNotification) {
              Navigator.pushNamed(context, Routes.promotionDetailPage,
                  arguments: {"promotionId": item.id!});
            } else {
              Navigator.pushNamed(
                context,
                Routes.tripDetail,
                arguments: CompoundingCarCustomerModel(
                  compoundingCarCustomerId:
                      (item as NotificationCompoundingModel)
                          .compoundingCarCustomerId,
                ),
              );
            }
          },
        );
      },
      paginationController: controller,
    );
  }
}
