import '../../../utils/export/ui_export.dart';

class CardSuggestion extends StatefulWidget {
  const CardSuggestion(
      {Key? key,
      required this.textCity,
      required this.textProvince,
      required this.textKm})
      : super(key: key);
  final String textCity;
  final String textProvince;
  final String textKm;

  @override
  State<CardSuggestion> createState() => _CardSuggestionState();
}

class _CardSuggestionState extends State<CardSuggestion> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.textCity, style: AppStyles.s16w6),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.textProvince,
                style: AppStyles.s12w4.withColor(AppColors.gray70x76),
              ),
              Text("~${widget.textKm}km",
                  style: AppStyles.s12w4.withColor(AppColors.gray70x76)),
            ],
          ),
        ],
      ),
    );
  }
}
