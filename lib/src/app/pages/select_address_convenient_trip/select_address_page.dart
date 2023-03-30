import '../../../data/data.dart';
import '../../../utils/export/ui_export.dart';
import '../trip_detail/components/bottom_button.dart';

class SelectAddressPage extends StatefulWidget {
  const SelectAddressPage({
    Key? key,
    required this.selectAddress,
  }) : super(key: key);

  final Function(String address) selectAddress;

  @override
  State<SelectAddressPage> createState() => _SelectAddressPageState();
}

class _SelectAddressPageState extends State<SelectAddressPage> {
  String? currentAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyLight,
      appBar: CustomAppBarWidget(
        backgroundColor: AppColors.greyLight,
        title:"Chọn nơi đón",
        context: context,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildSelectAnotherStation(
              onTap: () {
                ///Chuyến đến màn hình chọn địa điểm trên google map
                Navigator.pushNamed(
                  context,
                  Routes.searchPlace,
                  arguments: {
                    'searchType': SearchType.pickUpStation,
                    'onSelect': (LocationModel location) {
                      setState(() {
                        currentAddress = location.address;
                      });

                      log('locationModel $location');
                    },
                  },
                );
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: currentAddress != null
          ? BottomButton(
              secondTitle: 'Tiếp tục',
              onTapTwo: () {
                widget.selectAddress(currentAddress!);
                Navigator.pop(context);
              },
            )
          : const BottomButton(
              secondTitle: 'Tiếp tục',
            ),
    );
  }

  _buildSelectAnotherStation({Function()? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12, left: 24, right: 24),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.only(
                  left: 8, right: 16, top: 8, bottom: 8),
              height: 48,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(AppIcons.circleBorder,
                      width: 32, height: 32),
                  const SizedBox(width: 4),
                  Expanded(
                    child: TextWidget(
                      text: currentAddress ?? 'Tìm điểm đón',
                      fontSize: 14,
                      weight: AppStyles.fontWeightW400,
                      colorText: AppColors.gray70x76,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          TextWidget(
            fontSize: 14,
            weight: AppStyles.fontWeightW400,
            colorText: AppColors.gray70x76,
            maxLine: 2,
            text:
                '(*) Chi phí phát sinh khách hàng vui lòng tự thanh toán với tài xế',
          )
        ],
      ),
    );
  }
}
