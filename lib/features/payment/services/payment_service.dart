import '../../../core/network/api_client.dart';
import '../../../core/network/api_utils.dart';
import '../models/payment_models.dart';

class PaymentService {
  final ApiClient apiClient;

  PaymentService(this.apiClient);

  Future<PaymentModel> createPayOsPayment(int bookingId) async {
    final res =
        await apiClient.dio.post('/api/payment/booking/$bookingId/payos');
    return PaymentModel.fromJson(ApiUtils.asMap(res.data));
  }

  Future<PaymentModel> syncPayment(int bookingId) async {
    final res =
        await apiClient.dio.post('/api/payment/booking/$bookingId/sync');
    return PaymentModel.fromJson(ApiUtils.asMap(res.data));
  }
}
