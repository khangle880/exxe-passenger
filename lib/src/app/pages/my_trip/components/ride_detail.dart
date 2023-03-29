import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../../../../data/data.dart';
import '../../../../utils/export/ui_export.dart';
import '../../pages.dart';

class RideDetailPage extends StatefulWidget {
  const RideDetailPage({Key? key, required this.customer}) : super(key: key);
  final CompoundingCarCustomerModel customer;

  @override
  State<RideDetailPage> createState() => _RideDetailPageState();
}

class _RideDetailPageState extends State<RideDetailPage> {
  late final CompoundingCarControllerRepo repo;
  late CompoundingCarCustomerModel? customer;
  late RemoveListener removeListener;

  @override
  void dispose() {
    super.dispose();
    removeListener();
  }

  @override
  void initState() {
    super.initState();
    customer = widget.customer;
    repo = GetIt.I();
    onRefresh();
    initListenUserAction();
  }

  Future<void> onRefresh() async {
    customer = null;
    setState(() {});
    SmartDialog.showLoading(backDismiss: false);
    await repo
        .getDetailCompoundingCarCustomer(
            widget.customer.compoundingCarCustomerId!)
        .then((either) {
      either.fold((l) => log(l.toString()), (data) {
        customer = data;
        setState(() {});
      });
    });
    SmartDialog.dismiss();
  }

  initListenUserAction() {
    removeListener = GetIt.I.get<AppState>().addListener((state) {
      if (state.isNewAction &&
          state.action == ActionStateEnum.syncTrip &&
          state.payload is CompoundingCarCustomerModel) {
        final payload = state.payload as CompoundingCarCustomerModel;
        if (customer?.compoundingCarCustomerId ==
            payload.compoundingCarCustomerId) {
          onRefresh();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (customer != null &&
        // isProcessing
        (CompoundingCarStateGroup.processing.states.contains(customer!.state) ||
            CompoundingCarStateGroup.inProcess.states
                .contains(customer!.state))) {
      return TripItineraryPage(
        carCustomer: customer!,
        onRefresh: onRefresh,
      );
    }
    return Stack(
      children: [
        Builder(
          builder: (_) {
            if (customer == null) {
              return Scaffold(
                appBar: CustomAppBarWidget(
                  context: context,
                  title: '',
                ),
              );
            } else {
              if (customer!.state == CompoundingCarCustomerState.confirm) {
                return TripDetailPage(
                  customer: customer!,
                  onRefresh: onRefresh,
                );
              } else {
                return TripDetailPage(
                  customer: customer!,
                  onRefresh: onRefresh,
                );
              }
            }
          },
        ),
        const DraggableSupportButton(),
      ],
    );
  }
}
