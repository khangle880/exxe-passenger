import '../../../../core/base_state.dart';
import '../../../../data/models/models.dart';
import '../../../../utils/export/ui_export.dart';
import '../components/form_page.dart';
import '../components/pickup_date_field.dart';
import '../components/pickup_image_page.dart';
import '../components/required_text_field.dart';
import '../components/verify_scaffold.dart';
import 'controllers/verify_identity_card_bloc.dart';

class BodyIdentityCardPage extends StatefulWidget {
  const BodyIdentityCardPage({
    Key? key,
    required this.bloc,
  }) : super(key: key);
  final VerifyIdentityCardBloc bloc;

  @override
  State<BodyIdentityCardPage> createState() => _BodyIdentityCardPageState();
}

class _BodyIdentityCardPageState
    extends BaseState<BodyIdentityCardPage, VerifyIdentityCardBloc> {
  final PageController _pageController =
      PageController(initialPage: 0, keepPage: true);

  @override
  VerifyIdentityCardBloc get bloc => widget.bloc;

  @override
  Widget build(BuildContext context) {
    return VerifyScaffold(
      title: "CMND/CCCD/Hộ chiếu",
      body: BlocBuilder<VerifyIdentityCardBloc, VerifyIdentityCardState>(
        buildWhen: (pre, cur) => pre.type != cur.type,
        builder: (context, state) {
          return PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: [
              if (state.type == CallDataApiType.create) _buildIntroView(),
              BlocBuilder<VerifyIdentityCardBloc, VerifyIdentityCardState>(
                builder: (context, state) {
                  return PickupImagePage(
                    cameraDescription:
                        'Vui lòng hướng CMND/CCCD của bạn vào giữa màn hình để chụp ảnh',
                    canIgnore:
                        state.frontImage == null || state.backImage == null,
                    onIgnoreTap: () {
                      _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                    },
                    onNext: () {
                      _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                    },
                    onPickedFront: (value) {
                      bloc.add(ChangeFrontImageEvent(value));
                    },
                    onPickedBack: (value) {
                      bloc.add(ChangeBackImageEvent(value));
                    },
                    initFrontImage: state.frontImage,
                    initBackImage: state.backImage,
                  );
                },
              ),
              BlocBuilder<VerifyIdentityCardBloc, VerifyIdentityCardState>(
                buildWhen: (pre, cur) => pre.type != cur.type,
                builder: (context, state) {
                  return FormPage(
                      isLoading: state.type == CallDataApiType.get,
                      body: _buildFormBody(state),
                      onConfirm: () {
                        bloc.add(CreateVerifyEvent());
                      });
                },
              )
            ],
          );
        },
      ),
    );
  }

  _buildFormBody(VerifyIdentityCardState state) {
    return BlocBuilder<VerifyIdentityCardBloc, VerifyIdentityCardState>(
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 24),
              child: Text(
                "Thông tin của bạn sẽ được đảm bảo an toàn theo quy định của pháp luật",
                textAlign: TextAlign.center,
                style: AppStyles.s14w6.withColor(AppColors.gray60x9d),
              ),
            ),

            /// name
            RequiredTextField(
              initialValue: state.name ?? '',
              onChanged: (value) {
                bloc.add(ChangeIdentityFullNameEvent(value));
              },
              label: 'Họ & tên trên CMND/CCCD/Hộ chiếu ',
              hintText: "Nhập họ tên",
            ),
            const SizedBox(height: 24),

            /// identity number
            RequiredTextField(
              initialValue: state.cardNumber ?? '',
              onChanged: (value) {
                bloc.add(ChangeCarNumberEvent(value));
              },
              keyBoardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              label: 'Số CMND/CCCD/Hộ chiếu ',
              hintText: "Nhập Số CMND/CCCD/Hộ chiếu",
            ),
            const SizedBox(height: 24),

            /// Issue Date
            PickupDateField(
              date: state.issuedDate,
              label: 'Ngày cấp ',
              onSelectDate: (date) {
                bloc.add(ChangeIssuedDateEvent(date));
              },
            ),
            const SizedBox(height: 24),

            /// Expiry Date
            PickupDateField(
              date: state.expiredDate,
              label: 'Ngày hết hạn ',
              isRequired: false,
              onSelectDate: (date) {
                bloc.add(ChangeExpiredDateEvent(date));
              },
            ),
            const SizedBox(height: 24),

            /// place of issue
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      backgroundColor: AppColors.primaryLight,
                      appBar: CustomAppBarWidget(
                        title: 'Chọn nơi cấp',
                        context: context,
                      ),
                      body: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: SearchListView<ProvinceModel>(
                          list: GetIt.I<LocationHelper>().provinces,
                          onSelected: (value) {
                            Navigator.pop(context);
                            bloc.add(
                                ChangePlaceOfIssuedEvent(value.provinceName!));
                          },
                          getName: (value) => value.provinceName!,
                          title: "Chọn tỉnh",
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: CustomFormField(
                validator: (value) {
                  if (state.placeOfIssued == null) {
                    return "Đây là một trường bắt buộc";
                  }
                  return null;
                },
                child: TextFieldReadOnly(
                  label: 'Nơi cấp ',
                  isRequired: true,
                  labelStyle: AppStyles.s16w7,
                  textStyle: AppStyles.s16w4.withColor(
                      state.placeOfIssued == null
                          ? AppColors.gray50
                          : AppColors.gray80),
                  hintText: state.placeOfIssued ?? "Nhập thông tin",
                ),
              ),
            ),
            const SizedBox(height: 24),

            /// address
            RequiredTextField(
              initialValue: state.address ?? '',
              onChanged: (value) {
                bloc.add(ChangeMyAddressEvent(value));
              },
              label: 'Địa chỉ trên CMND/CCCD ',
              hintText: "Nhập địa chỉ trên CMND/CCCD",
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  _buildIntroView() {
    return Material(
      color: AppColors.primaryLight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 24),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: AppStyles.s14w4,
                children: const [
                  TextSpan(
                      text:
                          "Để chuyến đi được an toàn hơn, vui lòng xác minh tài khoản bằng CMND/CCCD. ",
                      style: TextStyle(
                        color: AppColors.gray60x52,
                      )),
                  TextSpan(
                    text:
                        "Điều này cho phép EXXE xác nhận rằng chính bạn đang sử dụng các phương thức thanh toán cho chuyến đi của mình",
                    style: TextStyle(
                      color: AppColors.gray60x9d,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 36),
            Image.asset('assets/images/edit_account.png'),
            const Spacer(),
            ButtonWidget(
              backgroundColor: AppColors.primaryMain,
              onClick: () {
                _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn);
              },
              child: Text(
                "Bắt đầu",
                style: AppStyles.s16w6.withColor(AppColors.primaryLight),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
