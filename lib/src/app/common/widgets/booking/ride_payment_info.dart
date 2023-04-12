import '../../../../data/models/models.dart';
import '../../../../utils/export/ui_export.dart';

class RidePaymentInfo extends StatefulWidget {
  const RidePaymentInfo(
    this.data, {
    Key? key,
    this.onChangedTip,
    this.onChangedDownPaymentPercent,
  }) : super(key: key);
  final CompoundingCarCustomerModel data;
  final Function(int tip)? onChangedTip;
  final Function(double percent)? onChangedDownPaymentPercent;

  @override
  State<RidePaymentInfo> createState() => _RidePaymentInfoState();
}

class _RidePaymentInfoState extends State<RidePaymentInfo> {
  int tip = 0;
  late double percent;
  late final double originPercent;

  @override
  void initState() {
    percent = widget.data.downPayment?.percent?.toDouble() ?? 0;
    originPercent = widget.data.downPayment?.basis?.toDouble() ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final canPickTip =
        widget.data.state!.index <= CompoundingCarCustomerState.done.index &&
            widget.data.paymentMethod == null;
    final isArrived =
        widget.data.state!.index >= CompoundingCarCustomerState.done.index;

    return Column(
      children: [
        RideInfoRow(
          'Chi phí tạm tính',
          value: widget.data.amountUndiscounted!.ceil().currencyFormat,
          bold: true,
        ),
        RideInfoRow(
          "Khuyến mãi",
          value: widget.data.discountAfterTax?.ceil().currencyFormat,
          valueColor: AppColors.utilRed,
        ),
        const Divider(
          height: 2,
          thickness: 1.5,
        ),
        const SizedBox(height: 8),
        RideInfoRow(
          "Cước phí",
          value: widget.data.amountTotal?.ceil().currencyFormat,
          bold: true,
        ),
        if (widget.data.state!.index >=
            CompoundingCarCustomerState.done.index) ...[
          Builder(builder: (context) {
            final value = widget.data.overtimeSurcharge?.amount?.ceil() ?? 0;
            return RideInfoRow(
              "Phụ phí quá giờ (${widget.data.overtimeSurcharge?.numberExtraWaitingHour?.ceil()} × ${widget.data.overtimeSurcharge?.waitingChargePerHour?.ceil().currencyFormat ?? 0}/giờ)",
              value: (value != 0 ? "+ " : "") + value.currencyFormat,
            );
          }),
          Builder(builder: (context) {
            final value = widget.data.tollsSurcharge?.ceil() ?? 0;
            return RideInfoRow(
              "Phí cầu đường",
              value: (value != 0 ? "+ " : "") + value.currencyFormat,
            );
          }),
        ],
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Text("Số tiền đặt cọc",
                  style: AppStyles.s15w7.withColor(AppColors.gray60x9d)),
              if (widget.data.state! == CompoundingCarCustomerState.draft) ...[
                const SizedBox(width: 8),
                _buildDownPaymentPercent(
                  percent: (originPercent * 100).ceil(),
                  isSelected: percent == originPercent,
                  onSelected: () {
                    setState(() {
                      percent = originPercent;
                    });
                    widget.onChangedDownPaymentPercent?.call(originPercent);
                  },
                ),
                const SizedBox(width: 8),
                _buildDownPaymentPercent(
                  percent: 100,
                  isSelected: percent == 1,
                  onSelected: () {
                    setState(() {
                      percent = 1;
                    });
                    widget.onChangedDownPaymentPercent?.call(1);
                  },
                ),
              ],
              if (widget.data.state! != CompoundingCarCustomerState.draft) ...[
                Text(
                    " (${((widget.data.downPayment!.percent ?? 0.2) * 100).ceil()}%)",
                    style: AppStyles.s15w7.withColor(AppColors.gray60x9d)),
              ],
              const Spacer(),
              Text(
                "- ${(widget.data.amountTotal! * percent).ceil().currencyFormat}",
                style: AppStyles.s15w7.withColor(
                    AppColors.primaryMain + AppColors.black.withOpacity(.4)),
              ),
            ],
          ),
        ),
        if (isArrived)
          (canPickTip && widget.onChangedTip != null)
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Text("Tiền tip: ", style: AppStyles.s14w4),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TipPicker(
                          totalAmount: widget.data.amountDue ?? 0,
                          onChanged: (value) {
                            widget.onChangedTip!(value);
                            setState(() {
                              tip = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : Builder(builder: (context) {
                  final value = widget.data.tip?.ceil() ?? 0;
                  return RideInfoRow(
                    'Tiền tip',
                    value: value.currencyFormat,
                    positive: value != 0 ? true : null,
                  );
                }),
        const Divider(
          height: 2,
          thickness: 1.5,
        ),
        const SizedBox(height: 8),
        RideInfoRow(
          "Số tiền còn lại",
          value: ((widget.data.amountDue ?? 0) + tip).ceil().currencyFormat,
          bold: true,
        ),
      ],
    );
  }

  _buildDownPaymentPercent({
    required int percent,
    required bool isSelected,
    required Function() onSelected,
  }) {
    return PickupCard(
      isSelected: isSelected,
      onSelected: onSelected,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Center(
        child: Text(
          "$percent %",
          style: AppStyles.s14w6.withColor(
            isSelected ? AppColors.primaryMain : AppColors.gray60x9d,
          ),
        ),
      ),
    );
  }
}
