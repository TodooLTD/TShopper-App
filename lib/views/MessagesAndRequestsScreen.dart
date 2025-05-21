import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tshopper_app/models/managerRequest/ManagerRequest.dart';
import 'package:tshopper_app/models/tshopper/TShopper.dart';
import 'package:tshopper_app/sevices/ManagerRequestService.dart';
import 'package:tshopper_app/widgets/managerRequest/SupportRequestCard.dart';
import '../constants/AppColors.dart';
import '../constants/AppFontSize.dart';
import '../main.dart';
import '../widgets/overlayMenu/OverlayMenu.dart';

class MessagesAndRequestsScreen extends ConsumerStatefulWidget {

  MessagesAndRequestsScreen({super.key});

  @override
  _MessagesAndRequestsScreenState createState() => _MessagesAndRequestsScreenState();
}

class _MessagesAndRequestsScreenState extends ConsumerState<MessagesAndRequestsScreen> with TickerProviderStateMixin {
  final OverlayMenu overlayMenu = OverlayMenu();
  List<ManagerRequest> requests = [];
  int _toggleIndex = 0;
  bool _isLoading = true;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    overlayMenu.init(context, this);
    fetchData();
  }

  Future<void> fetchData() async {
    requests = await ManagerRequestService.getManagerRequestsByShopper(TShopper.instance.uid);
    if(requests.isNotEmpty){
      requests.sort((a,b) => b.getCreatedAt().compareTo(a.getCreatedAt()));
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _onToggleTap(int index) {
    setState(() {
      _toggleIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteText,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => overlayMenu.showOverlay(3),
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
      ),
      body: _isLoading ? Container(
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


  Widget _buildContent() {
    if(requests.length > 1) requests.sort((a, b) => b.getCreatedAt().compareTo(a.getCreatedAt()));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.dp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("בקשות והתראות", style: TextStyle(fontFamily: 'todofont', fontSize: 26.dp, fontWeight: FontWeight.w800, color: AppColors.blackText),),
              SizedBox(height: 8.dp),
              Center(
                child: Container(
                  height: 32.dp,
                  margin: EdgeInsets.symmetric(horizontal: 8.dp),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLightColor,
                    borderRadius:
                    BorderRadius.circular(AppFontSize.circularRadiusVal),
                  ),
                  child: Row(
                    children: [
                      _buildToggleButton(
                        count: requests.length,
                        translate("בקשות"),
                        isSelected: _toggleIndex == 0,
                        onSelect: () => _onToggleTap(0),
                      ),
                      _buildToggleButton(
                        count: 0,
                        translate("התראות"),
                        isSelected: _toggleIndex == 1,
                        onSelect: () => _onToggleTap(1),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.dp),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.dp),
            child: _toggleIndex == 1
                ?
            ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: 0,
              itemBuilder: (context, index) {
                return Container();
              },
            )

                : ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return ManagerRequestCard(
                  request: request,
                  onDelete: (ManagerRequest request) {
                    setState(() {
                      requests.remove(request);
                    });
                  },
                );
              },
            ),
          ),
        ),
        SizedBox(height: 40.dp,),
        // if(_toggleIndex == 0)
        //   Align(
        //     alignment: Alignment.bottomCenter,
        //     child: Padding(
        //       padding: EdgeInsets.only(bottom: 30.dp),
        //       child: GestureDetector(
        //         onTap: () async {
        //           // showCustomPopup(context);
        //         } ,
        //         child: Container(
        //           width: MediaQuery.of(context).size.width * 0.9,
        //           height: 50.dp,
        //           decoration: BoxDecoration(
        //             color: AppColors.primeryColor,
        //             borderRadius: BorderRadius.circular(10.dp),
        //             border: Border.all(
        //               color: AppColors.primeryColor,
        //               width: 1.dp,
        //             ),
        //           ),
        //           child: Center(
        //             child: Text("פתיחת פנייה",
        //               style: TextStyle(
        //                   fontFamily: 'arimo',
        //                   fontWeight: FontWeight.w900,
        //                   fontSize: AppFontSize.fontSizeSmall,
        //                   color: AppColors.white
        //               ),),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
      ],
    );
  }

  // void showCustomPopup(BuildContext context) {
  //   TextEditingController shortTextController = TextEditingController();
  //   TextEditingController longTextController = TextEditingController();
  //
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         elevation: 0,
  //         backgroundColor: AppColors.backgroundColor,
  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.dp)),
  //         title: Center(
  //           child: Text(
  //             "פנייה חדשה", // Title
  //             style: TextStyle(fontSize: 22.dp, color: AppColors.blackText, fontWeight: FontWeight.w800),
  //           ),
  //         ),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Text(
  //               "שימו לב- יש לפרט את פרטי הפנייה ככל האפשר כדי שנוכל לטפל בה בהקדם🙏🏻", // Subtitle
  //               textAlign: TextAlign.center,
  //               style: TextStyle(fontSize: 13.dp, fontFamily: 'arimo', fontWeight: FontWeight.w500, color: AppColors.blackText),
  //             ),
  //             SizedBox(height: 10.dp),
  //             TextField(
  //               controller: shortTextController,
  //               maxLength: 30,
  //               style: TextStyle(
  //                 color: AppColors.blackText,
  //                 fontSize: AppFontSize.fontSizeMedium,
  //                 fontFamily: 'arimo',
  //                 fontWeight: FontWeight.w400,
  //               ),
  //               decoration: InputDecoration(
  //                 labelText: "נושא הפניה (עד 30 תווים)",
  //                 labelStyle: TextStyle(
  //                   color: AppColors.mediumGreyText,
  //                   fontSize: AppFontSize.fontSizeMedium,
  //                   fontFamily: 'arimo',
  //                   fontWeight: FontWeight.w400,
  //                 ),
  //
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(15.dp),
  //                   borderSide: BorderSide(color: AppColors.borderColor),
  //                 ),
  //                 focusedBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(15.dp),
  //                   borderSide: BorderSide(color: AppColors.borderColor),
  //                 ),
  //                 enabledBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(15.dp),
  //                   borderSide: BorderSide(color: AppColors.borderColor),
  //                 ),
  //                 disabledBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(15.dp),
  //                   borderSide: BorderSide(color: AppColors.borderColor),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(height: 10.dp),
  //             TextField(
  //               controller: longTextController,
  //               maxLength: 1000,
  //               maxLines: 4,
  //               style: TextStyle(
  //                 color: AppColors.blackText,
  //                 fontSize: AppFontSize.fontSizeMedium,
  //                 fontFamily: 'arimo',
  //                 fontWeight: FontWeight.w400,
  //               ),
  //               decoration: InputDecoration(
  //                 labelText: "פירוט (עד 1000 תווים)",
  //                 labelStyle: TextStyle(
  //                   color: AppColors.mediumGreyText,
  //                   fontSize: AppFontSize.fontSizeMedium,
  //                   fontFamily: 'arimo',
  //                   fontWeight: FontWeight.w400,
  //                 ),
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(15.dp),
  //                   borderSide: BorderSide(color: AppColors.borderColor),
  //                 ),
  //                 focusedBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(15.dp),
  //                   borderSide: BorderSide(color: AppColors.borderColor),
  //                 ),
  //                 enabledBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(15.dp),
  //                   borderSide: BorderSide(color: AppColors.borderColor),
  //                 ),
  //                 disabledBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(15.dp),
  //                   borderSide: BorderSide(color: AppColors.borderColor),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           Row(
  //             children: [
  //               Expanded(
  //                 flex: 1,
  //                 child: TextButton(
  //                   onPressed: () async {
  //                     ManagerRequest newRequest = ManagerRequest(
  //                         id: 0,
  //                         createdAt: '',
  //                         request: longTextController.text,
  //                         requestSubject: shortTextController.text,
  //                         status: '',
  //                         response: '',
  //                         resolvedAt: '');
  //                     SupportRequest? response = await SupportRequestService.addSupportRequest(newRequest);
  //                     if(response != null){
  //                       setState(() {
  //                         requests.add(response);
  //                         requests.sort((a,b) => b.getCreatedAt().compareTo(a.getCreatedAt()));
  //                       });
  //                       Navigator.of(context).pop();
  //                     }else{
  //                       showBottomPopup(
  //                         context: context,
  //                         message: "שגיאה בשליחת פנייה. נסה שוב",
  //                         imagePath: "assets/images/warning_icon.png",
  //                       );
  //                     }
  //                   },
  //                   style: TextButton.styleFrom(
  //                     foregroundColor: AppColors.whiteText,
  //                     backgroundColor: AppColors.primeryColor,
  //                     padding:
  //                     EdgeInsets.symmetric(vertical: 15.dp),
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(10.dp),
  //                     ),
  //                   ),
  //                   child: Text(
  //                     "אישור",
  //                     style: TextStyle(
  //                         fontSize: AppFontSize.fontSizeSmall,
  //                         fontFamily: 'arimo',
  //                         color: AppColors.white,
  //                         fontWeight: FontWeight.w800),
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(width: 8.dp,),
  //               Expanded(
  //                 flex: 1,
  //                 child: TextButton(
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                   },
  //                   style: TextButton.styleFrom(
  //                     foregroundColor: AppColors.whiteText,
  //                     backgroundColor: AppColors.superLightPurple,
  //                     padding:
  //                     EdgeInsets.symmetric(vertical: 15.dp),
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(10.dp),
  //                     ),
  //                   ),
  //                   child: Text(
  //                     "ביטול",
  //                     style: TextStyle(
  //                         fontSize: AppFontSize.fontSizeSmall,
  //                         fontFamily: 'arimo',
  //                         color: AppColors.primeryColor,
  //                         fontWeight: FontWeight.w500),
  //                   ),
  //                 ),
  //               ),
  //
  //             ],
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

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
                        : AppColors.oppositeBackgroundColor,
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
                          : AppColors.oppositeBackgroundColor,
                      fontFamily: 'Arimo',
                    ),
                  ),
                  // Container(
                  //   width: 20.dp,
                  //   height: 20.dp,
                  //   decoration: BoxDecoration(
                  //     color: AppColors.blackText,
                  //     shape: BoxShape.circle,
                  //   ),
                  //   alignment: Alignment.center,
                  //   child: Text(
                  //     '$count', // Show the amount
                  //     style: TextStyle(
                  //         color:AppColors.whiteText,
                  //         fontSize: AppFontSize.fontSizeExtraSmall,
                  //         fontWeight: FontWeight.w800,
                  //         fontFamily: 'arimo'
                  //     ),
                  //   ),
                  // ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

}
