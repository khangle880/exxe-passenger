import '../../../../utils/export/ui_export.dart';

class FormPage extends StatelessWidget {
  FormPage(
      {Key? key,
      required this.isLoading,
      required this.body,
      required this.onConfirm})
      : super(key: key);
  final bool isLoading;
  final Widget body;
  final Function() onConfirm;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: AppColors.primaryLight,
          body: isLoading
              ? const SizedBox().appCenterProgressLoading
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: body,
                  ),
                ),
          bottomNavigationBar: isLoading
              ? const SizedBox()
              : ButtonWidget(
                  onClick: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (_formKey.currentState!.validate()) {
                      onConfirm();
                    }
                  },
                  radius: 12,
                  child: Text("Hoàn thành",
                      style: AppStyles.s16w6.withColor(AppColors.primaryLight)),
                ).bottomSingle(),
        ),
      ),
    );
  }
}
