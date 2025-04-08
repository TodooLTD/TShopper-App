import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notifiers/ReadyOrderNotifier.dart';


final readyOrderProvider =
StateNotifierProvider<ReadyOrderNotifier, ReadyOrderData>(
      (ref) => ReadyOrderNotifier(),
);