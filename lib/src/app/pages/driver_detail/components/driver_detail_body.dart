import 'package:exxe/src/app/pages/driver_detail/components/rating_by_star.dart';
import 'package:exxe/src/app/pages/driver_detail/components/driver_info_card.dart';
import 'package:exxe/src/utils/export/ui_export.dart';

import '../../../../data/data.dart';
import 'ratings_statistical_table.dart';

class DriverDetailBody extends StatefulWidget {
  const DriverDetailBody({
    Key? key,
    required this.carDriver,
    required this.externalController,
  }) : super(key: key);
  final CarDriverModel carDriver;
  final ScrollController externalController;

  @override
  State<DriverDetailBody> createState() => _DriverDetailBodyState();
}

class _DriverDetailBodyState extends State<DriverDetailBody> {
  late IRatingRepo repo;
  RatingBoardModel? ratingOverview;

  void getListRatedDriver() async {
    var result = await repo.getRatingDriver(
      carDriverId: widget.carDriver.partnerId!,
    );
    result.fold((failure) {
      log(failure.toString());
    }, (data) {
      ratingOverview = data;
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    repo = GetIt.I();
    getListRatedDriver();
  }

  @override
  Widget build(BuildContext context) {
    if (ratingOverview == null) {
      return Center(child: const SizedBox().appCenterProgressLoading);
    }
    return SingleChildScrollView(
      controller: widget.externalController,
      child: Column(
        children: [
          DriverInfoCard(
            carDriver: widget.carDriver,
          ),
          if (ratingOverview?.carDriverId != null)
            RatingStatisticalTable(
              driver: ratingOverview!.carDriverId!,
            ),
          // todo: check total rating
          ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 150,
                maxHeight: MediaQuery.of(context).size.height * 0.75,
              ),
              child: ratingOverview!.listRating == null
                  ? Center(
                      child: Text(
                        'Tài xế chưa có đánh giá nào',
                        style: AppStyles.s16w7,
                      ),
                    )
                  : CommentCustomer(
                      rating: ratingOverview!.listRating,
                      partnerId: ratingOverview!.carDriverId!.partnerId!,
                    )),
        ],
      ),
    );
  }
}
