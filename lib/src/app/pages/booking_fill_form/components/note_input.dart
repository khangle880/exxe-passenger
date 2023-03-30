import '../../../../utils/export/ui_export.dart';
import '../../../common/components/note/note_widget.dart';

class NoteInput extends StatefulWidget {
  const NoteInput({Key? key, this.note, required this.onChanged})
      : super(key: key);
  final String? note;
  final Function(String value) onChanged;

  @override
  State<NoteInput> createState() => _NoteInputState();
}

class _NoteInputState extends State<NoteInput> {
  late final TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(
      text: widget.note,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: const Text(
            "Ghi chú của chuyến đi",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: AppDimens.text14),
          ),
        ),
        const SizedBox(height: 4),
        NoteWidget(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          height: 120,
          controller: controller,
          hintText: 'Ghi chú của bạn.',
          decoration: BoxDecoration(
              color: AppColors.textLight,
              borderRadius: BorderRadius.circular(12)),
          onTapClearText: () {
            controller.clear();
            widget.onChanged('');
          },
          onChanged: (value) {
            widget.onChanged(value);
          },
        ),
      ],
    );
  }
}
