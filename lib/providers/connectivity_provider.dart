import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityProvider = StreamProvider<ConnectivityResult>((ref) {
  final connectivity = Connectivity();
  return Stream<ConnectivityResult>.multi((controller) async {
    final initial = await connectivity.checkConnectivity();
    controller.add(
      initial.isNotEmpty ? initial.first : ConnectivityResult.none,
    );

    final sub = connectivity.onConnectivityChanged.listen((results) {
      controller.add(
        results.isNotEmpty ? results.first : ConnectivityResult.none,
      );
    });

    controller.onCancel = sub.cancel;
  });
});
