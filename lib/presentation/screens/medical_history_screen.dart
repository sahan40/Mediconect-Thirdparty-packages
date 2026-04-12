import 'package:flutter/material.dart';
import '../../core/navigation/navigation_extensions.dart';
import '../../core/app_routes.dart';
import '../state/medical_history_provider.dart';
import '../state/medical_history_state.dart';
import '../../domain/models/medical_history_model.dart';

class MedicalHistoryScreen extends StatefulWidget {
  const MedicalHistoryScreen({super.key});

  @override
  State<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  final _surgeriesController = TextEditingController();

  static const List<String> _conditions = [
    'Diabetes',
    'Hypertension',
    'Asthma',
    'Arthritis',
    'Thyroid',
    'Heart Disease',
    'Kidney Disease',
    'Liver Disease',
    'Cancer',
    'Epilepsy',
    'Depression',
    'Anxiety',
    'Obesity',
    'Osteoporosis',
    'None',
  ];

  @override
  void dispose() {
    _surgeriesController.dispose();
    super.dispose();
  }

  void _showAddMedicationDialog(MedicalHistoryState state) {
    final nameCtrl = TextEditingController();
    final dosageCtrl = TextEditingController();
    final frequencyCtrl = TextEditingController();

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Add Medication',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _DialogField(controller: nameCtrl, hint: 'Medication name'),
                const SizedBox(height: 12),
                _DialogField(
                  controller: dosageCtrl,
                  hint: 'Dosage (e.g. 500mg)',
                ),
                const SizedBox(height: 12),
                _DialogField(
                  controller: frequencyCtrl,
                  hint: 'Frequency (e.g. Twice daily)',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E9FD8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (nameCtrl.text.trim().isNotEmpty) {
                    state.addMedication(
                      name: nameCtrl.text.trim(),
                      dosage: dosageCtrl.text.trim(),
                      frequency: frequencyCtrl.text.trim(),
                    );
                  }
                  Navigator.pop(ctx);
                },
                child: const Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Future<void> _handleNext(MedicalHistoryState state) async {
    FocusScope.of(context).unfocus();
    state.updatePastSurgeries(_surgeriesController.text);

    final ok = await state.submitStep();
    if (!mounted) return;

    if (ok) {
      context.go(AppRoutes.login);
    } else if (state.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    // FIX: now provider returns MedicalHistoryState directly
    final state = MedicalHistoryProvider.of(context);

    final selectedCount =
        state.form.chronicConditions.where((c) => c != 'None').length;

    return Scaffold(
      backgroundColor: Colors.white,

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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Medical History',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    const _StepProgress(
                      stepLabel: 'Registration Progress',
                      stepText: 'Step 2 of 2',
                      progress: 1.00,
                    ),
                    const SizedBox(height: 28),

                    const _SectionHeader(text: 'Chronic Conditions'),
                    const SizedBox(height: 4),
                    Text(
                      'Select all that apply to you.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Selected count badge
                    if (selectedCount > 0)
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                      ),

                    _ConditionChips(
                      conditions: _conditions,
                      onToggle: state.toggleCondition,
                    ),
                    const SizedBox(height: 32),

                    const _SectionHeader(
                      text: 'Past Surgeries or Hospitalizations',
                    ),
                    const SizedBox(height: 12),
                    _SurgeriesTextArea(controller: _surgeriesController),
                    const SizedBox(height: 32),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const _SectionHeader(text: 'Current Medications'),
                        GestureDetector(
                          onTap: () => _showAddMedicationDialog(state),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.add,
                                color: Color(0xFF1E9FD8),
                                size: 18,
                              ),
                              SizedBox(width: 2),
                              Text(
                                'Add New',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E9FD8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (state.form.medications.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'No medications added yet.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      )
                    else
                      ...state.form.medications.map(
                        (med) => _MedicationCard(
                          medication: med,
                          onDelete: () => state.removeMedication(med.id),
                        ),
                      ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            _BottomNavButtons(
              isLoading: state.isLoading,
              onPrevious: () => Navigator.of(context).pop(),
              onNext: () => _handleNext(state),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepProgress extends StatelessWidget {
  final String stepLabel;
  final String stepText;
  final double progress;

  const _StepProgress({
    required this.stepLabel,
    required this.stepText,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              stepLabel,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text(
              stepText,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1E9FD8)),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: Colors.black87,
        letterSpacing: -0.2,
      ),
    );
  }
}

class _ConditionChips extends StatelessWidget {
  final List<String> conditions;
  final void Function(String) onToggle;

  const _ConditionChips({required this.conditions, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children:
          conditions
              .map(
                (condition) =>
                    _ConditionChip(label: condition, onToggle: onToggle),
              )
              .toList(),
    );
  }
}

class _ConditionChip extends StatefulWidget {
  final String label;
  final void Function(String) onToggle;

  const _ConditionChip({required this.label, required this.onToggle});

  @override
  State<_ConditionChip> createState() => _ConditionChipState();
}

class _ConditionChipState extends State<_ConditionChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 100),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // FIX: toggle FIRST (instant UI update), then animate
  void _handleTap() {
    widget.onToggle(widget.label);

    _animController.forward().then((_) {
      if (mounted) _animController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = MedicalHistoryProvider.of(context);
    final selected = state.isConditionSelected(widget.label);

    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF1E9FD8) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  selected ? const Color(0xFF1E9FD8) : const Color(0xFFDDE3ED),
              width: 1.5,
            ),
            boxShadow:
                selected
                    ? [
                      BoxShadow(
                        color: const Color(0xFF1E9FD8).withOpacity(0.30),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                    : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeInOut,
                child:
                    selected
                        ? const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle_outline_outlined,
                              color: Colors.white,
                              size: 15,
                            ),
                            SizedBox(width: 5),
                          ],
                        )
                        : const SizedBox.shrink(),
              ),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 220),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? Colors.white : Colors.black87,
                ),
                child: Text(widget.label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SurgeriesTextArea extends StatelessWidget {
  final TextEditingController controller;
  const _SurgeriesTextArea({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDDE3ED), width: 1.5),
      ),
      child: TextField(
        controller: controller,
        maxLines: 5,
        keyboardType: TextInputType.multiline,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
        decoration: InputDecoration(
          hintText:
              'Please list any major surgeries or hospitalizations\n'
              'and the approximate dates...',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade400,
            height: 1.5,
          ),
          contentPadding: const EdgeInsets.all(16),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}

class _MedicationCard extends StatelessWidget {
  final MedicationItem medication;
  final VoidCallback onDelete;

  const _MedicationCard({required this.medication, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDDE3ED), width: 1.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medication.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  medication.subtitle,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: Icon(
              Icons.delete_outline_rounded,
              color: Colors.grey.shade400,
              size: 22,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

class _BottomNavButtons extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _BottomNavButtons({
    required this.isLoading,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: onPrevious,
              child: Container(
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200, width: 1.5),
                ),
                child: const Center(
                  child: Text(
                    'Previous',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: SizedBox(
              height: 54,
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
                child: ElevatedButton(
                  onPressed: isLoading ? null : onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    disabledBackgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child:
                      isLoading
                          ? const SizedBox(
                            width: 20,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                          : const Text(
                            'Finish',
                            style: TextStyle(
                              fontSize: 15,
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
    );
  }
}

class _DialogField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const _DialogField({required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 14, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        filled: true,
        fillColor: const Color(0xFFF7F9FC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFDDE3ED), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFDDE3ED), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF1E9FD8), width: 2),
        ),
      ),
    );
  }
}

class _PlaceholderInsuranceScreen extends StatelessWidget {
  const _PlaceholderInsuranceScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Insurance Details'),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Center(
        child: Text(
          'Insurance Details\n(Coming soon)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}
