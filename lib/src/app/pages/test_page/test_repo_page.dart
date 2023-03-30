import 'dart:async';
import 'package:exxe/src/utils/export/ui_export.dart';
import 'package:from_css_color/from_css_color.dart';
import 'package:uni_links/uni_links.dart';

import '../../../data/data.dart';

class TestRepoPage extends StatefulWidget {
  const TestRepoPage({Key? key}) : super(key: key);

  @override
  State<TestRepoPage> createState() => _TestRepoPageState();
}

class _TestRepoPageState extends State<TestRepoPage> {
  late final CompoundingCarControllerRepo repo;
  final vnPayChannel = const MethodChannel('passenger/vn_pay');
  List<PaymentMethodModel>? methods;
  PaymentMethodModel? currentPaymentMethod;
  String? errorMessage;
  CompoundingCarCustomerModel? customer;
  CompoundingPaymentRequest? paymentRequest;
  List<CompoundingCarModel>? compoundingCars;
  CompoundingCarModel? selectedCompoundingCar;

  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    DynamicLink.instance.initDynamicLinks(context);
    repo = GetIt.I();
    // _handleIncomingLinks();
    //? Example for dynamic link
    // testBuildDynamicLink();
    _handleIncomingLinks();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  /// Handle incoming links - the ones that the app will recieve from the OS
  /// while already started.
  void _handleIncomingLinks() {
    _sub = uriLinkStream.listen((Uri? uri) {
      if (!mounted) return;
      log('got uri: $uri');
    }, onError: (Object err) {
      if (!mounted) return;
      log('got err: $err');
    });
  }

  void createCompoundingCar() async {
    var result = await repo.createCompoundingCar(
      type: CompoundingType.compounding,
      from: LocationModel(
        coordinate: const CoordinateModel(latitude: 100, longitude: 100),
        address: "abc",
        provinceId: 1045,
        stationId: 451,
      ),
      to: LocationModel(
        coordinate: const CoordinateModel(latitude: 100, longitude: 100),
        address: "abc",
        provinceId: 1046,
        stationId: 458,
      ),
      expectedGoingOnDate: DateTime.now().add(const Duration(days: 1)),
      numberSeat: 2,
      carId: 2,
      distance: 20.3,
      duration: 3,
    );
    result.fold((failure) {
      errorMessage = failure.toString();
      log(failure.toString());
    }, (data) {
      customer = data;
      log(data.toString());
      log(data.compoundingCarId!.toString());
      log(data.compoundingCarCustomerId!.toString());
    });
    setState(() {});
  }

  void updateCompoundingCar() async {
    if (customer?.compoundingCarCustomerId == null) return;
    var result = await repo.updateCompoundingCar(
      customer!.compoundingCarCustomerId!,
      expectedGoingOnDate: DateTime.now(),
    );
    result.fold((failure) {
      errorMessage = failure.toString();
      log(failure.toString());
    }, (data) {
      log(data.toString());
    });
    setState(() {});
  }

  // void confirmCompoundingCar() async {
  //   if (customer?.compoundingCarCustomerId == null) return;
  //   var result = await repo.confirmCompoundingCar(
  //     customer!.compoundingCarCustomerId!,
  //   );
  //   result.fold((failure) {
  //     errorMessage = failure.toString();
  //     log(failure.toString());
  //   }, (data) {
  //     log(data.toString());
  //   });
  //   setState(() {});
  // }

  void getPaymentMethodsInApp() async {
    var result = await repo.getPaymentInAppMethods();
    result.fold((failure) {
      errorMessage = failure.toString();
      log(failure.toString());
    }, (data) {
      methods = data;
      log(data.toString());
    });
    setState(() {});
  }

  void createVNPayPayment() async {
    if ((methods ?? []).isEmpty ||
        customer?.compoundingCarCustomerId == null ||
        currentPaymentMethod == null) {
      return;
    }
    // var link = await DynamicLink.instance.createVnpayDynamicLink("confirm");
    // log(link);
    var result = await repo.createVNPayPayment(
      customerId: customer!.compoundingCarCustomerId!,
      methodId: currentPaymentMethod!.acquirerId!,
      returnUrl: "exxe://vnpay",
    );
    result.fold((failure) {
      errorMessage = failure.toString();
      log(failure.toString());
    }, (data) {
      paymentRequest = data;
      log(data.toString());
      log(data.vnpayPaymentUrl.toString());
    });
    setState(() {});
  }

  void confirmCompoundingPayment() async {
    if (customer?.compoundingCarCustomerId == null) {
      return;
    }
    var result = await repo
        .confirmCompoundingPayment(customer!.compoundingCarCustomerId!);
    result.fold((failure) {
      errorMessage = failure.toString();
      log(failure.toString());
    }, (data) {
      log(data.toString());
    });
    setState(() {});
  }

  void getDetailCompoundingCar() async {
    var result =
        await repo.getDetailCompoundingCar(customer!.compoundingCarId!);
    result.fold((failure) {
      errorMessage = failure.toString();
      log(failure.toString());
    }, (data) {
      log(data.toString());
    });
    setState(() {});
  }

  void loadCarAvailable() async {
    var result = await repo.getCompoundingCarAvailable(
        type: CompoundingType.compounding);
    result.fold((failure) {
      errorMessage = failure.toString();
      log(failure.toString());
    }, (data) {
      log(data.toString());
      compoundingCars = data;
    });
    setState(() {});
  }

