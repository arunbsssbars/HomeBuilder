import 'package:flutter/foundation.dart';

enum UserRole {
  customer,
  vendor,
  admin,
}

@immutable
class UserModel {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final UserRole role;
  final bool isProfileComplete;
  final String? gstin;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.role,
    this.isProfileComplete = true,
    this.gstin,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'email': email,
        'role': role.name,
        'isProfileComplete': isProfileComplete,
        'gstin': gstin,
        'createdAt': createdAt.toIso8601String(),
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        name: json['name'] as String,
        phone: json['phone'] as String,
        email: json['email'] as String?,
        role: UserRole.values.byName(json['role'] as String),
        isProfileComplete: json['isProfileComplete'] as bool? ?? true,
        gstin: json['gstin'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
