class PaymentModel {
  final int paymentId;
  final int bookingId;
  final double amount;
  final String status;
  final String provider;
  final int orderCode;
  final String description;
  final String? checkoutUrl;
  final String? qrCode;

  PaymentModel({
    required this.paymentId,
    required this.bookingId,
    required this.amount,
    required this.status,
    required this.provider,
    required this.orderCode,
    required this.description,
    required this.checkoutUrl,
    required this.qrCode,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      paymentId: _asInt(json['paymentId']),
      bookingId: _asInt(json['bookingId']),
      amount: _asDouble(json['amount']),
      status: json['status']?.toString() ?? '',
      provider: json['provider']?.toString() ?? '',
      orderCode: _asInt(json['orderCode']),
      description: json['description']?.toString() ?? '',
      checkoutUrl: json['checkoutUrl']?.toString(),
      qrCode: json['qrCode']?.toString(),
    );
  }
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

double _asDouble(dynamic value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}
