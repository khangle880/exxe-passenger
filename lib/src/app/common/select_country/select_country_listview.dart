import '../../../utils/export/ui_export.dart';

class SelectCountryListView extends StatelessWidget {
  const SelectCountryListView({
    Key? key,
    this.iconSize = 50,
    this.textStyle,
    required this.onSelected,
    this.supported,
    this.selectedItem,
  }) : super(key: key);
  final double iconSize;
  final TextStyle? textStyle;
  final Function(Locale locale) onSelected;
  final Locale? selectedItem;

  /// country code list
  final List<Locale>? supported;

  @override
  Widget build(BuildContext context) {
    List<Locale> defaultLocales = [const Locale('vi', 'VN')];
    final locales = supported ?? defaultLocales;

    return ListView(
      children: locales.map((e) => _buildItem(context, e)).toList(),
    );
  }

  Widget _buildItem(context, Locale locale) {
    final country = Country.supported
        .firstWhere((element) => element.countryCode == locale.countryCode);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onSelected(locale);
          Navigator.pop(context);
        },
        child: Container(
          decoration: selectedItem?.countryCode == locale.countryCode
              ? BoxDecoration(
                  color: AppColors.primaryMain +
                      AppColors.primaryLight.withOpacity(0.4))
              : null,
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            children: <Widget>[
              const SizedBox(width: 20),
              _flagWidget(country),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  country.name!,
                  style: (textStyle ?? AppStyles.s16w6).merge(TextStyle(
                    color: selectedItem?.countryCode == locale.countryCode
                        ? AppColors.primaryLight
                        : null,
                  )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _flagWidget(Country country) {
    return SizedBox(
      width: iconSize,
      child: Text(
        CountryUtils.countryCodeToEmoji(country.countryCode!),
        style: TextStyle(
          fontSize: iconSize / 2,
        ),
      ),
    );
  }
}

class CountryUtils {
  static String countryCodeToEmoji(String countryCode) {
    // 0x41 is Letter A
    // 0x1F1E6 is Regional Indicator Symbol Letter A
    // Example :
    // firstLetter U => 20 + 0x1F1E6
    // secondLetter S => 18 + 0x1F1E6
    // See: https://en.wikipedia.org/wiki/Regional_Indicator_Symbol
    final int firstLetter = countryCode.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final int secondLetter = countryCode.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }
}
