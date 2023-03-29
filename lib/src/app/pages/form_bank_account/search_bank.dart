import '../../../data/data.dart';
import '../../../utils/export/ui_export.dart';
import '../pages.dart';

class SearchBankPage extends StatefulWidget {
  final List<BankModel> banks;
  final Function(BankModel bank) callback;

  const SearchBankPage({
    Key? key,
    required this.banks,
    required this.callback,
  }) : super(key: key);

  @override
  State<SearchBankPage> createState() => _SearchBankPageState();
}

class _SearchBankPageState extends State<SearchBankPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBarWidget(
        centerTitle: true,
        autoGeneraIconLeading: true,
        backgroundColor: AppColors.gray05,
        title: 'Tìm kiếm ngân hàng',
        context: context,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Expanded(
              child: SearchListView(
                list: widget.banks,
                onSelected: widget.callback,
                getName: (BankModel value) {
                  return value.bankName!;
                },
                title: 'Chọn ngân hàng',
              ),
            )
          ],
        ),
      ),
    );
  }
}
