import 'package:exxe/src/utils/export/ui_export.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../data/data.dart';

class TestPaymentPage extends StatefulWidget {
  const TestPaymentPage({Key? key}) : super(key: key);

  @override
  State<TestPaymentPage> createState() => _TestPaymentPageState();
}

class _TestPaymentPageState extends State<TestPaymentPage> {
  List<PaymentMethodModel>? methods;
  String? errorMessage;
  String? paymentStatus;
  PaymentRequestModel? payment;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    var result = await WalletRepo().getPaymentMethods();
    result.fold((failure) {
      errorMessage = failure.toString();
      log(failure.toString());
    }, (data) {
      methods = data;
      log(data.toString());
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 400,
          child: Column(
            children: [
              if (errorMessage != null) Text(errorMessage!),
              if ((methods ?? []).isNotEmpty)
                Column(
                    children: methods!
                        .map((e) => TextButton(
                            onPressed: () async {
                              var result = await WalletRepo()
                                  .createWalletRechargeRequest(
                                      amount: 400000,
                                      acquirerId: e.acquirerId ?? 0,
                                      returnedUrl:
                                          "https://exxe.page.link/4Yif");
                              result.fold((failure) {
                                errorMessage = failure.toString();
                                log(failure.toString());
                              }, (data) {
                                payment = data;
                                setState(() => {});
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => InAppWebView(
                                            initialUrlRequest: URLRequest(
                                                url: Uri.parse(
                                              data.vnpayPaymentUrl!,
                                            )),
                                          )),
                                );
                              });
                            },
                            child: Text(e.name ?? 'Unknown')))
                        .toList()),
              TextButton(
                  onPressed: () async {
                    var result = await WalletRepo()
                        .confirmWalletRechargeRequest(payment?.paymentId ?? 0);
                    result.fold((failure) {
                      errorMessage = failure.toString();
                      log(failure.toString());
                    }, (data) {
                      paymentStatus = data.state!;
                      setState(() {});
                    });
                  },
                  child: const Text("Confirm payment")),
              if (paymentStatus != null) Text(paymentStatus!),
            ],
          ),
        ),
      ),
    );
  }
}
