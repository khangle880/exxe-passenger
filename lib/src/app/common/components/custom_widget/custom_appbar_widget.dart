import '../../../../controllers/token/token_cubit.dart';
import '../../../../utils/export/ui_export.dart';

class CustomAppBarWidget extends PreferredSize {
  CustomAppBarWidget({
    super.key,
    required String title,
    required BuildContext context,
    bool centerTitle = true,
    bool autoGeneraIconLeading = true,
    double fontSizeTitle = 20.0,
    double? leadingWidth,
    List<Widget>? actions,
    VoidCallback? comeBack,
    Color? textColor = AppColors.primaryText,
    Color? iconColor = AppColors.black,
    Color backgroundColor = AppColors.primaryLight,
    double height = 50,
    bool canLogout = false,
  }) : super(
            preferredSize: Size.fromHeight(height),
            child: AppBar(
              key: key,
              leadingWidth: leadingWidth,
              automaticallyImplyLeading: autoGeneraIconLeading,
              leading: Navigator.canPop(context) && autoGeneraIconLeading
                  ? Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: SvgPicture.asset(AppIcons.chevronLeft,
                              color: iconColor)
                          .inkWell(
                        padding: const EdgeInsets.all(8),
                        onTap: () => comeBack != null
                            ? comeBack()
                            : Navigator.pop(context),
                      ),
                    )
                  : canLogout
                      ? Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: SvgPicture.asset(AppIcons.chevronLeft,
                                  color: iconColor)
                              .inkWell(
                            padding: const EdgeInsets.all(8),
                            onTap: () {
                              AppDialog.I.showWarning(
                                message:
                                    "Bạn muốn đăng xuất khỏi tài khoản này?",
                                onConfirm: () {
                                  AppDialog.I.closeDialog();
                                  context.read<TokenCubit>().logOut();
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, Routes.login, (route) => false);
                                },
                              );
                            },
                          ),
                        )
                      : null,
              title: TextWidget(
                text: title,
                fontSize: fontSizeTitle,
                weight: FontWeight.w700,
                colorText: textColor!,
              ),
              elevation: 0.0,
              centerTitle: centerTitle,
              backgroundColor: backgroundColor,
              actions: actions,
            ));
}
