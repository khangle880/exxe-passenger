import 'package:exxe/src/app/pages/form_bank_account/search_bank.dart';

import '../../../core/base_state.dart';
import '../../../utils/export/ui_export.dart';
import '../pages.dart';

class RegisterFormBankAccountPage extends StatefulWidget {
  const RegisterFormBankAccountPage({Key? key}) : super(key: key);

  @override
  State<RegisterFormBankAccountPage> createState() =>
      _RegisterFormBankAccountPageState();
}

class _RegisterFormBankAccountPageState
    extends BaseState<RegisterFormBankAccountPage, RegisterBankAccountCubit> {
  @override
  late final RegisterBankAccountCubit bloc;

  final _formKey = GlobalKey<FormState>();

  @override
  void initData() {
    super.initData();
    bloc = context.read<RegisterBankAccountCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: AppColors.primaryLight,
        appBar: CustomAppBarWidget(
          centerTitle: true,
          autoGeneraIconLeading: true,
          title: 'Tài khoản ngân hàng',
          fontSizeTitle: 18,
          context: context,
          backgroundColor: AppColors.primaryLight,
          canLogout: true,
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: SizedBox(
            width: double.maxFinite,
            child: ButtonWidget(
              onClick: () async {
                FocusManager.instance.primaryFocus?.unfocus();
                if (_formKey.currentState!.validate()) {
                  AppDialog.I.showLoading();
                  bool result = await bloc.updateBankAccount();
                  if (result) {
                    AppDialog.I.closeDialog();
                    AppDialog.I.showSuccess(
                      title: 'Cập nhật thành công',
                      message: 'Thông tin ngân hàng của bạn đã được cập nhật',
                      onConfirm: () {
                        AppDialog.I.closeDialog();
                        bloc.getBankAccountInformation();
                        Navigator.pop(context);
                      },
                    );
                  }
                }
              },
              radius: 12,
              child: Text("Xác nhận",
                  style: AppStyles.s16w6.withColor(AppColors.primaryLight)),
            ),
          ),
        ),
        body: BlocBuilder<RegisterBankAccountCubit, RegisterBankAccountState>(
          builder: (context, state) {
            return state.account != null && state.banks != null
                ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 21),
                        child: Column(
                          children: [
                            CustomFormField(
                              validator: (value) {
                                if (state.selectedBank == null) {
                                  return 'Vui lòng chọn loại thẻ';
                                }
                                return null;
                              },
                              child: TextFieldReadOnly(
                                icon: state.selectedBank?.imageModel
                                            ?.urlBankIcon !=
                                        null
                                    ? CustomNetworkImage(
                                        size: 24,
                                        decoration: const BoxDecoration(
                                          color: AppColors.gray20,
                                          shape: BoxShape.rectangle,
                                        ),
                                        fit: BoxFit.fill,
                                        host: Apis.baseUrl,
                                        url: state.selectedBank!.imageModel!
                                            .urlBankIcon,
                                        errorImage: const Icon(
                                          Icons.image_outlined,
                                          size: 24,
                                          color: Colors.black12,
                                        ),
                                      )
                                    : null,
                                label: 'Thẻ ngân hàng ',
                                isRequired: true,
                                hintText: state.selectedBank?.bankName ??
                                    "Chọn loại thẻ",
                                textStyle: AppStyles.s16w4.withColor(
                                    state.selectedBank != null
                                        ? AppColors.gray90x27
                                        : AppColors.gray50),
                                onClick: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SearchBankPage(
                                        banks: state.banks!,
                                        callback: (selectedBank) {
                                          bloc.getSelectedBankBank(
                                              selectedBank);
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  );
                                },
                                trailing: SvgPicture.asset(
                                  AppIcons.directionRight,
                                  height: 16,
                                  width: 16,
                                  color: AppColors.gray95x14,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            RequiredTextField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              keyBoardType: TextInputType.number,
                              initialValue: state.accountNumber ?? '',
                              onChanged: (value) {
                                bloc.getAccountNumber(value);
                              },
                              label: 'Số tài khoản ',
                              hintText: "Nhập số tài khoản",
                            ),
                            const SizedBox(height: 24),
                            RequiredTextField(
                              initialValue: state.bankOwner ?? '',
                              onChanged: (value) {
                                bloc.getBankOwner(value);
                              },
                              label: 'Tên người dùng ',
                              hintText: "Nhập tên người dùng",
                            ),
                            const SizedBox(height: 24),
                            PickupDateField(
                              date: state.bankExpireDate,
                              label: 'Ngày phát hành ',
                              onSelectDate: (date) {
                                bloc.getBankExpireDate(date);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : const SizedBox();
          },
        ),
      ).gestureDetector(onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      }),
    );
  }
}
