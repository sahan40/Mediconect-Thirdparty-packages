import 'package:flutter/material.dart';
import '../../core/navigation/navigation_extensions.dart';
import '../../core/app_transitions.dart';
import '../../core/app_routes.dart';
import 'doctor_directory_screen.dart';

enum AppointmentStatus { confirmed, pending, completed, cancelled }

class AppointmentModel {
  final String id;
  final String doctorName;
  final String specialty;
  final Color avatarBgColor;
  final DateTime dateTime;
  final AppointmentStatus status;

  const AppointmentModel({
    required this.id,
    required this.doctorName,
    required this.specialty,
    required this.avatarBgColor,
    required this.dateTime,
    required this.status,
  });
}

// ─────────────────────────────────────────────────────────────
// Mock data
// ─────────────────────────────────────────────────────────────

final _upcomingAppointments = [
  AppointmentModel(
    id: 'a1',
    doctorName: 'Dr. Sarah Jenkins',
    specialty: 'Cardiology Specialist',
    avatarBgColor: const Color(0xFF5B8A7A),
    dateTime: DateTime(2023, 10, 24, 10, 30),
    status: AppointmentStatus.confirmed,
  ),
  AppointmentModel(
    id: 'a2',
    doctorName: 'Dr. Michael Chen',
    specialty: 'General Physician',
    avatarBgColor: const Color(0xFF3D7EAA),
    dateTime: DateTime(2023, 11, 2, 14, 15),
    status: AppointmentStatus.pending,
  ),
];

final _pastAppointments = [
  AppointmentModel(
    id: 'a3',
    doctorName: 'Dr. Elena Rodriguez',
    specialty: 'Dermatologist',
    avatarBgColor: const Color(0xFF8B7BAB),
    dateTime: DateTime(2023, 9, 15, 9, 0),
    status: AppointmentStatus.completed,
  ),
  AppointmentModel(
    id: 'a4',
    doctorName: 'Dr. James Wilson',
    specialty: 'Orthopedist',
    avatarBgColor: const Color(0xFF4A6FA5),
    dateTime: DateTime(2023, 8, 28, 11, 45),
    status: AppointmentStatus.cancelled,
  ),
];

// ─────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────

class AppointmentsScreen extends StatefulWidget {
  final VoidCallback? onBackToDashboard;

  const AppointmentsScreen({super.key, this.onBackToDashboard});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _tabAnimController;
  late final Animation<double> _tabFadeAnim;
  late final Animation<Offset> _tabSlideAnim;

  // 0 = Upcoming, 1 = Past
  int _selectedTab = 0;
  int _displayTab = 0; // used to switch content after animation

  @override
  void initState() {
    super.initState();
    _tabAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _tabFadeAnim = CurvedAnimation(
      parent: _tabAnimController,
      curve: Curves.easeInOut,
    );
    _tabSlideAnim = Tween<Offset>(
      begin: const Offset(0.08, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _tabAnimController, curve: Curves.easeOutCubic),
    );
    _tabAnimController.forward();
  }

  @override
  void dispose() {
    _tabAnimController.dispose();
    super.dispose();
  }

  void _switchTab(int index) {
    if (index == _selectedTab) return;
    _tabAnimController.reverse().then((_) {
      setState(() {
        _selectedTab = index;
        _displayTab = index;
      });
      _tabAnimController.forward();
    });
  }

  void _goToDashboardHome() {
    if (widget.onBackToDashboard != null) {
      widget.onBackToDashboard!();
      return;
    }
    context.go('${AppRoutes.dashboard}?tab=0');
  }

