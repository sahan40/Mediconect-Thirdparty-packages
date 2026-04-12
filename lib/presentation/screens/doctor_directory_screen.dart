import 'package:flutter/material.dart';
import '../../core/navigation/navigation_extensions.dart';
import '../../domain/models/doctor_model.dart';
import '../../core/app_transitions.dart';
import '../../core/app_routes.dart';
import 'doctor_profile_screen.dart';

class DoctorDirectoryScreen extends StatefulWidget {
  final int? backDashboardIndex;

  const DoctorDirectoryScreen({super.key, this.backDashboardIndex});

  @override
  State<DoctorDirectoryScreen> createState() => _DoctorDirectoryScreenState();
}

class _DoctorDirectoryScreenState extends State<DoctorDirectoryScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';

  void _handleBackPressed() {
    if (widget.backDashboardIndex != null) {
      context.go('${AppRoutes.dashboard}?tab=${widget.backDashboardIndex!}');
      return;
    }

    Navigator.of(context).maybePop();
  }

  // Extended doctor list for the directory
  final List<DoctorModel> _allDoctors = [
    DoctorModel(
      id: 'd1',
      name: 'Dr. Sarah Jenkins',
      specialty: 'Cardiologist',
      experience: '12 years exp',
      rating: 4.9,
      patientCount: '1.2k',
      reviewCount: '120',
      avatarBgColor: const Color(0xFF4A9E8E),
      consultationFee: 120.00,
      durationMins: 30,
      biography:
          'Dr. Sarah Jenkins is a board-certified cardiologist '
          'specializing in interventional cardiology and heart failure '
          'management. Known for her patient-centric approach.',
      education: [
        'MD – Harvard Medical School, 2008',
        'Residency – Johns Hopkins Hospital, 2011',
        'Fellowship – Mayo Clinic Cardiology, 2013',
      ],
      reviews: [
        DoctorReview(
          reviewer: 'James T.',
          rating: 5.0,
          comment: 'Wonderful doctor. Very thorough and caring.',
          date: 'Oct 10, 2023',
        ),
      ],
    ),
    DoctorModel(
      id: 'd2',
      name: 'Dr. Michael Chen',
      specialty: 'Pediatrician',
      experience: '8 years exp',
      rating: 4.7,
      patientCount: '900',
      reviewCount: '85',
      avatarBgColor: const Color(0xFF3D7EAA),
      consultationFee: 90.00,
      durationMins: 25,
      biography:
          'Dr. Michael Chen is a dedicated pediatrician with 8 years '
          'of experience caring for children from newborns to adolescents.',
      education: [
        'MD – Stanford University, 2012',
        'Residency – UCSF Benioff Children\'s Hospital, 2015',
      ],
      reviews: [
        DoctorReview(
          reviewer: 'Neha P.',
          rating: 5.0,
          comment: 'My kids love Dr. Chen. Very gentle and kind.',
          date: 'Oct 8, 2023',
        ),
      ],
    ),
    DoctorModel(
      id: 'd3',
      name: 'Dr. Elena Rodriguez',
      specialty: 'Dermatologist',
      experience: '15 years exp',
      rating: 4.8,
      patientCount: '1.5k',
      reviewCount: '142',
      avatarBgColor: const Color(0xFF8B7BAB),
      consultationFee: 110.00,
      durationMins: 20,
      biography:
          'Dr. Elena Rodriguez is a board-certified dermatologist '
          'specializing in medical and cosmetic dermatology with '
          '15 years of clinical experience.',
      education: [
        'MD – Columbia University, 2006',
        'Residency – NYU Langone Health, 2009',
        'Board Certified – American Board of Dermatology',
      ],
      reviews: [
        DoctorReview(
          reviewer: 'Ana K.',
          rating: 5.0,
          comment: 'Very knowledgeable and professional.',
          date: 'Oct 5, 2023',
        ),
      ],
    ),
    DoctorModel(
      id: 'd4',
      name: 'Dr. James Wilson',
      specialty: 'Orthopedist',
      experience: '10 years exp',
      rating: 4.6,
      patientCount: '1.1k',
      reviewCount: '98',
      avatarBgColor: const Color(0xFF5B8A7A),
      consultationFee: 130.00,
      durationMins: 40,
      biography:
          'Dr. James Wilson is an experienced orthopedic surgeon '
          'specializing in sports injuries, joint replacement, '
          'and minimally invasive procedures.',
      education: [
        'MD – University of Pennsylvania, 2010',
        'Residency – Hospital for Special Surgery, 2013',
        'Fellowship – Sports Medicine, 2015',
      ],
      reviews: [
        DoctorReview(
          reviewer: 'Chris L.',
          rating: 4.6,
          comment: 'Very professional. Recovery was smooth.',
          date: 'Oct 1, 2023',
        ),
      ],
    ),
    DoctorModel(
      id: 'd5',
      name: 'Dr. Priya Sharma',
      specialty: 'Neurologist',
      experience: '11 years exp',
      rating: 4.9,
      patientCount: '980',
      reviewCount: '110',
      avatarBgColor: const Color(0xFF7BA7A0),
      consultationFee: 150.00,
      durationMins: 45,
      biography:
          'Dr. Priya Sharma is a highly regarded neurologist '
          'specializing in epilepsy, migraines, and neurodegenerative disorders.',
      education: [
        'MBBS – AIIMS New Delhi, 2009',
        'MD Neurology – PGI Chandigarh, 2012',
        'Fellowship – Cleveland Clinic, 2014',
      ],
      reviews: [
        DoctorReview(
          reviewer: 'David W.',
          rating: 4.9,
          comment: 'Excellent doctor. Very thorough diagnosis.',
          date: 'Sep 30, 2023',
        ),
      ],
    ),
    DoctorModel(
      id: 'd6',
      name: 'Dr. Robert Kim',
      specialty: 'Cardiology',
      experience: '14 years exp',
      rating: 4.7,
      patientCount: '1.3k',
      reviewCount: '130',
      avatarBgColor: const Color(0xFF4A6FA5),
      consultationFee: 140.00,
      durationMins: 35,
      biography:
          'Dr. Robert Kim is a senior cardiologist with expertise '
          'in preventive cardiology and advanced cardiac imaging.',
      education: [
        'MD – Johns Hopkins University, 2007',
        'Residency – Massachusetts General Hospital, 2010',
        'Board Certified – American College of Cardiology',
      ],
      reviews: [
        DoctorReview(
          reviewer: 'Mike R.',
          rating: 4.7,
          comment: 'Explains complex conditions clearly.',
          date: 'Sep 22, 2023',
        ),
      ],
    ),
  ];

  static const List<String> _filterOptions = [
    'All',
    'Cardiology',
    'Pediatrics',
    'Dermatology',
    'Neurology',
    'Orthopedics',
  ];

  List<DoctorModel> get _filteredDoctors {
    return _allDoctors.where((doc) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          doc.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          doc.specialty.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesFilter =
          _selectedFilter == 'All' ||
          doc.specialty.toLowerCase().contains(_selectedFilter.toLowerCase());

      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredDoctors;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F8),

      // ── AppBar ───────────────────────────────────────
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: _handleBackPressed,
        ),
        title: const Text(
          'Doctor Directory',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_outlined,
              color: Colors.black87,
              size: 24,
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            // ── Search + filters (sticky) ──────────────
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                children: [
                  // Search bar
                  _SearchBar(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _searchQuery = v),
                  ),
                  const SizedBox(height: 14),

                  // Filter chips
                  _FilterChips(
                    options: _filterOptions,
                    selectedOption: _selectedFilter,
                    onSelected: (v) => setState(() => _selectedFilter = v),
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),

            // ── Doctor list ────────────────────────────
            Expanded(
              child:
                  filtered.isEmpty
                      ? _EmptyState(query: _searchQuery)
                      : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder:
                            (_, i) => _DoctorListCard(doctor: filtered[i]),
                      ),
            ),
          ],
        ),
      ),

      // ── Bottom Nav ────────────────────────────────
      //bottomNavigationBar: const _DirectoryBottomNav(activeIndex: 1),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onChanged;

  const _SearchBar({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 15, color: Colors.black87),
        decoration: InputDecoration(
          hintText: 'Search doctor name or specialty',
          hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Colors.grey.shade400,
            size: 22,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  final List<String> options;
  final String selectedOption;
  final void Function(String) onSelected;

  const _FilterChips({
    required this.options,
    required this.selectedOption,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final option = options[i];
          final isSelected = option == selectedOption;

          return GestureDetector(
            onTap: () => onSelected(option),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1E9FD8) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      isSelected
                          ? const Color(0xFF1E9FD8)
                          : const Color(0xFFDDE3ED),
                  width: 1.5,
                ),
                boxShadow:
                    isSelected
                        ? [
                          BoxShadow(
                            color: const Color(0xFF1E9FD8).withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                        : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    option,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                  // Dropdown arrow for non-All options
                  if (option != 'All') ...[
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: isSelected ? Colors.white : Colors.black54,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DoctorListCard extends StatelessWidget {
  final DoctorModel doctor;

  const _DoctorListCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Top row: avatar + info + arrow ──────────
          Row(
            children: [
              // Circular avatar
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: doctor.avatarBgColor,
                  boxShadow: [
                    BoxShadow(
                      color: doctor.avatarBgColor.withOpacity(0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 38),
              ),
              const SizedBox(width: 14),

              // Name + rating + specialty
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFFFB300),
                          size: 16,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${doctor.rating}'
                          ' (${doctor.reviewCount} reviews)',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${doctor.specialty} · ${doctor.experience}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F9FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF1E9FD8),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Divider ──────────────────────────────────
          const Divider(color: Color(0xFFEEF2F7), height: 1, thickness: 1),
          const SizedBox(height: 14),

          // ── Action buttons ────────────────────────────
          Row(
            children: [
              // View Profile
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      AppTransitions.swapRoute(
                        DoctorProfileScreen(doctor: doctor),
                      ),
                    );
                  },
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5FD),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'View Profile',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E9FD8),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Book Now
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      AppTransitions.swapRoute(
                        DoctorProfileScreen(doctor: doctor),
                      ),
                    );
                  },
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF29B6F6), Color(0xFF0288D1)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1E9FD8).withOpacity(0.30),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Book Now',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String query;
  const _EmptyState({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            query.isEmpty ? 'No doctors available' : 'No results for "$query"',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different name or specialty',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}
