import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle heading = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 15,
    color: AppColors.textSecondary,
    height: 1.55,
  );

  static const TextStyle fieldLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textLabel,
  );

  static const TextStyle fieldHint = TextStyle(
    fontSize: 15,
    color: AppColors.textSecondary,
  );

  static const TextStyle fieldInput = TextStyle(
    fontSize: 15,
    color: AppColors.textPrimary,
  );

  static const TextStyle primaryButton = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: 0.3,
  );

  static const TextStyle link = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.accent,
  );

  static const TextStyle linkBold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.accent,
  );

  static const TextStyle appBarTitle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle dividerLabel = TextStyle(
    fontSize: 13,
    color: AppColors.textSecondary,
  );

  static const TextStyle footerNormal = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static const TextStyle secureLabel = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );
}