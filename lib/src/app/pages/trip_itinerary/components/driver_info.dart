import 'package:exxe/src/app/pages/driver_detail/driver_detail_page.dart';
import 'package:exxe/src/utils/export/ui_export.dart';

import '../../../../data/models/models.dart';
import '../../../../data_chat/data_chat.dart';

class DriverInfo extends StatelessWidget {
  const DriverInfo({
    super.key,
    this.carDriver,
    this.createChat,
    this.customerModel,
  });

  final CarDriverModel? carDriver;
  final Future<ChatRoomModel> Function()? createChat;
  final CompoundingCarCustomerModel? customerModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
            onTap: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return DriverDetailPage(
                    carDriver: carDriver,
                  );
                })),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(
                    color: AppColors.primaryLight.withOpacity(0.6) +
                        AppColors.primaryMain),
                borderRadius: BorderRadius.circular(30),
              ),
              child: CustomNetworkImage(
                size: 50,
                host: Apis.baseUrl,
                url: carDriver?.avatarUrl?.imageUrl,
              ),
            )),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: carDriver?.partnerName ?? "",
                  weight: FontWeight.w600,
                ),
                const SizedBox(height: 5.0),
                ListStarRatingWidget(
                  currentStar: carDriver!.ratingNumber!.toDouble(),
                  size: 15,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 3.0),
                ),
                const SizedBox(height: 5.0),
                if ((carDriver?.carInformation ?? []).isNotEmpty)
                  CarNameDiver(
                    carInfomation: carDriver!.carInformation![0],
                  ),
              ],
            ),
          ),
        ),
        if (createChat != null &&
            customerModel != null &&
            customerModel!.state!.index <=
                CompoundingCarCustomerState.done.index &&
            customerModel!.state!.index >=
                CompoundingCarCustomerState.assign.index)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: SvgPicture.asset(
                  AppIcons.message,
                  height: 28,
                  width: 28,
                  color: AppColors.primaryMain,
                ),
              ).inkWell(
                onTap: () async {
                  if (createChat != null) {
                    ChatSocketHelper.I
                        .openRoomChat(createChat!.call(), context);
                  }
                },
              ),
              const SizedBox(width: 2),
              ZegoCallInviteButton(
                phone: carDriver!.phone.toString(),
                name: carDriver!.partnerName!,
                compoundingCarCustomerCode:
                    customerModel!.compoundingCarCustomerCode!,
              ),
            ],
          )
      ],
    );
  }
}
