import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'notifiers/InPreparationOrderNotifier.dart';

final inPreparationOrderProvider =
StateNotifierProvider<InPreparationOrderNotifier, InPreparationOrderData>(
      (ref) => InPreparationOrderNotifier(),
);