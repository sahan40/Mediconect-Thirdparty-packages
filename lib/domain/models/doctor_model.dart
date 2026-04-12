import 'package:flutter/material.dart';

class DoctorModel {
  final String id;
  final String name;
  final String specialty;
  final String experience;
  final double rating;
  final String patientCount;
  final String reviewCount;
  final Color avatarBgColor;
  final String biography;
  final List<String> education;
  final List<DoctorReview> reviews;
  final double consultationFee;
  final int durationMins;
  bool isFavourite;

  DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.experience,
    required this.rating,
    required this.patientCount,
    required this.reviewCount,
    required this.avatarBgColor,
    required this.biography,
    required this.education,
    required this.reviews,
    required this.consultationFee,
    required this.durationMins,
    this.isFavourite = false,
  });
}

class DoctorReview {
  final String reviewer;
  final double rating;
  final String comment;
  final String date;

  const DoctorReview({
    required this.reviewer,
    required this.rating,
    required this.comment,
    required this.date,
  });
}
