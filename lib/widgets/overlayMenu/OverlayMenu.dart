import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:tshopper_app/views/HomeScreen.dart';
import 'package:tshopper_app/views/ShiftsScreen.dart';
import '../../constants/AppColors.dart';
import '../../constants/AppFontSize.dart';
import '../../main.dart';
import '../../views/AllConversationsScreen.dart';
import '../../views/MessagesAndRequestsScreen.dart';
import '../../views/ShopperDetailsScreen.dart';
import '../../views/SocialScreen.dart';

class OverlayMenu {
  static final OverlayMenu _instance = OverlayMenu._internal();
  factory OverlayMenu() => _instance;

  OverlayMenu._internal(); // Private constructor

  late OverlayEntry _overlayEntry;
  bool _isMenuOpen = false;
  late AnimationController _animationController;
  late Animation<Offset> positionAnimation;
  late BuildContext _context;
  late TickerProvider _vsync;

  void init(BuildContext context, TickerProvider vsync) {
    _context = context;
    _vsync = vsync;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: vsync,
    );

    positionAnimation = Tween<Offset>(
      begin: const Offset(0, -1), // Start hidden
      end: Offset.zero, // Fully visible
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        _overlayEntry.remove();
        _isMenuOpen = false;
      }
    });
  }

  /// ✅ Show overlay menu with animation
  void showOverlay(int screenIndex) {
    if (_isMenuOpen) return;

    _overlayEntry = _createOverlayEntry(screenIndex);
    Overlay.of(_context).insert(_overlayEntry);
    _isMenuOpen = true;
    _animationController.forward(); // Start animation
  }

  /// ✅ Close overlay menu with animation
  void closeOverlay() {
    if (_isMenuOpen) {
      _animationController.reverse(); // Start closing animation
    }
  }

  /// ✅ Create overlay UI with animation
  OverlayEntry _createOverlayEntry(int screenIndex) {
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: closeOverlay,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: AppColors.black.withOpacity(
                    0.5),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -1),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent:
                  _animationController,
                  curve: Curves.easeOut,
                ),
              ),
              child: Material(
                elevation: 0,
                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                child: Ink(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.backgroundColor,
                        blurRadius: 0.0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding:  const EdgeInsets.only(top: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding:  EdgeInsets.only(top: 20.dp, right: 8.0, left: 8.0, bottom: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Image.asset(
                                  "assets/images/todoLOGO-removebg.png",
                                  width: 60,
                                  height: 25,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 8.0.dp),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 32.0.dp, // Horizontal space between buttons
                            runSpacing: 16.0.dp, // Vertical space between rows
                            children: [
                                _buildCircleButton(
                                  context: context,
                                  "assets/images/iconOrders.png",
                                  "הזמנות",
                                  // onTap: () {
                                  //   Navigator.pushReplacement(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //           builder: (context) => HomeScreen()));
                                  // },
                                  screenBuilder: (context) => HomeScreen(),
                                ),
                              _buildCircleButton(
                                context: context,
                                "assets/images/iconStory.png",
                                "סושיאל",
                                // onTap: () {
                                //   Navigator.pushReplacement(
                                //       context,
                                //       MaterialPageRoute(
                                //           builder: (context) => SocialScreen()));
                                // },
                                screenBuilder: (context) => SocialScreen(),
                              ),
                              _buildCircleButton(
                                context: context,
                                "assets/images/iconChat.png",
                                "צאט",
                                  screenBuilder: (context) => AllConversationsScreen(),

                ),
                              _buildCircleButton(
                                context: context,
                                "assets/images/iconMessages.png",
                                "פניות ועדכונים",
                                // onTap: () {
                                //   Navigator.pushReplacement(
                                //       context,
                                //       MaterialPageRoute(
                                //           builder: (context) => MessagesAndRequestsScreen()));
                                // },
                                screenBuilder: (context) => MessagesAndRequestsScreen(),
                              ),
                              _buildCircleButton(
                                context: context,
                                "assets/images/iconWorkersManager.png",
                                "משמרות",
                                // onTap: () {
                                //   Navigator.pushReplacement(
                                //       context,
                                //       MaterialPageRoute(
                                //           builder: (context) => ShiftsScreen()));
                                // },
                                screenBuilder: (context) => ShiftsScreen(),
                              ),
                              _buildCircleButton(
                                context: context,
                                "assets/images/iconDetails.png",
                                "אזור אישי",
                                // onTap: () {
                                //   Navigator.pushReplacement(
                                //       context,
                                //       MaterialPageRoute(
                                //           builder: (context) => ShopperDetailsScreen()));
                                // },
                                screenBuilder: (context) => ShopperDetailsScreen(),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton(
      String image,
      String label, {
        required BuildContext context,
        Widget Function(BuildContext)? screenBuilder,
        void Function()? onTap,
      }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        InkWell(
          onTap: () {
            if (onTap != null) {
              Future.delayed(const Duration(milliseconds: 300), onTap);
            } else if (screenBuilder != null) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: screenBuilder));
              closeOverlay();
            }
          },
          child: Material(
            color: AppColors.backgroundColor,
            shape: const CircleBorder(),
            child: Container(
                width: 50.dp,
                height: 50.dp,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(image, width: 25.dp, height: 25.dp),
                )),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: AppFontSize.fontSizeExtraSmall,
            fontFamily: "arimo",
            fontWeight: FontWeight.w600,
            color: AppColors.primeryColortext,
          ),
        ),
      ],
    );
  }
}
