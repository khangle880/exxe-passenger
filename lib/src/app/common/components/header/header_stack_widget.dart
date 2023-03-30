import 'package:exxe/src/utils/export/ui_export.dart';

class HeaderStackWidget extends StatelessWidget {
  const HeaderStackWidget(
      {Key? key,
      required this.title,
      required this.child,
      this.centerTitle = true,
      this.autoGenarateIconLeading = true,
      required this.children,
      this.actions,
      this.scaffoldKey,
      this.paddingImage})
      : super(key: key);
  final String title;
  final Widget child;
  final bool centerTitle;
  final bool autoGenarateIconLeading;
  final Widget children;
  final double height = 0.25;
  final List<Widget>? actions;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final EdgeInsetsGeometry? paddingImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        actions: actions,
        elevation: 0.0,
        leading: (autoGenarateIconLeading)
            ? InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 20.0,
                  color: AppColors.primaryDark,
                ),
              )
            : null,
        automaticallyImplyLeading: autoGenarateIconLeading,
        backgroundColor: AppColors.primaryButton.withAlpha(30),
        title: TextWidget(
          text: title,
          fontSize: AppDimens.text24,
          weight: FontWeight.w700,
        ),
        centerTitle: centerTitle,
      ),
      backgroundColor: AppColors.greyLight,
      body: Stack(
        // clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
              color: AppColors.primaryButton.withAlpha(30),
            ),
          ),
          Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: paddingImage ?? const EdgeInsets.all(15.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: AppStyles.border20,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5.0,
                      color: AppColors.primaryDark.withAlpha(20),
                    )
                  ],
                ),
                child: child,
              ),
              Expanded(child: children),
            ],
          ),
        ],
      ),
    );
  }
}
