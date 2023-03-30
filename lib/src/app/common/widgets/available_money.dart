import '../../../utils/export/ui_export.dart';

class AvailableMoneyWidget extends StatelessWidget {
  const AvailableMoneyWidget(
      {Key? key, this.onTapWalletMoney, this.backgroundColor})
      : super(key: key);
  final Function()? onTapWalletMoney;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(AppIcons.wallet, color: AppColors.primaryMain),
        const SizedBox(width: 4.0),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Số dư hiện tại",
              style: AppStyles.s12w7.withColor(AppColors.gray70x76),
            ),
            const SizedBox(height: 2.0),
            const AvailableMoneyText(),
          ],
        )
      ],
    ).inkWell(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primaryMain.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      onTap: onTapWalletMoney,
    );
  }
}

class AvailableMoneyText extends StatefulWidget {
  const AvailableMoneyText({Key? key, this.style}) : super(key: key);
  final TextStyle? style;

  @override
  State<AvailableMoneyText> createState() => _AvailableMoneyTextState();
}

class _AvailableMoneyTextState extends State<AvailableMoneyText> {
  late RemoveListener removeListener;

  @override
  void initState() {
    // Setup the listener.
    removeListener = GetIt.I.get<AppState>().addListener((state) {
      if (state.isNewAction && state.action == ActionStateEnum.updateWallet) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    removeListener();
  }

  @override
  Widget build(BuildContext context) {
    final amount =
        GetIt.I<AppState>().currentState.wallet?.availableMoney?.ceil() ?? 0;
    return FittedBox(
      child: Text(
        amount.currencyFormat,
        style: widget.style ?? AppStyles.s14w7.withColor(AppColors.primaryMain),
      ),
    );
  }
}
