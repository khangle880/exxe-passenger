import 'dart:async';

import '../../../../utils/export/ui_export.dart';
import '../available_money.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class MoneyInputWidget extends StatefulWidget {
  const MoneyInputWidget({
    Key? key,
    required this.hintText,
    required this.onChanged,
    this.isWithdraw = false,
  }) : super(key: key);
  final String hintText;
  final Function(int value) onChanged;
  final bool isWithdraw;

  @override
  State<MoneyInputWidget> createState() => _MoneyInputWidgetState();
}

class _MoneyInputWidgetState extends State<MoneyInputWidget> {
  late final TextEditingController textController;
  late StreamController<int> streamController;
  String? error;
  final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
    locale: 'vi',
    decimalDigits: 0,
    symbol: '',
  );

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    streamController = StreamController();
  }

  List<int> genRecommends(int? base) {
    List<int> recommends = [];
    final defaultRecommends = [200000, 500000, 1000000];

    if (base != null) {
      int temp = base;
      while ((temp * 10) <= PaymentLimit.max && recommends.length < 4) {
        temp = temp * 10;
        if (temp.canPay()) {
          recommends.add(temp);
        }
      }
    }
    if (recommends.isEmpty) {
      recommends = defaultRecommends;
    }
    return recommends;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.primaryMain,
            borderRadius: AppStyles.border20,
          ),
          child: Stack(
            children: [
              Positioned(
                top: 20,
                left: 121,
                child: SvgPicture.asset(AppIcons.walletCircle),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 26, 16, 20),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Số dư khả dụng",
                          style: AppStyles.s12w6
                              .withColor(AppColors.primaryLight)),
                      AvailableMoneyText(
                          style: AppStyles.s21w7
                              .withColor(AppColors.primaryLight)),
                      const SizedBox(height: 4),
                      TextFormField(
                        inputFormatters: [formatter],
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          isCollapsed: true,
                          contentPadding:
                              const EdgeInsets.fromLTRB(16, 12, 12, 12),
                          hoverColor: Colors.transparent,
                          suffixIcon: Container(
                            margin: const EdgeInsets.only(right: 20),
                            height: 10,
                            width: 10,
                            alignment: Alignment.centerRight,
                            child: Text(
                              'đ',
                              style: AppStyles.s14w4
                                  .withColor(AppColors.gray90x27),
                            ),
                          ),
                          errorStyle: const TextStyle(fontSize: 0.001),
                          hintText: widget.hintText,
                          hintStyle:
                              AppStyles.s14w4.withColor(AppColors.gray70x76),
                          focusColor: AppColors.primaryMain,
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.utilRed),
                            borderRadius: BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                          filled: true,
                          fillColor: AppColors.greyLight,
                        ),
                        textInputAction: TextInputAction.next,
                        controller: textController,
                        onChanged: (value) {
                          try {
                            final amount = int.parse(value.replaceAll(".", ""));
                            streamController.add(amount);
                            widget.onChanged(amount);
                          } catch (e) {
                            log(e.toString());
                          }
                        },
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          String? result;
                          try {
                            final amount =
                                int.parse((value ?? '0').replaceAll(".", ""));
                            if (widget.isWithdraw &&
                                amount >
                                    (GetIt.I<AppState>()
                                            .currentState
                                            .wallet
                                            ?.availableMoney ??
                                        0)) {
                              result = "Số dư trong tài khoản không đủ";
                            } else if (amount < PaymentLimit.min) {
                              result =
                                  "Số tiền tối thiểu là ${PaymentLimit.min.currencyFormat}";
                            } else if (amount > PaymentLimit.max) {
                              result =
                                  "Số tiền đa là ${PaymentLimit.max.currencyFormat}";
                            } else {
                              result = null;
                            }
                          } catch (e) {
                            result = e.toString();
                          }
                          error = result;
                          setState(() {});
                          return result;
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildRecommends(),
                    ]),
              ),
            ],
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Text(error!,
                style: AppStyles.s14w4.withColor(AppColors.utilRed)),
          )
      ],
    );
  }

  _buildRecommends() {
    return StreamBuilder<int>(
        stream: streamController.stream,
        builder: (_, snp) {
          final data = genRecommends(snp.data);
          return SizedBox(
            height: 28,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: data
                  .map(
                    (e) => GestureDetector(
                      onTap: () {
                        textController.text = formatter.format(e.toString());
                        textController.selection = TextSelection.collapsed(
                            offset: textController.text.length);
                        streamController.add(e);
                        widget.onChanged(e);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 4),
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryMain +
                              AppColors.primaryLight.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          e.currencyFormat,
                          style:
                              AppStyles.s14w4.withColor(AppColors.primaryMain),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
        });
  }
}
