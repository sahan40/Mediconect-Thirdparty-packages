import 'package:flutter/material.dart';
import 'package:medi_connect/domain/models/doctor_model.dart';

class DoctorMockData {
  static final List<DoctorModel> doctors = [
    DoctorModel(
      id:            '1',
      name:          'Dr. Sarah Mitchell',
      specialty:     'Senior Cardiologist',
      experience:    '12 years experience',
      rating:        4.9,
      patientCount:  '1.2k',
      reviewCount:   '120+',
      avatarBgColor: const Color(0xFF4A9E8E),
      consultationFee: 120.00,
      durationMins:  30,
      biography:
          'Dr. Sarah Mitchell is a board-certified cardiologist '
          'specializing in interventional cardiology and heart failure '
          'management. She has performed over 500 successful procedures '
          'and is known for her patient-centric approach to cardiovascular wellness.',
      education: [
        'MD – Harvard Medical School, 2008',
        'Residency – Johns Hopkins Hospital, 2011',
        'Fellowship – Mayo Clinic Cardiology, 2013',
        'Board Certified – American Board of Cardiology',
      ],
      reviews: [
        DoctorReview(
          reviewer: 'James T.',
          rating: 5.0,
          comment: 'Dr. Mitchell is absolutely wonderful. Very thorough and caring.',
          date: 'Oct 10, 2023',
        ),
        DoctorReview(
          reviewer: 'Priya S.',
          rating: 4.8,
          comment: 'Explained everything clearly. Highly recommended!',
          date: 'Sep 28, 2023',
        ),
        DoctorReview(
          reviewer: 'Mark R.',
          rating: 5.0,
          comment: 'Best cardiologist I have ever visited. Very professional.',
          date: 'Sep 15, 2023',
        ),
      ],
    ),
    DoctorModel(
      id:            '2',
      name:          'Dr. Elena Rodriguez',
      specialty:     'Neurologist',
      experience:    '9 years experience',
      rating:        4.9,
      patientCount:  '980',
      reviewCount:   '95+',
      avatarBgColor: const Color(0xFF4A9E8E),
      consultationFee: 140.00,
      durationMins:  45,
      biography:
          'Dr. Elena Rodriguez is a highly regarded neurologist with expertise '
          'in epilepsy, migraines, and neurodegenerative disorders. She uses '
          'advanced diagnostic tools to deliver precise and effective treatment plans.',
      education: [
        'MD – Stanford University School of Medicine, 2011',
        'Residency – UCSF Medical Center, 2014',
        'Fellowship – Cleveland Clinic Neurology, 2016',
      ],
      reviews: [
        DoctorReview(
          reviewer: 'Ana K.',
          rating: 5.0,
          comment: 'Dr. Rodriguez is incredibly knowledgeable and patient.',
          date: 'Oct 5, 2023',
        ),
        DoctorReview(
          reviewer: 'Tom B.',
          rating: 4.9,
          comment: 'She took the time to explain my diagnosis thoroughly.',
          date: 'Sep 20, 2023',
        ),
      ],
    ),
    DoctorModel(
      id:            '3',
      name:          'Dr. James Wilson',
      specialty:     'Dermatologist',
      experience:    '7 years experience',
      rating:        4.8,
      patientCount:  '850',
      reviewCount:   '80+',
      avatarBgColor: const Color(0xFFB0C4C0),
      consultationFee: 100.00,
      durationMins:  20,
      biography:
          'Dr. James Wilson is a board-certified dermatologist specializing '
          'in medical and cosmetic dermatology. He is known for his meticulous '
          'attention to detail and compassionate care for patients of all ages.',
      education: [
        'MD – University of Pennsylvania, 2013',
        'Residency – NYU Langone Health, 2016',
        'Board Certified – American Board of Dermatology',
      ],
      reviews: [
        DoctorReview(
          reviewer: 'Sarah M.',
          rating: 4.8,
          comment: 'Very professional and the treatment worked great!',
          date: 'Oct 12, 2023',
        ),
        DoctorReview(
          reviewer: 'Chris L.',
          rating: 4.7,
          comment: 'Friendly doctor, clean clinic. Would recommend.',
          date: 'Oct 1, 2023',
        ),
      ],
    ),
    DoctorModel(
      id:            '4',
      name:          'Dr. Priya Sharma',
      specialty:     'Pediatrician',
      experience:    '10 years experience',
      rating:        4.7,
      patientCount:  '1.5k',
      reviewCount:   '200+',
      avatarBgColor: const Color(0xFF7BA7A0),
      consultationFee: 90.00,
      durationMins:  25,
      biography:
          'Dr. Priya Sharma is a dedicated pediatrician with over a decade '
          'of experience caring for children from newborns to adolescents. '
          'She believes in building long-term relationships with families '
          'through trust, empathy, and evidence-based medicine.',
      education: [
        'MBBS – AIIMS New Delhi, 2010',
        'MD Pediatrics – PGI Chandigarh, 2013',
        'Fellowship – Boston Children\'s Hospital, 2015',
      ],
      reviews: [
        DoctorReview(
          reviewer: 'Neha P.',
          rating: 5.0,
          comment: 'My kids love Dr. Sharma. She is so gentle and kind.',
          date: 'Oct 8, 2023',
        ),
        DoctorReview(
          reviewer: 'David W.',
          rating: 4.6,
          comment: 'Very thorough with checkups. Highly recommend.',
          date: 'Sep 30, 2023',
        ),
      ],
    ),
  ];

  static DoctorModel getById(String id) {
    return doctors.firstWhere((d) => d.id == id);
  }
}