  void createCompoundingCarCustomer() async {
    if (selectedCompoundingCar == null) return;
    var result = await repo.createCompoundingCarCustomer(
        type: CompoundingType.compounding,
        compoundingCarId: selectedCompoundingCar!.compoundingCarId!,
        from: LocationModel(
            provinceId: 1045,
            stationId: 451,
            coordinate: const CoordinateModel(longitude: 123, latitude: 132)),
        to: LocationModel(
            provinceId: selectedCompoundingCar!.toProvince!.provinceId!.ceil(),
            stationId: 458,
            coordinate: const CoordinateModel(longitude: 123, latitude: 132)),
        distance: 100,
        numberSeat: 2,
        expectedGoingOnDate: selectedCompoundingCar!.expectedGoingOnDate!
            .subtract(const Duration(hours: 1)));
    result.fold((failure) {
      errorMessage = failure.toString();
      log(failure.toString());
    }, (data) {
      log(data.toString());
      customer = data;
      log(data.compoundingCarCustomerId.toString());
    });
    setState(() {});
  }

  void confirmCompoundingCarCustomer() async {
    if (customer == null) return;
    var result = await repo
        .confirmCompoundingCarCustomer(customer!.compoundingCarCustomerId!);
    result.fold((failure) {
      errorMessage = failure.toString();
      log(failure.toString());
    }, (data) {
      log(data.toString());
      customer = data;
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                if (errorMessage != null) Text(errorMessage!),

                TextButton(
                    onPressed: () async {
                      createCompoundingCar();
                    },
                    child: const Text("createCompoundingCar")),
                TextButton(
                    onPressed: () async {
                      updateCompoundingCar();
                    },
                    child: const Text("updateCompoundingCar")),
                // TextButton(
                //     onPressed: () async {
                //       confirmCompoundingCar();
                //     },
                //     child: const Text("confirmCompoundingCar")),
                TextButton(
                    onPressed: () async {
                      getPaymentMethodsInApp();
                    },
                    child: const Text("getPaymentMethodsInApp")),
                if (methods != null) _buildMethods(),
                TextButton(
                    onPressed: () async {
                      createVNPayPayment();
                    },
                    child: const Text("createVNPayPayment")),
                TextButton(
                    onPressed: () async {
                      if (paymentRequest?.vnpayPaymentUrl == null) return;
                      await vnPayChannel.invokeMethod('open_sdk',
                          {"url": paymentRequest!.vnpayPaymentUrl!});
                    },
                    child: const Text("Open VnPay")),
                TextButton(
                    onPressed: () async {
                      confirmCompoundingPayment();
                    },
                    child: const Text("confirmCompoundingPayment")),
                TextButton(
                    onPressed: () async {
                      loadCarAvailable();
                    },
                    child: const Text("Load Car Available")),
                if (compoundingCars != null) _buildCompoundingCars(),
                TextButton(
                    onPressed: () async {
                      createCompoundingCarCustomer();
                    },
                    child: const Text("createCompoundingCarCustomer")),
                TextButton(
                    onPressed: () async {
                      confirmCompoundingCarCustomer();
                    },
                    child: const Text("confirmCompoundingCarCustomer")),
                TextButton(
                    onPressed: () async {
                      createVNPayPayment();
                    },
                    child: const Text("createVNPayPayment")),
                TextButton(
                    onPressed: () async {
                      if (paymentRequest?.vnpayPaymentUrl == null) return;
                      await vnPayChannel.invokeMethod('open_sdk',
                          {"url": paymentRequest!.vnpayPaymentUrl!});
                    },
                    child: const Text("Open VnPay")),
                TextButton(
                    onPressed: () async {
                      confirmCompoundingPayment();
                    },
                    child: const Text("confirmCompoundingPayment")),
                // TextButton(
                //     onPressed: () async {
                //       getDetailCompoundingCar();
                //     },
                //     child: const Text("getDetailCompoundingCar")),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildMethods() {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: (methods ?? [])
            .map((e) => GestureDetector(
                  onTap: () {
                    currentPaymentMethod = e;
                    setState(() {});
                  },
                  child: Container(
                    width: 150,
                    height: 80,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.only(top: 13.5, left: 9.67),
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                        color: e == currentPaymentMethod
                            ? fromCssColor("#F8F5FF")
                            : fromCssColor("#FFFFFF"),
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: CachedNetworkImage(
                                imageUrl:
                                    Apis.baseUrl + (e.imageUrl?.url ?? ""),
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                            const SizedBox(width: 9.67),
                            Text(
                              e.name!,
                              style: const TextStyle(
                                  fontSize: AppDimens.text12,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 27.5),
                            child: Text(
                                e.brief != null
                                    ? e.brief!
                                    : e.acquirerId == 16
                                        ? "Chọn tài khoản EXXE"
                                        : "Chọn để thêm thẻ",
                                style: const TextStyle(
                                    fontSize: AppDimens.text10,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0x76767676))))
                      ],
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  _buildCompoundingCars() {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: (compoundingCars ?? [])
            .map((e) => GestureDetector(
                  onTap: () {
                    selectedCompoundingCar = e;
                    setState(() {});
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: e == selectedCompoundingCar
                            ? AppColors.primaryMain +
                                AppColors.primaryLight.withOpacity(0.95)
                            : fromCssColor("#FFFFFF"),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text("${e.compoundingCarId!}"),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
