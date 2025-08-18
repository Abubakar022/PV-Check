import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ConnectivityController extends GetxController {
  final RxBool isConnected = true.obs;
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  @override
  void onInit() {
    super.onInit();
    // Check initial state after a small delay to ensure GetMaterialApp is ready
    Future.delayed(const Duration(milliseconds: 500), _initConnectivity);
    _subscription = Connectivity().onConnectivityChanged.listen(_updateStatus);
  }

  /// 🔁 Check connectivity once at startup
  Future<void> _initConnectivity() async {
    try {
      List<ConnectivityResult> result = await Connectivity().checkConnectivity();
      final hasConnection = result.any((r) => r != ConnectivityResult.none);
      isConnected.value = hasConnection;

      if (!hasConnection) {
        // 📴 Show snackbar if user opens app offline
        Get.snackbar(
          'No Internet Connection',
          'You are currently offline.',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          duration: const Duration(days: 1),
          snackPosition: SnackPosition.BOTTOM,
          mainButton: TextButton(
            onPressed: () => Get.closeAllSnackbars(),
            child: const Text('Dismiss', style: TextStyle(color: Colors.white)),
          ),
        );
      }
    } catch (e) {
      debugPrint("⚠️ Error checking connectivity: $e");
    }
  }

  /// 🔁 Live updates when connection changes
  void _updateStatus(List<ConnectivityResult> results) {
    final hasConnection = results.any((r) => r != ConnectivityResult.none);
    final wasConnected = isConnected.value;

    if (!hasConnection && wasConnected) {
      // 📴 Went offline
      Get.snackbar(
        'No Internet Connection',
        'Please check your network.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        duration: const Duration(days: 1),
        snackPosition: SnackPosition.BOTTOM,
        mainButton: TextButton(
          onPressed: () => Get.closeAllSnackbars(),
          child: const Text('Dismiss', style: TextStyle(color: Colors.white)),
        ),
      );
    } else if (hasConnection && !wasConnected) {
      // 🔁 Back online
      Get.closeAllSnackbars();
    }

    isConnected.value = hasConnection;
  }

  @override
  void onClose() {
    _subscription.cancel(); // Cleanup
    super.onClose();
  }
}