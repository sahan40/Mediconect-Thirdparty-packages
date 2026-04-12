import 'package:flutter/material.dart';
import '../../core/navigation/navigation_extensions.dart';
import '../../core/app_routes.dart';
import '../state/signup_provider.dart';
import '../state/signup_state.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _fullNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _contactNameController = TextEditingController();
  final _relationshipController = TextEditingController();

  static const List<String> _bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _passwordController.dispose();
    _allergiesController.dispose();
    _contactNameController.dispose();
    _relationshipController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(SignupState state) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 25),
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF1E9FD8)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) state.updateDateOfBirth(picked);
  }

  Future<void> _handleNext(SignupState state) async {
    FocusScope.of(context).unfocus();
    state.updateFullName(_fullNameController.text);
    state.updatePassword(_passwordController.text);
    state.updateAllergies(_allergiesController.text);
    state.updateContactName(_contactNameController.text);
    state.updateRelationship(_relationshipController.text);

    final ok = await state.submitStep();
    if (ok && mounted) {
      context.push(AppRoutes.medicalHistory);
    }
  }

  @override
  Widget build(BuildContext context) {
    // FIX: SignupProvider.of(context) now returns SignupState directly
    final state = SignupProvider.of(context);

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
          'Patient Registration',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
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

                    _StepProgress(
                      stepLabel: 'Medical Profile',
                      stepText: 'Step 1 of 2',
                      progress: 0.5,
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      "Let's build your profile",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your information is encrypted and stored\n'
                      'securely following HIPAA standards.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),

                    if (state.status == SignupStatus.error &&
                        state.errorMessage != null) ...[
                      _ErrorBanner(
                        message: state.errorMessage!,
                        onDismiss: state.clearError,
                      ),
                      const SizedBox(height: 16),
                    ],

                    _FieldLabel(text: 'Full Name'),
                    const SizedBox(height: 8),
                    _InputField(
                      controller: _fullNameController,
                      hintText: 'e.g. Johnathan Doe',
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 20),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date of Birth
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _FieldLabel(text: 'Date of Birth'),
                              const SizedBox(height: 8),
                              _DatePickerField(
                                selectedDate: state.form.dateOfBirth,
                                onTap: () => _pickDate(state),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Blood Type
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _FieldLabel(text: 'Blood Type'),
                              const SizedBox(height: 8),
                              _BloodTypeDropdown(
                                value: state.form.bloodType,
                                items: _bloodTypes,
                                onChanged: state.updateBloodType,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    _FieldLabel(text: 'Password'),
                    const SizedBox(height: 8),
                    _InputField(
                      controller: _passwordController,
                      hintText: 'Enter password',
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),

                    _FieldLabel(text: 'Known Allergies'),
                    const SizedBox(height: 8),
                    _TextAreaField(
                      controller: _allergiesController,
                      hintText: "e.g. Penicillin, Peanuts (or 'None')",
                    ),
                    const SizedBox(height: 32),

                    // ── Emergency Contact section ─────────────
                    const Text(
                      'Emergency Contact',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Contact Name ──────────────────────────
                    _FieldLabel(text: 'Contact Name'),
                    const SizedBox(height: 8),
                    _InputField(
                      controller: _contactNameController,
                      hintText: "Emergency contact's name",
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 20),

                    // ── Relationship ──────────────────────────
                    _FieldLabel(text: 'Relationship'),
                    const SizedBox(height: 8),
                    _InputField(
                      controller: _relationshipController,
                      hintText: 'e.g. Spouse, Parent',
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 24),

                    // ── Security banner ───────────────────────
                    const _SecurityBanner(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ── Bottom button ──────────────────────────────
            _BottomNextButton(
              isLoading: state.isLoading,
              onPressed: () => _handleNext(state),
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
  final double progress; // 0.0 to 1.0

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
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
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

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }
}

BoxDecoration _fieldDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: const Color(0xFFDDE3ED), width: 1.5),
  );
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;

  const _InputField({
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _fieldDecoration(),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: const TextStyle(fontSize: 15, color: Colors.black87),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 15, color: Colors.grey.shade400),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}

class _DatePickerField extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onTap;

  const _DatePickerField({required this.selectedDate, required this.onTap});

  String get _displayText {
    if (selectedDate == null) return 'mm/dd/yyyy';
    return '${selectedDate!.month.toString().padLeft(2, '0')}/'
        '${selectedDate!.day.toString().padLeft(2, '0')}/'
        '${selectedDate!.year}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: _fieldDecoration(),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _displayText,
                style: TextStyle(
                  fontSize: 15,
                  color:
                      selectedDate == null
                          ? Colors.grey.shade400
                          : Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: Colors.grey.shade500,
            ),
          ],
        ),
      ),
    );
  }
}

class _BloodTypeDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final void Function(String) onChanged;

  const _BloodTypeDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _fieldDecoration(),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.grey.shade600,
          ),
          style: const TextStyle(fontSize: 15, color: Colors.black87),
          items:
              items
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

class _TextAreaField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const _TextAreaField({required this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _fieldDecoration(),
      child: TextField(
        controller: controller,
        maxLines: 4,
        keyboardType: TextInputType.multiline,
        style: const TextStyle(fontSize: 15, color: Colors.black87),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}

class _SecurityBanner extends StatelessWidget {
  const _SecurityBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF6FD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBBDEF0), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.verified_user_rounded,
            color: Color(0xFF1E9FD8),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Your data is safe with us. We use AES-256 bit encryption '
              'to ensure your medical history remains private and secure.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.blueGrey.shade700,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNextButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _BottomNextButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: SizedBox(
        width: double.infinity,
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
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
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
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                    : const Text(
                      'Next: Medical History',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
          ),
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback onDismiss;

  const _ErrorBanner({required this.message, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFFCCCC)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFE53E3E), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 13, color: Color(0xFFE53E3E)),
            ),
          ),
          GestureDetector(
            onTap: onDismiss,
            child: const Icon(Icons.close, color: Color(0xFFE53E3E), size: 16),
          ),
        ],
      ),
    );
  }
}
