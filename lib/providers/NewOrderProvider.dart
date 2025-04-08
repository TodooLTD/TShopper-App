import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notifiers/NewOrderNotifier.dart';


final newOrderProvider =
StateNotifierProvider<NewOrderNotifier, NewOrderData>(
      (ref) => NewOrderNotifier(),
);