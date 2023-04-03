import 'package:exxe/src/app/pages/home/components/banner_home.dart';
import 'package:exxe/src/app/pages/home/components/categories_trip.dart';
import 'package:exxe/src/app/pages/home/components/promotion/promotion.dart';
import 'package:exxe/src/app/pages/home/components/suggest_trip/suggest_trips.dart';
import 'package:exxe/src/app/pages/home/components/top_nav_bar_home.dart';
import 'package:exxe/src/utils/export/ui_export.dart';

import '../../../../data/data.dart';

class BodyHomePage extends StatefulWidget {
  const BodyHomePage({Key? key, required this.jumpToWallet}) : super(key: key);
  final Function() jumpToWallet;

  @override
  State<BodyHomePage> createState() => _BodyHomePageState();
}

class _BodyHomePageState extends State<BodyHomePage> {
  _getAvailableMoney() async {
    final myWalletResponse = await WalletRepo().getWalletJournal();
    myWalletResponse.fold((failure) {
      log(failure.toString());
    }, (data) {
      log(data.toString());
      GetIt.I.get<AppState>().updateWallet(data);
    });
  }

  _getListNotification() async {
    await NotificationRepo().getListNotification(
        notificationType:
            NotificationType.allNotification.mapTypes.entries.first.value);
  }

  @override
  void initState() {
    _getAvailableMoney();
    _getListNotification();
    getRideToPayments();
    super.initState();
  }

  getRideToPayments() async {
    final either =
        await GetIt.I<ICompoundingCarCtrlRepo>().getNeedPaymentRides();
    either.fold((l) => l.toString(), (r) {
      if (r.isNotEmpty) {
        AppDialog.I
            .showNeedPaymentDialog(customerCars: r, rootContext: context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: TopNavBarHome(
                jumpToWallet: widget.jumpToWallet,
              ),
            ),
            const SizedBox(height: 12.0),
            const BannerHome(),
            const SizedBox(height: 4.0),
            const CategoriesTripHome(),
            const SizedBox(height: 4.0),
            const SuggestTripHome(),
            const PromotionHome(),
            // const ListNews(),
            const SizedBox(height: 12.0),
          ],
        ),
      ),
    );
  }
}
