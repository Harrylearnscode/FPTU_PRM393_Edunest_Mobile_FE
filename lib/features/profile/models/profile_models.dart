class ProfileModel {
  final int userId;
  final String name;
  final String email;
  final String? phone;
  final String role;

  final int? tutorId;
  final String? tutorBio;

  final String? avatarUrl;

  ProfileModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.tutorId,
    this.tutorBio,
    this.avatarUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      userId: _asInt(json['userId']),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      role: json['role']?.toString() ?? '',
      tutorId: json['tutorId'] == null ? null : _asInt(json['tutorId']),
      tutorBio: json['tutorBio']?.toString(),
      avatarUrl: json['avatarUrl']?.toString(),
    );
  }
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
