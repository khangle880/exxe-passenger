import 'package:tiengviet/tiengviet.dart';

import '../../../utils/export/ui_export.dart';

class SearchListView<T> extends StatefulWidget {
  const SearchListView({
    Key? key,
    required this.list,
    required this.onSelected,
    required this.getName,
    required this.title,
    this.searchHintText,
  }) : super(key: key);
  final List<T>? list;
  final Function(T item) onSelected;
  final String Function(T item) getName;
  final String title;
  final String? searchHintText;

  @override
  State<SearchListView<T>> createState() => _SearchListViewState<T>();
}

class _SearchListViewState<T> extends State<SearchListView<T>> {
  List<T>? filteredList;

  @override
  void initState() {
    filteredList = widget.list;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SearchListView<T> oldWidget) {
    if (oldWidget.list != widget.list) {
      filteredList = widget.list;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormFieldBuilder.search(
          style: AppStyles.s16w4,
          textInputAction: TextInputAction.search,
          hintText: widget.searchHintText ?? "Tìm kiếm ${widget.title}",
          hintStyle: AppStyles.s16w4.withColor(
            AppColors.gray50,
          ),
          onChanged: (value) {
            var newList = widget.list?.where((e) {
              var data = TiengViet.parse(widget.getName(e))
                  .toLowerCase()
                  .replaceAll(' ', '');
              var input =
                  TiengViet.parse(value.toLowerCase().replaceAll(' ', ''));
              return data.contains(input);
            }).toList();
            setState(() {
              filteredList = newList;
            });
          },
        ),
        const SizedBox(height: 16),
        Expanded(
          child: PickupWithList<T>(
            list: filteredList,
            onSelected: widget.onSelected,
            getName: widget.getName,
            title: widget.title,
          ),
        )
      ],
    );
  }
}
