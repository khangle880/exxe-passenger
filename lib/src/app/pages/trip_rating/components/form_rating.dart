import 'package:exxe/src/utils/export/ui_export.dart';

class FormRating extends StatefulWidget {
  const FormRating({Key? key, required this.onChanged, this.content})
      : super(key: key);
  final Function(String) onChanged;
  final String? content;
  @override
  State<FormRating> createState() => _FormRatingState();
}

class _FormRatingState extends State<FormRating> {
  final TextEditingController controller = TextEditingController();
  bool openClear = false;
  @override
  void initState() {
    controller.addListener(() {
      if (controller.text.isNotEmpty && !openClear) {
        openClear = !openClear;
      } else if (controller.text.isEmpty && openClear) {
        openClear = !openClear;
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Stack(
        children: [
          TextFormFieldBuilder.none(
            onChanged: widget.onChanged,
            controller: controller,
            textInputAction: TextInputAction.done,
            maxLines: 3,
            hintText: widget.content ?? 'Khác',
            hintStyle: widget.content != null
                ? AppStyles.s14w4.withColor(AppColors.primaryDark)
                : null,
          ),
          (openClear)
              ? Positioned(
                  top: 10,
                  right: 10,
                  child: const Icon(Icons.clear, size: 20).inkWell(
                    onTap: () {
                      controller.text = '';
                      openClear = false;
                    },
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
