import '../../../data/data.dart';
import '../../../utils/export/ui_export.dart';

class RideNeedPaymentDialog extends StatefulWidget {
  const RideNeedPaymentDialog({
    Key? key,
    this.confirmTitle,
    required this.onConfirm,
    required this.compoundingCustomerCars,
    required this.rootContext,
  }) : super(key: key);
  final Function()? onConfirm;
  final String? confirmTitle;
  final List<CompoundingCarCustomerModel> compoundingCustomerCars;
  final BuildContext rootContext;

  @override
  State<RideNeedPaymentDialog> createState() => _RideNeedPaymentDialogState();
}

class _RideNeedPaymentDialogState extends State<RideNeedPaymentDialog> {
  late List<CompoundingCarCustomerModel> rides;

  @override
  void initState() {
    rides = widget.compoundingCustomerCars;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(AppIcons.alert),
              const SizedBox(height: 16),
              Text("Chuyến đi chưa xác nhận", style: AppStyles.s18w7),
              const SizedBox(height: 4),
              Text(
                "Chuyến đi bạn xác nhận thanh toán. Vui lòng xác nhận thanh toán cho các chuyến đi sau.",
                style: AppStyles.s14w4,
                textAlign: TextAlign.center,
              ),
              Container(
                constraints: const BoxConstraints(maxHeight: 300),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ListTripWithKeysContent(
                      rides,
                      onTap: (e) {
                        Navigator.pushNamed(
                          widget.rootContext,
                          Routes.tripDetail,
                          arguments: e,
                        ).then((value) async {
                          if (rides.isEmpty) {
                            AppDialog.I.closeDialog();
                          } else {
                            final either =
                                await GetIt.I<ICompoundingCarCtrlRepo>()
                                    .getNeedPaymentRides();

                            // sync
                            either.fold((l) => l.toString(), (r) {
                              if (r.isEmpty) {
                                AppDialog.I.closeDialog();
                              } else {
                                rides = r;
                                setState(() {});
                              }
                            });
                          }
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.maxFinite,
                child: ButtonWidget(
                    onClick: widget.onConfirm ??
                        () {
                          Navigator.pop(context);
                        },
                    radius: 12,
                    backgroundColor: AppColors.primaryMain +
                        AppColors.primaryLight.withOpacity(0.95),
                    child: Text(
                      "Đóng",
                      style: AppStyles.s16w6.withColor(AppColors.primaryMain),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomerCarKeysWidget extends StatelessWidget {
  const CustomerCarKeysWidget({Key? key, required this.data}) : super(key: key);
  final CompoundingCarCustomerModel data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1),
            blurRadius: 2,
            color: AppColors.black.withOpacity(0.05),
          )
        ],
        border: Border.all(color: AppColors.gray05, width: 1),
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.fromProvince?.provinceName ?? "",
                    style: AppStyles.s14w7.withColor(AppColors.primaryMain)),
                const SizedBox(height: 8),
                Text(
                  "Ngày giờ đi",
                  style: AppStyles.s12w4.withColor(
                    AppColors.gray60x9d,
                  ),
                ),
                const SizedBox(height: 4),
                Text(data.expectedGoingOnDate?.getDateTimeString ?? "",
                    style: AppStyles.s14w7.withColor(AppColors.utilRed))
              ],
            ),
          ),
          Column(
            children: [
              data.compoundingType!.getSvg(
                color: data.compoundingType!.colorByTrip,
              ),
              Text("${data.distance!.ceil()}km"),
              Container(
                height: 30,
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: const VerticalDivider(
                  thickness: 1.5,
                  color: AppColors.gray20,
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(data.toProvince?.provinceName ?? "",
                    style: AppStyles.s14w7.withColor(AppColors.orangeMain)),
                const SizedBox(height: 8),
                Text(
                  "Ngày giờ về",
                  style: AppStyles.s12w4.withColor(
                    AppColors.gray60x9d,
                  ),
                ),
                const SizedBox(height: 4),
                Text(data.expectedPickingUpDate?.getDateTimeString ?? "---",
                    style: AppStyles.s14w7.withColor(AppColors.primaryMain))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ListTripWithKeysContent extends StatefulWidget {
  const ListTripWithKeysContent(this.customerCars, {Key? key, this.onTap})
      : super(key: key);
  final List<CompoundingCarCustomerModel> customerCars;
  final Function(CompoundingCarCustomerModel item)? onTap;

  @override
  State<ListTripWithKeysContent> createState() =>
      _ListTripWithKeysContentState();
}

class _ListTripWithKeysContentState extends State<ListTripWithKeysContent> {
  bool showMore = false;

  @override
  Widget build(BuildContext context) {
    final items = List<Widget>.generate(
      widget.customerCars.length,
      (index) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: index < widget.customerCars.length - 1 ? 8 : 0),
          child:
              TripWithKeysContent(widget.customerCars[index]).gestureDetector(
            onTap: () {
              widget.onTap?.call(widget.customerCars[index]);
            },
          ),
        );
      },
    );

    if (showMore && items.length > 3) {
      return SizedBox(
        height: 300,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 4),
          children: items,
        ),
      );
    }
    return Column(
      children: [
        ...items.take(3),
        if (!showMore && items.length > 3) ...[
          const SizedBox(height: 8),
          Text(
            "Xem thêm",
            style: AppStyles.s12w4.withColor(AppColors.gray70x76),
          ).inkWell(
            onTap: () {
              setState(() {
                showMore = true;
              });
            },
            decoration: BoxDecoration(
              color: AppColors.gray10,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          ),
        ]
      ],
    );
  }
}

class TripWithKeysContent extends StatelessWidget {
  const TripWithKeysContent(this.data, {Key? key}) : super(key: key);
  final CompoundingCarCustomerModel data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1),
            blurRadius: 2,
            color: AppColors.black.withOpacity(0.05),
          )
        ],
        border: Border.all(color: AppColors.gray05, width: 1),
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.fromProvince?.provinceName ?? "",
                    style: AppStyles.s14w7.withColor(AppColors.primaryMain)),
                const SizedBox(height: 8),
                Text(
                  "Ngày giờ đi",
                  style: AppStyles.s12w4.withColor(
                    AppColors.gray60x9d,
                  ),
                ),
                const SizedBox(height: 4),
                Text(data.expectedGoingOnDate?.getDateTimeString ?? "",
                    style: AppStyles.s14w7.withColor(AppColors.utilRed))
              ],
            ),
          ),
          Column(
            children: [
              data.compoundingType!.getSvg(
                color: data.compoundingType!.colorByTrip,
              ),
              Text("${data.distance!.ceil()}km"),
              Container(
                height: 30,
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: const VerticalDivider(
                  thickness: 1.5,
                  color: AppColors.gray20,
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(data.toProvince?.provinceName ?? "",
                    style: AppStyles.s14w7.withColor(AppColors.orangeMain)),
                const SizedBox(height: 8),
                Text(
                  "Ngày giờ về",
                  style: AppStyles.s12w4.withColor(
                    AppColors.gray60x9d,
                  ),
                ),
                const SizedBox(height: 4),
                Text(data.expectedPickingUpDate?.getDateTimeString ?? "---",
                    style: AppStyles.s14w7.withColor(AppColors.primaryMain))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
