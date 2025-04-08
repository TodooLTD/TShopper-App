import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../../../constants/AppColors.dart';
import '../../../../constants/AppFontSize.dart';
import '../../main.dart';
import '../../providers/InPreparationOrderProvider.dart';

class CircularTimer extends ConsumerStatefulWidget {
  final int durationInMinutes;
  final int minutesToBeReady;
  final void Function()? onTimerEnd;
  final bool isReady;
  final bool isSmall;
  final bool startTimer;
  final bool isFuture;

  const CircularTimer({
    super.key,
    required this.durationInMinutes,
    required this.minutesToBeReady,
    this.onTimerEnd,
    this.isSmall = true,
    this.isReady = false,
    this.startTimer = true,
    this.isFuture = false,
  });

  @override
  ConsumerState<CircularTimer> createState() => _CircularTimerState();
}

class _CircularTimerState extends ConsumerState<CircularTimer> {
  late int remainingMinutes;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    startTimer(widget.durationInMinutes);
  }

  void startTimer(int totalMinutes) {
    remainingMinutes = totalMinutes;
    timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (widget.isReady) {
        setState(() => remainingMinutes++);
      } else {
        if (remainingMinutes > 0) {
          setState(() => remainingMinutes--);
        }
        if (remainingMinutes == 0) {
          if (widget.onTimerEnd != null) widget.onTimerEnd!();
          timer.cancel();
        }
      }
    });
    if(!widget.startTimer){
      timer.cancel();
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (remainingMinutes == 10 || remainingMinutes == 0) {

      Future.microtask(() {
        if(mounted){
          ref
              .read(inPreparationOrderProvider.notifier)
              .updateCompleteOrderTime("");
        }
      });


    }

    double progress = 1 - (remainingMinutes / widget.minutesToBeReady);
    if (widget.durationInMinutes == 0 || widget.isReady) {
      progress = 1;
    }
    Color startColor = remainingMinutes > 0 || widget.isReady
        ? AppColors.superLightPurple
        : AppColors.redColor;
    Color endColor = remainingMinutes > 0 || widget.isReady
        ? AppColors.primeryColor
        : AppColors.redColor;

    if(!widget.startTimer){
      progress = 1;
    }

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: widget.isSmall ? 42.dp : 45.dp,
            height: widget.isSmall ? 42.dp : 45.dp,
            child: CustomPaint(
              painter: TimerPainter(progress, startColor, endColor),
            ),
          ),
          widget.isFuture ? Text(
            'עתידית',
            style: TextStyle(fontSize: AppFontSize.fontSizeExtraSmall, color: AppColors.primeryColortext, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ) :
          remainingMinutes == 0 ?
          Text(
            'בעיכוב',
            style: TextStyle(fontSize: AppFontSize.fontSizeExtraSmall, color: AppColors.redColor, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          )
              : Text(
            '$remainingMinutes',
            style: TextStyle(fontSize: widget.isSmall ? 20.dp : 22.dp, color: AppColors.primeryColortext, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class TimerPainter extends CustomPainter {
  final double progress;
  final Color startColor;
  final Color endColor;

  TimerPainter(this.progress, this.startColor, this.endColor);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = isLightMode ? Colors.grey.shade300 : Colors.grey.shade800
      ..strokeWidth = 3.dp
      ..style = PaintingStyle.stroke;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    canvas.drawCircle(center, radius, paint);

    // Calculate gradient stops
    final List<Color> gradientColors = [startColor, endColor];
    final List<double> stops = [0.0, 1.0];

    // Define the gradient
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: gradientColors,
      stops: stops,
    );

    // Use shader for gradient
    Paint progressPaint = Paint()
      ..shader =
      gradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = 3.dp
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double angle = 2 * pi * progress;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        angle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
