import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'notifiers/PendingOrderNotifier.dart';

final pendingOrderProvider =
StateNotifierProvider<PendingOrderNotifier, PendingOrderData>(
      (ref) => PendingOrderNotifier(),
);