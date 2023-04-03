import 'package:exxe/src/app/pages/trip_itinerary/components/button_view_details.dart';
import 'package:exxe/src/utils/export/ui_export.dart';

import '../../../../data/models/models.dart';
import 'body_info_panel.dart';
import 'components.dart';

class InfoTripPanel extends StatefulWidget {
  const InfoTripPanel(this.carCustomer, {Key? key, this.onRefresh})
      : super(key: key);
  final Future<void> Function()? onRefresh;
  final CompoundingCarCustomerModel carCustomer;

  @override
  State<InfoTripPanel> createState() => _InfoTripPanelState();
}

class _InfoTripPanelState extends State<InfoTripPanel> {
  int? currentIndex = 0;

  final ValueNotifier<bool> isDetailView = ValueNotifier<bool>(true);

  @override
  void dispose() {
    isDetailView.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ValueListenableBuilder(
      valueListenable: isDetailView,
      builder: (context, bool isView, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ViewButtonDetails(
              onClick: () {
                isDetailView.value = !isDetailView.value;
              },
              isDetailsView: isView,
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOutBack,
              width: size.width,
              height: isView ? size.height * 0.8 : size.height * 0.29,
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: AppStyles.borderTop20LeftRight,
                boxShadow: const [
                  BoxShadow(offset: Offset(0, 4), blurRadius: 16)
                ],
              ),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  child: BodyInfoPanel(
                    carCustomer: widget.carCustomer,
                    onRefresh: widget.onRefresh,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
