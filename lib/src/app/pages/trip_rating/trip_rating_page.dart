import 'package:exxe/src/app/common/components/note/note_widget.dart';
import 'package:exxe/src/app/pages/trip_rating/components/list_hashtag.dart';
import 'package:exxe/src/app/pages/trip_rating/controller/rating_cubit.dart';
import 'package:exxe/src/utils/export/ui_export.dart';

import '../../../core/base_state.dart';
import '../../../data/data.dart';

// ignore: must_be_immutable
class TripRatingPage extends StatefulWidget {
  final CompoundingCarCustomerModel carCustomer;

  const TripRatingPage({Key? key, required this.carCustomer}) : super(key: key);

  @override
  State<TripRatingPage> createState() => _TripRatingPageState();
}

class _TripRatingPageState extends BaseState<TripRatingPage, RatingCubit> {
  final ValueNotifier<int> currentStar = ValueNotifier(5);
  final TextEditingController controller = TextEditingController();
  List<int> listChoiceHashtagIds = [];

  @override
  late final RatingCubit bloc;

  handleRemoveItem(int id) {
    for (int e in listChoiceHashtagIds) {
      if (e == id) {
        listChoiceHashtagIds.remove(e);
        return true;
      }
    }
    return false;
  }

  @override
  void initState() {
    bloc = context.read<RatingCubit>();
    super.initState();
  }

  @override
  void dispose() {
    currentStar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppBarWidget(
          backgroundColor: AppColors.gray05,
          title: 'Đánh giá chuyến đi',
          context: context,
          fontSizeTitle: 18.0,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAvatar(),
              buildTitle(),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                child: ValueListenableBuilder(
                    valueListenable: currentStar,
                    builder: (context, int current, child) {
                      return ListStarRatingWidget(
                        onRatingUpdate: (value) {
                          currentStar.value = value.round();
                          bloc.getQuickRatingTag(value.round());
                          listChoiceHashtagIds.clear();
                        },
                        allowHalfRating: false,
                        ignoreGestures: false,
                        currentStar: current.toDouble(),
                        size: 50.0,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 3.0),
                      );
                    }),
              ),
              StatefulBuilder(builder: (context, setState) {
                return BlocConsumer<RatingCubit, RatingState>(
                  listener: (context, state) {
                    if (state.ratingRes != null) {
                      log('co ket qua');
                      if (currentStar.value > 3) {
                        DialogRatingDriver.instance
                            .showDialogRatingBigger(context);
                      } else {
                        DialogRatingDriver.instance
                            .showDialogRatingLess(context);
                      }
                    }
                  },
                  builder: (context, state) {
                    if (state.hasTags != null) {
                      return ListHashTag(
                        hasTags: state.hasTags!,
                        onClick: (int id) {
                          if (!handleRemoveItem(id)) {
                            listChoiceHashtagIds.add(id);
                          }
                          setState(() {});
                        },
                        currentList: listChoiceHashtagIds,
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                );
              }),
              NoteWidget(
                margin: const EdgeInsets.symmetric(vertical: 24),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                height: 120,
                decoration: BoxDecoration(
                    color: AppColors.gray60x9d +
                        AppColors.primaryLight.withOpacity(.9),
                    borderRadius: BorderRadius.circular(12)),
                style: AppStyles.s14w4.withColor(AppColors.gray95),
                controller: controller,
                hintText: 'Mô tả',
                onTapClearText: () {
                  controller.clear();
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ButtonWidgetOld(
            radius: 10.0,
            onClick: () {
              bloc.createRating(
                widget.carCustomer.compoundingCarCustomerId!.ceil(),
                currentStar.value,
                listChoiceHashtagIds,
                ratingContent: controller.text.trim(),
              );
            },
            backgroundColor: AppColors.primaryButton,
            child: Text(
              "Đánh giá ngay",
              style: AppStyles.s16w6.withColor(AppColors.primaryLight),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAvatar() => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: widget.carCustomer.carDriverId?.avatarUrl?.imageUrl != null
              ? Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColors.primaryLight.withOpacity(0.6) +
                            AppColors.primaryMain),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: CustomNetworkImage(
                    size: 100,
                    decoration: const BoxDecoration(
                      color: AppColors.gray20,
                      shape: BoxShape.circle,
                    ),
                    host: Apis.baseUrl,
                    url: widget.carCustomer.carDriverId!.avatarUrl!.imageUrl!,
                  ),
                )
              : SvgPicture.asset(
                  AppIcons.user,
                  width: 100,
                  height: 100,
                ),
        ),
      );

  Widget buildTitle() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: FittedBox(
              child: TextWidget(
                text: 'Bạn thấy chuyến đi như thế nào?',
                fontSize: 18,
                weight: FontWeight.w700,
                textAlign: TextAlign.center,
                maxLine: 2,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextWidget(
              text:
                  'Hãy cho chúng tôi biết trải nghiệm với EXXE bằng cách đánh giá cuốc xe này.',
              fontSize: 14,
              colorText: AppColors.gray70x76,
              textAlign: TextAlign.center,
              maxLine: 3,
            ),
          ),
        ],
      );
}
