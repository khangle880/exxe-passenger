import '../../../utils/export/ui_export.dart';

class ChangeLanguagePage extends StatelessWidget {
  const ChangeLanguagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Chọn ngôn ngữ',
        context: context,
        backgroundColor: AppColors.gray05,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: SelectCountryListView(
          onSelected: (locale) {},
          selectedItem: Localizations.localeOf(context),
        ),
      ),
    );
  }
}
