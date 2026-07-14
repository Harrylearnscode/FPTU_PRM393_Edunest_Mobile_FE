import 'package:flutter/foundation.dart';

import '../../../core/network/api_utils.dart';
import '../../booking/providers/booking_provider.dart';
import '../models/payment_models.dart';
import '../services/payment_service.dart';

class PaymentProvider extends ChangeNotifier {
  final PaymentService paymentService;

  PaymentProvider({required this.paymentService});

  bool loading = false;
  String? error;

  void clearSessionData() {
    loading = false;
    error = null;
    notifyListeners();
  }

  Future<PaymentModel> createPayment(int bookingId) async {
    late PaymentModel payment;
    await _guard(() async {
      payment = await paymentService.createPayOsPayment(bookingId);
    });
    return payment;
  }

  Future<PaymentModel> syncPayment(
    int bookingId, {
    required BookingProvider bookingProvider,
  }) async {
    late PaymentModel payment;
    await _guard(() async {
      payment = await paymentService.syncPayment(bookingId);
      await bookingProvider.refreshAfterPayment();
    });
    return payment;
  }

  Future<void> _guard(Future<void> Function() task) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      await task();
    } catch (e) {
      error = ApiUtils.apiErrorMessage(e);
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
