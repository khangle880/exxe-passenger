import 'package:exxe/src/utils/export/ui_export.dart';

class FormSearchPlace extends StatefulWidget {
  final FocusNode focusNode;
  final Function(String) onChange;
  final TextEditingController controller;
  final SearchType searchType;

  const FormSearchPlace(
      {Key? key,
      required this.onChange,
      required this.controller,
      required this.searchType,
      required this.focusNode})
      : super(key: key);

  @override
  State<FormSearchPlace> createState() => _FormSearchPlaceState();
}

class _FormSearchPlaceState extends State<FormSearchPlace> {
  bool isEmpty = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      focusNode: widget.focusNode,
      onChanged: (value) {
        widget.onChange(value);
        final _isEmpty = widget.controller.text.isEmpty;
        if (_isEmpty != isEmpty) {
          setState(() {
            isEmpty = _isEmpty;
          });
        }
      },
      controller: widget.controller,
      decoration: InputDecoration(
        errorMaxLines: 2,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: AppStyles.border10,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: AppStyles.border10,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.textError, width: 0.5),
          borderRadius: AppStyles.border10,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.textError, width: 0.5),
          borderRadius: AppStyles.border10,
        ),
        filled: true,
        fillColor: AppColors.greyLight,
        hoverColor: Colors.transparent,
        prefixIconConstraints: const BoxConstraints(
            minHeight: 40.0, minWidth: 40.0, maxHeight: 60.0, maxWidth: 60.0),
        hintStyle: const TextStyle(
          fontSize: AppDimens.text14,
          color: AppColors.gray70x76,
          fontWeight: FontWeight.w200,
        ),
        focusColor: AppColors.primaryButton,
        suffixIcon: InkWell(
          onTap: () {
            widget.controller.clear();
            context
                .read<SearchPlaceBloc>()
                .add(LocationAutoComplete(searchText: widget.controller.text));
            widget.focusNode.unfocus();
            setState(() {
              isEmpty = true;
            });
          },
          child:
              isEmpty ? const SizedBox() : const Icon(Icons.clear, size: 15.0),
        ),
        prefixIcon: widget.searchType.icon,
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
        hintText: widget.searchType == SearchType.pickUpMap
            ? 'Tìm điểm đón'
            : 'Tìm điểm đến',
      ),
    );
  }
}
