import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:tshopper_app/models/order/deliveryMission/DeliveryMission.dart';
import 'package:tshopper_app/sevices/TShopperService.dart';
import '../../../../constants/AppColors.dart';
import '../../../../constants/AppFontSize.dart';
import '../../providers/InPreparationOrderProvider.dart';

class TimeToCourierWidget extends ConsumerStatefulWidget {
 DeliveryMission mission;

  TimeToCourierWidget({
    super.key,
    required this.mission,
  });

  @override
  ConsumerState<TimeToCourierWidget> createState() => _TimeToCourierWidgetState();
}

class _TimeToCourierWidgetState extends ConsumerState<TimeToCourierWidget> {
  bool isLoading = true;
  int minutes = -1;
  Timer? _timer; // Timer reference

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

  @override
  void initState() {
    super.initState();
    fetchTime();
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      fetchTime(); // fetch every 1 minute
    });
  }

  Future<void> fetchTime() async {
    int fetchedMinutes = await TShopperService.getTimeTillCourierArrive(int.parse(widget.mission.id));
    if (mounted) {
      setState(() {
        minutes = fetchedMinutes;
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Always cancel timers
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ?
    Container(
      color: AppColors.whiteText,
      child: Center(
        child: CupertinoActivityIndicator(
          animating: true,
          color: AppColors.blackText,
          radius: 8.dp,
        ),
      ),
    )
    : Row(
     children: [
       if(widget.mission.timeline.orderPickedUp!.isNotEmpty)...[
         Icon(Icons.check_circle, size: 14.dp, color: AppColors.strongGreen,),
         SizedBox(width: 4.dp,),
         Text("נאסף", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.dp, color: AppColors.strongGreen, fontFamily: 'arimo')),
         SizedBox(width: 16.dp,),
         Icon(Icons.shopping_bag, size: 14.dp, color: colorMap[widget.mission.stickerColor]),
         SizedBox(width: 4.dp,),
         Text(widget.mission.bagsAmount.toString(), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.dp, color: colorMap[widget.mission.stickerColor], fontFamily: 'arimo')),
       ],
       if(widget.mission.timeline.courierArrivedAtBusiness!.isNotEmpty && widget.mission.timeline.orderPickedUp!.isEmpty)...[
         Icon(Icons.delivery_dining, size: 16.dp, color: AppColors.primeryColor,),
         SizedBox(width: 4.dp,),
         Text("השליח הגיע", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.dp, color: AppColors.primeryColor, fontFamily: 'arimo'))
       ],
       if(widget.mission.timeline.orderPickedUp!.isEmpty && widget.mission.timeline.courierArrivedAtBusiness!.isEmpty)...[
         Container(
             margin:
             const EdgeInsets
                 .all(2),
             padding:
             const EdgeInsets
                 .all(1),
             decoration:
             BoxDecoration(
               color: AppColors
                   .blackText,
               shape: BoxShape
                   .circle,
             ),
             child: Icon(
               Icons.delivery_dining,
               color:
               AppColors
                   .white,
               size: 14.dp,
             )),
         SizedBox(width: 2.dp,),
         Text(minutes == 0 ? "עכשיו" : minutes.toString() + " דקות", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.dp, color: AppColors.blackText, fontFamily: 'arimo')),
       ],
     ],
    );
  }
}

