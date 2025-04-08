import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tshopper_app/models/order/TShopperOrder.dart';
import 'package:tshopper_app/models/tshopper/TShopper.dart';
import 'package:tshopper_app/providers/PendingOrderProvider.dart';
import 'package:tshopper_app/sevices/TShopperService.dart';
import 'package:tshopper_app/widgets/trackingOrder/ReadyItem.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/AppFontSize.dart';
import '../constants/AppColors.dart';
import '../main.dart';
import '../providers/InPreparationOrderProvider.dart';
import '../providers/NewOrderProvider.dart';
import '../providers/ReadyOrderProvider.dart';
import '../sevices/AblyService.dart';
import '../sevices/VersionService.dart';
import '../widgets/overlayMenu/OverlayMenu.dart';
import '../widgets/trackingOrder/InProgressItem.dart';
import '../widgets/trackingOrder/NewOrderItem.dart';
import '../widgets/trackingOrder/PendingOrderItem.dart';

class HomeScreen extends ConsumerStatefulWidget {

  HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with WidgetsBindingObserver, TickerProviderStateMixin, RouteAware{
  late RouteObserver<PageRoute> routeObserver;
  final OverlayMenu overlayMenu = OverlayMenu();

  bool isLoading = false;

  int selectedNewSectionIndex = 0;

  PackageInfo? packageInfo;
  bool _isLatestVersion = false;
  int selectedIndex = 0;
  Map<String, Color> colorMap = {
    'blue': Colors.blue,
    'green': Colors.green,
    'teal': Colors.teal,
    'tealAccent': Colors.tealAccent,
    'beige': Colors.orange[100]!,
    'orange': Colors.orange,
    'yellow': Colors.yellow,
    'red': Colors.red,
    'pink': Colors.pink,
    'lightPink':  Colors.pink[100]!,
    'brown':  Colors.brown,
    'black':  Colors.black,
  };

  bool isPusherSubscribed = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    overlayMenu.init(context, this);
    AblyService.createAblyRealtimeInstance(
      TShopper.instance.uid,
      [TShopper.instance.uid, "tShoppersNewOrders-${TShopper.instance.currentShoppingCenterId}"],
    );
    AblyService.ref = ref;
    _tabController = TabController(length: 7, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedIndex = _tabController.index;
      });
    });
    routeObserver = RouteObserver<PageRoute>();
    WidgetsBinding.instance.addObserver(this);
    fetchData();
    _checkIfLatestVersion();
    _timer = Timer.periodic(const Duration(minutes: 30), (timer) {
      // checkFutureOrders();
    });
  }

  void _checkIfLatestVersion() async {
    try {
      packageInfo = await PackageInfo.fromPlatform();

      bool? temp = await VersionService.isLatestVersion(
          Platform.isAndroid ? 'android' : 'ios', packageInfo!.version);
      if (temp != null) {
        setState(() {
          _isLatestVersion = temp;
        });
        if (!_isLatestVersion) {
          _showUpdateDialog();
        }
      } else {
        throw Exception('Function isLatestVersion returned null');
      }
    } catch (error) {

    }
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.popupBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.dp)
          ),
          title: Text(
            "היי! יש לנו עדכון חשוב 💜",
            style: TextStyle(fontSize: 20.dp, fontWeight: FontWeight.w800, fontFamily: 'todofont', color: AppColors.blackText),
          ),
          content: Text(
            "על מנת להמשיך להשתמש באפליקציה עלייך לעדכן לגרסה החדשה שלנו",
            style: TextStyle(fontSize: 14.dp, fontWeight: FontWeight.w700, fontFamily: 'arimo', color: AppColors.blackText),
          ),
          actions: [
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 16.0.dp, vertical: 8.0.dp),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor:AppColors.primeryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.dp),
                  ),
                ),
                onPressed: () {
                  final url = Platform.isAndroid
                      ? "https://play.google.com/store/apps/details?id=com.todogroup.todo_business_manager"
                      : "https://apps.apple.com/lv/app/todo-business-manager/id6736658355";
                  launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                },
                child: Text("לחץ כאן למעבר לחנות",
                  style: TextStyle(fontSize: 12.dp, fontWeight: FontWeight.w700, fontFamily: 'arimo', color: AppColors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    List<TShopperOrder>? orders = await TShopperService.getActiveOrders();
    if(orders != null && orders.isNotEmpty){
      List<TShopperOrder> pendingOrders = orders
          .where((order) =>
      order.orderStatus == "PENDING" ||
          order.orderStatus == "SEEN_BY_SHOPPER" ||
          order.orderStatus == "ON_HOLD")
          .toList();

      List<TShopperOrder> newOrders = orders
          .where((order) =>
      order.orderStatus == "ASSIGNED")
          .toList();

      List<TShopperOrder> inPreparation = orders
          .where((order) =>
      order.orderStatus == "IN_PROGRESS" ||
          order.orderStatus == "WAITING_FOR_PAYMENT_REQUEST" ||
          order.orderStatus == "DONE_COLLECTING" ||
          order.orderStatus == "DONE_PAYMENT_REQUEST"
      )
          .toList();

      List<TShopperOrder> ready = orders
          .where((order) =>
      order.orderStatus == "READY_FOR_PICKUP_DELIVERY")
          .toList();
      ref.read(pendingOrderProvider).allPendingOrders = pendingOrders;
      ref.read(newOrderProvider).allNewOrders = newOrders;
      ref.read(inPreparationOrderProvider).allInPreparationOrders = inPreparation;
      ref.read(readyOrderProvider).allReadyOrders = ready;
    }else{
      ref.read(pendingOrderProvider).allPendingOrders = [];
      ref.read(newOrderProvider).allNewOrders = [];
      ref.read(inPreparationOrderProvider).allInPreparationOrders = [];
      ref.read(readyOrderProvider).allReadyOrders = [];
    }
    setState(() {
      isLoading = false;
    });
  }

  final List<String> tabTitles = ['הזמנות חדשות','הזמנות בממתינה', 'הזמנות בהכנה', 'הזמנות מוכנות'];
  late TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteText,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
              GestureDetector(
                onTap: () => overlayMenu.showOverlay(0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.iconLightGrey,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(5),
                  child: Icon(
                    size: 22.dp,
                    Icons.menu,
                    color: AppColors.whiteText,
                  ),
                ),
              ),
          ],
        ),
        backgroundColor: AppColors.whiteText,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: isLoading ? Container(
            color: AppColors.whiteText,
          ) : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTab('הזמנות חדשות', ref.read(pendingOrderProvider).allPendingOrders.length, 0),
                _buildTab('הזמנות בממתינה', ref.read(newOrderProvider).allNewOrders.length, 1),
                _buildTab('הזמנות בהכנה', ref.read(inPreparationOrderProvider).allInPreparationOrders.length, 2),
                _buildTab('הזמנות מוכנות', ref.read(readyOrderProvider).allReadyOrders.length, 3),
              ],
            ),
          ),
        ),
      ),
      body: isLoading ? Container(
        color: AppColors.whiteText,
        child: Center(
          child: CupertinoActivityIndicator(
            animating: true,
            color: AppColors.blackText,
            radius: 15.dp,
          ),
        ),
      ) : _buildContent(),
    );
  }

  Widget _buildTab(String title, int count, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Padding(
        padding: EdgeInsets.only(top: 10.0.dp, left: 6.dp, right: 6.dp),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Main tab content
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.dp, vertical: 6.dp),
              decoration: BoxDecoration(
                color: selectedIndex == index ? AppColors.primeryColor : isLightMode ? AppColors.primaryLightColor : AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                title,
                style: TextStyle(
                  color: selectedIndex == index ? AppColors.white : AppColors.blackText,
                  fontFamily: 'arimo',
                  fontWeight: FontWeight.w900,
                  fontSize: AppFontSize.fontSizeMiddleSmall,
                ),
              ),
            ),
            // Circle for the amount
            if (count > 0)
              Positioned(
                top: -7.dp,
                left: -5.dp,
                child: Container(
                  width: 20.dp,
                  height: 20.dp,
                  decoration: BoxDecoration(
                    color: selectedIndex == index ? AppColors.superLightPurple : AppColors.primeryColor,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$count', // Show the amount
                    style: TextStyle(
                        color: selectedIndex == index ? AppColors.primeryColor : AppColors.white,
                        fontSize: AppFontSize.fontSizeExtraSmall,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'arimo'
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

      Widget _buildContent(){
        List<TShopperOrder> allOrders = [];
          ref.watch(pendingOrderProvider);
          ref.watch(newOrderProvider);
          ref.watch(inPreparationOrderProvider);
          ref.watch(readyOrderProvider);
        if (selectedIndex == 0) {
          allOrders = ref.read(pendingOrderProvider).allPendingOrders;
        }
        if (selectedIndex == 1) {
          allOrders = ref.read(newOrderProvider).allNewOrders;
        }
        if (selectedIndex == 2) {
          allOrders = ref.read(inPreparationOrderProvider).allInPreparationOrders;
        }
        if (selectedIndex == 3) {
          allOrders = ref.read(readyOrderProvider).allReadyOrders;
        }

        final uniqueOrdersMap = {
          for (var order in allOrders) order.orderId: order
        };

        allOrders = uniqueOrdersMap.values.toList();

        allOrders.sort((a, b) => a.getOrderPlaced().compareTo(b.getOrderPlaced()));

      return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              Column(
                children: [
                 // Order list
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.dp),
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: allOrders.length,
                          itemBuilder: (context, index) {
                            final orderData = allOrders[index];
                            if(selectedIndex == 0){
                              return Padding(
                                padding: EdgeInsets.only(bottom: 15.dp),
                                child: PendingOrderItem(
                                  isFuture: selectedNewSectionIndex == 0,
                                  order: orderData,
                                ),
                              );
                            }
                            if(selectedIndex == 1){
                              return Padding(
                                padding: EdgeInsets.only(bottom: 15.dp),
                                child: NewOrderItem(
                                  isFuture: selectedNewSectionIndex == 1,
                                  order: orderData,
                                ),
                              );
                            }
                            if(selectedIndex == 2){
                              return Padding(
                                padding: EdgeInsets.only(bottom: 15.dp),
                                child: InProgressItem(
                                  order: orderData,
                                ),
                              );
                            }
                            if(selectedIndex == 3){
                              return Padding(
                                padding: EdgeInsets.only(bottom: 15.dp),
                                child: ReadyItem(
                                  order: orderData,
                                ),
                              );
                            }
                            return Padding(
                              padding: EdgeInsets.only(bottom: 15.dp),
                              child: NewOrderItem(
                                order: orderData,
                                isFuture: true,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
      );
  }

  @override
  void dispose() {
    _tabController.dispose();
    routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    // AblyService.unsubscribeFromChannel();
    _timer.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _onAppResume();
    }
  }
  void _onAppResume() async{
    fetchData();
  }

  Widget _buildToggleButton(
      String title, {
        int count = 0,
        bool isSelected = false,
        void Function()? onSelect,
      }) {
    return Expanded(
      child: GestureDetector(
        onTap: onSelect,
        child: Card(
          color: isSelected ? AppColors.whiteText : AppColors.transparentPerm,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.dp),
          ),
          child: Container(
            margin: EdgeInsets.all(4.dp),
            decoration: isSelected
                ? BoxDecoration(
              color: AppColors.whiteText,
              borderRadius: BorderRadius.circular(10.dp),
            )
                : null,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppFontSize.fontSizeExtraSmall,
                    fontWeight: FontWeight.w800,
                    color: isSelected
                        ? AppColors.blackText
                        : isLightMode ? AppColors.oppositeBackgroundColor : AppColors.blackText,
                    fontFamily: 'Arimo',
                  ),
                ),
                if(count != 0)...[
                  SizedBox(width: 8.dp,),
                  Text(
                    "( $count )",
                    style: TextStyle(
                      fontSize: AppFontSize.fontSizeExtraSmall,
                      fontWeight: FontWeight.w800,
                      color: isSelected
                          ? AppColors.blackText
                          : isLightMode ? AppColors.oppositeBackgroundColor : AppColors.blackText,
                      fontFamily: 'Arimo',
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TabContainer extends StatelessWidget {
  final String text;
  final int amount;
  final bool isSelected;

  TabContainer(this.text, this.amount, this.isSelected);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0.dp),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main tab content
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primeryColor : AppColors.primaryLightColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? AppColors.white : AppColors.blackText,
                fontFamily: 'arimo',
                fontWeight: FontWeight.w900,
                fontSize: AppFontSize.fontSizeExtraSmall,
              ),
            ),
          ),
          // Circle for the amount
          if (amount > 0)
            Positioned(
              top: -7.dp, // Adjust position
              left: -5.dp, // Adjust position
              child: Container(
                width: 20.dp, // Adjust size
                height: 20.dp, // Adjust size
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.superLightPurple : AppColors.primeryColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$amount', // Show the amount
                  style: TextStyle(
                    color: isSelected ? AppColors.primeryColor : AppColors.white,
                    fontSize: AppFontSize.fontSizeExtraSmall,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'arimo'
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }


}