  // ── Cancel dialog ────────────────────────────────────────
  void _showCancelDialog(AppointmentModel appt) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Cancel Appointment',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            content: Text(
              'Are you sure you want to cancel your appointment with '
              '${appt.doctorName}?',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  'Keep',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  'Cancel Appointment',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  // ── Reschedule dialog ────────────────────────────────────
  void _showRescheduleDialog(AppointmentModel appt) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Reschedule',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            content: Text(
              'Rescheduling with ${appt.doctorName}.\n'
              'Please choose a new date on the doctor\'s profile.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  'Close',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appointments =
        _displayTab == 0 ? _upcomingAppointments : _pastAppointments;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _goToDashboardHome();
      },
      child: Scaffold(
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
            onPressed: _goToDashboardHome,
          ),
          title: const Text(
            'My Appointments',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          centerTitle: true,
        ),

        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),

              // ── Toggle tabs ──────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _ToggleTabs(
                  selectedIndex: _selectedTab,
                  onToggle: _switchTab,
                ),
              ),
              const SizedBox(height: 20),

              // ── Appointment list ─────────────────────
              Expanded(
                child: FadeTransition(
                  opacity: _tabFadeAnim,
                  child: SlideTransition(
                    position: _tabSlideAnim,
                    child:
                        appointments.isEmpty
                            ? const _EmptyAppointments()
                            : ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: appointments.length + 1,
                              separatorBuilder:
                                  (_, __) => const SizedBox(height: 14),
                              itemBuilder: (_, i) {
                                if (i < appointments.length) {
                                  return _AppointmentCard(
                                    appointment: appointments[i],
                                    onCancel:
                                        () =>
                                            _showCancelDialog(appointments[i]),
                                    onReschedule:
                                        () => _showRescheduleDialog(
                                          appointments[i],
                                        ),
                                  );
                                }
                                // Book new promo at the end
                                return _displayTab == 0
                                    ? Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: _BookNewBanner(),
                                    )
                                    : const SizedBox.shrink();
                              },
                            ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Toggle Tabs — Upcoming / Past
// ─────────────────────────────────────────────────────────────

class _ToggleTabs extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onToggle;

  const _ToggleTabs({required this.selectedIndex, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2F7),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _ToggleTab(
            label: 'Upcoming',
            isSelected: selectedIndex == 0,
            onTap: () => onToggle(0),
          ),
          _ToggleTab(
            label: 'Past',
            isSelected: selectedIndex == 1,
            onTap: () => onToggle(1),
          ),
        ],
      ),
    );
  }
}

class _ToggleTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow:
                isSelected
                    ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                    : [],
          ),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 220),
              style: TextStyle(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.black87 : Colors.grey.shade500,
              ),
              child: Text(label),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Appointment Card
// ─────────────────────────────────────────────────────────────

