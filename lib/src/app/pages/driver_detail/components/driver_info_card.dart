import 'package:exxe/src/utils/export/ui_export.dart';

import '../../../../data/models/models.dart';

class DriverInfoCard extends StatelessWidget {
  const DriverInfoCard({
    super.key,
    required this.carDriver,
  });

  final CarDriverModel carDriver;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: AppStyles.border15,
        boxShadow: [
          BoxShadow(
              blurRadius: 2.0, color: AppColors.primaryButton.withAlpha(30)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          carDriver.carInformation?.firstOrNull?.carBrand?.brandName != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: _buildInfo(
                      'Mẫu xe', "${carDriver.carInformation!.firstOrNull!.carBrand!.brandName}"),
                )
              : const SizedBox(),

          carDriver.carType != null
              ? Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: _buildInfo(
                'Loại xe', carDriver.carType!.firstOrNull.toString()),
          )
              : const SizedBox(),

          carDriver.carInformation?.firstOrNull?.carBrand?.brandName != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: _buildInfo('Tên xe', "${carDriver.carInformation!.firstOrNull!.carName}"),
                )
              : const SizedBox(),

          carDriver.carInformation?.firstOrNull?.standardId?.standardName != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: _buildInfo(
                      'Số xe',carDriver.carInformation!.firstOrNull!.standardId!.standardName!),
                )
              : const SizedBox(),

        ],
      ),
    );
  }

  Widget _buildInfo(String title, String value) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextWidget(
            text: title,
            fontSize: 14.0,
            colorText: AppColors.gray70x76,
          ),
          TextWidget(
            text: value,
            fontSize: 14.0,
            colorText: AppColors.gray70x76,
          ),
        ],
      );
}