class _AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  final VoidCallback onCancel;
  final VoidCallback onReschedule;

  const _AppointmentCard({
    required this.appointment,
    required this.onCancel,
    required this.onReschedule,
  });

  // ── Status badge config ──────────────────────────────────
  Color get _badgeBg {
    switch (appointment.status) {
      case AppointmentStatus.confirmed:
        return const Color(0xFFE8F5E9);
      case AppointmentStatus.pending:
        return const Color(0xFFFFF8E1);
      case AppointmentStatus.completed:
        return const Color(0xFFE3F4FB);
      case AppointmentStatus.cancelled:
        return const Color(0xFFFFEBEE);
    }
  }

  Color get _badgeText {
    switch (appointment.status) {
      case AppointmentStatus.confirmed:
        return const Color(0xFF2E9B56);
      case AppointmentStatus.pending:
        return const Color(0xFFF59E0B);
      case AppointmentStatus.completed:
        return const Color(0xFF1E9FD8);
      case AppointmentStatus.cancelled:
        return const Color(0xFFE53935);
    }
  }

  String get _badgeLabel {
    switch (appointment.status) {
      case AppointmentStatus.confirmed:
        return 'CONFIRMED';
      case AppointmentStatus.pending:
        return 'PENDING';
      case AppointmentStatus.completed:
        return 'COMPLETED';
      case AppointmentStatus.cancelled:
        return 'CANCELLED';
    }
  }

  String get _formattedDate {
    final d = appointment.dateTime;
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final month = months[d.month - 1];
    final day = d.day.toString().padLeft(2, '0');
    final hour =
        d.hour > 12
            ? d.hour - 12
            : d.hour == 0
            ? 12
            : d.hour;
    final min = d.minute.toString().padLeft(2, '0');
    final period = d.hour >= 12 ? 'PM' : 'AM';
    return '$month $day, ${d.year} at '
        '${hour.toString().padLeft(2, '0')}:$min $period';
  }

  bool get _isPast =>
      appointment.status == AppointmentStatus.completed ||
      appointment.status == AppointmentStatus.cancelled;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // ── Top: avatar + info + menu ────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 10, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: appointment.avatarBgColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: appointment.avatarBgColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(width: 12),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _badgeBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _badgeLabel,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: _badgeText,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Doctor name
                      Text(
                        appointment.doctorName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 3),

                      // Specialty
                      Text(
                        appointment.specialty,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),

                // 3-dot menu
                _ThreeDotMenu(
                  onReschedule: onReschedule,
                  onCancel: onCancel,
                  isPast: _isPast,
                ),
              ],
            ),
          ),

          // ── Date/time row ────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F5F8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    color: Color(0xFF1E9FD8),
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _formattedDate,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // ── Action buttons (only for upcoming) ───────
          if (!_isPast) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Row(
                children: [
                  // Reschedule
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: DecoratedBox(
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
                        child: ElevatedButton(
                          onPressed: onReschedule,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Reschedule',
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
                  const SizedBox(width: 12),

                  // Cancel
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: OutlinedButton(
                        onPressed: onCancel,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFFDDE3ED),
                            width: 1.5,
                          ),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            // For past: just a bottom padding
            const SizedBox(height: 4),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Three-dot menu
// ─────────────────────────────────────────────────────────────

class _ThreeDotMenu extends StatelessWidget {
  final VoidCallback onReschedule;
  final VoidCallback onCancel;
  final bool isPast;

  const _ThreeDotMenu({
    required this.onReschedule,
    required this.onCancel,
    required this.isPast,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert_rounded,
        color: Colors.grey.shade400,
        size: 22,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (v) {
        if (v == 'reschedule') onReschedule();
        if (v == 'cancel') onCancel();
      },
      itemBuilder:
          (_) => [
            if (!isPast) ...[
              PopupMenuItem(
                value: 'reschedule',
                child: Row(
                  children: const [
                    Icon(
                      Icons.event_repeat_rounded,
                      size: 18,
                      color: Color(0xFF1E9FD8),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Reschedule',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'cancel',
                child: Row(
                  children: const [
                    Icon(
                      Icons.cancel_outlined,
                      size: 18,
                      color: Color(0xFFE53935),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Cancel',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE53935),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              const PopupMenuItem(
                value: 'view',
                child: Row(
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 18,
                      color: Color(0xFF1E9FD8),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'View Details',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Book New Appointment Banner
// ─────────────────────────────────────────────────────────────

class _BookNewBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),

        // Icon circle
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: const Color(0xFFE3F4FB),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.task_alt_rounded,
            color: Color(0xFF1E9FD8),
            size: 34,
          ),
        ),
        const SizedBox(height: 16),

        const Text(
          'Need a checkup?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Schedule a new visit with your preferred specialist.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade500,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),

        // Book button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF29B6F6), Color(0xFF0288D1)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1E9FD8).withOpacity(0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(AppTransitions.swapRoute(const DoctorDirectoryScreen()));
              },
              icon: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 20,
              ),
              label: const Text(
                'Book New Appointment',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Empty State
// ─────────────────────────────────────────────────────────────

class _EmptyAppointments extends StatelessWidget {
  const _EmptyAppointments();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No appointments',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Book a visit with a specialist',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}
