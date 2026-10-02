import 'package:flutter/material.dart';

void main() {
  runApp(const StudentProfileApp());
}

// Palette
const _teal = Color(0xFF0E5A5A);
const _tealDark = Color(0xFF0A4141);
const _marigold = Color(0xFFF2B632);
const _ink = Color(0xFF16222B);
const _paper = Color(0xFFF1F4F3);

class StudentProfileApp extends StatelessWidget {
  const StudentProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color, width: width),
        );

    return MaterialApp(
      title: 'Student Profile Form',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _teal,
          primary: _teal,
          secondary: _marigold,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: _paper,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          border: border(const Color(0xFFCBD5D3)),
          enabledBorder: border(const Color(0xFFCBD5D3)),
          focusedBorder: border(_teal, 2),
          errorBorder: border(const Color(0xFFB3261E)),
          focusedErrorBorder: border(const Color(0xFFB3261E), 2),
          prefixIconColor: _teal,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: _teal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: _teal,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: _ink,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      home: const StudentProfileForm(),
    );
  }
}

class StudentProfileForm extends StatefulWidget {
  const StudentProfileForm({super.key});

  @override
  State<StudentProfileForm> createState() => _StudentProfileFormState();
}

class _StudentProfileFormState extends State<StudentProfileForm> {
  // Key used to validate and save the form
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();

  // Gender selection
  String? _selectedGender;
  final List<String> _genderOptions = ['Male', 'Female', 'Other'];

  // Holds the submitted data so it can be displayed on screen
  Map<String, String>? _submittedData;

  @override
  void dispose() {
    // Clean up controllers when the widget is removed
    _nameController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // Validate all fields; validators return null when a field is valid
    if (_formKey.currentState!.validate()) {
      if (_selectedGender == null) {
        // Gender uses a separate check since it's not a TextFormField
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a gender.')),
        );
        return;
      }

      setState(() {
        _submittedData = {
          'Full Name': _nameController.text.trim(),
          'Age': _ageController.text.trim(),
          'Gender': _selectedGender!,
          'Address': _addressController.text.trim(),
          'Contact Number': _contactController.text.trim(),
          'Email': _emailController.text.trim(),
        };
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile submitted successfully!')),
      );
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _nameController.clear();
    _ageController.clear();
    _addressController.clear();
    _contactController.clear();
    _emailController.clear();
    setState(() {
      _selectedGender = null;
      _submittedData = null;
    });
  }

  String? _requiredValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? _ageValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Age is required';
    }
    final age = int.tryParse(value.trim());
    if (age == null) {
      return 'Enter a valid number';
    }
    if (age <= 0 || age > 120) {
      return 'Enter a realistic age';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w\.\-]+@[\w\-]+\.[\w\-\.]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _contactValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Contact number is required';
    }
    final digitsOnly = value.trim().replaceAll(RegExp(r'[\s\-]'), '');
    final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
    if (!phoneRegex.hasMatch(digitsOnly)) {
      return 'Enter a valid contact number';
    }
    return null;
  }

  // Small helper: a section title with a marigold marker
  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: _marigold,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: _ink,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDCE4E2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 56, 24, 40),
      decoration: const BoxDecoration(
        color: _tealDark,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: _marigold,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.badge_outlined, color: _ink, size: 28),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Student profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Fill in your details to create your profile card.',
                      style: TextStyle(color: Color(0xFFBFD6D4), fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _genderField() {
    return FormField<String>(
      initialValue: null,
      validator: (value) => value == null ? 'Please select a gender' : null,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 2, bottom: 8),
              child: Text(
                'Gender',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _ink,
                ),
              ),
            ),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: _genderOptions.map((gender) {
                final selected = state.value == gender;
                return ChoiceChip(
                  label: Text(gender),
                  selected: selected,
                  showCheckmark: false,
                  avatar: selected
                      ? const Icon(Icons.check, size: 18, color: Colors.white)
                      : null,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : _ink,
                  ),
                  selectedColor: _teal,
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: selected ? _teal : const Color(0xFFCBD5D3),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  onSelected: (_) {
                    state.didChange(gender);
                    setState(() => _selectedGender = gender);
                  },
                );
              }).toList(),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 2, top: 6),
                child: Text(
                  state.errorText!,
                  style: const TextStyle(
                    color: Color(0xFFB3261E),
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  String _initials(String name) {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  Widget _profileCard(Map<String, String> data) {
    const rows = <(String, IconData)>[
      ('Age', Icons.cake_outlined),
      ('Gender', Icons.wc),
      ('Address', Icons.home_outlined),
      ('Contact Number', Icons.phone_outlined),
      ('Email', Icons.email_outlined),
    ];

    return Container(
      decoration: BoxDecoration(
        color: _ink,
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Marigold stripe, like the band on a school ID
          Container(height: 8, color: _marigold),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: _marigold,
                      child: Text(
                        _initials(data['Full Name']!),
                        style: const TextStyle(
                          color: _ink,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['Full Name']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Submitted profile',
                            style: TextStyle(
                              color: Color(0xFF9FB3B1),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Divider(color: Color(0xFF2C3B45), height: 1),
                const SizedBox(height: 10),
                ...rows.map(
                  (row) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(row.$2, size: 20, color: _marigold),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                row.$1,
                                style: const TextStyle(
                                  color: Color(0xFF9FB3B1),
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                data[row.$1]!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _header(),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _sectionCard(
                          children: [
                            _sectionTitle('About you'),
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Full Name',
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              validator: (value) =>
                                  _requiredValidator(value, 'Full Name'),
                              textCapitalization: TextCapitalization.words,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _ageController,
                              decoration: const InputDecoration(
                                labelText: 'Age',
                                prefixIcon: Icon(Icons.cake_outlined),
                              ),
                              keyboardType: TextInputType.number,
                              validator: _ageValidator,
                            ),
                            const SizedBox(height: 18),
                            _genderField(),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _sectionCard(
                          children: [
                            _sectionTitle('How to reach you'),
                            TextFormField(
                              controller: _addressController,
                              decoration: const InputDecoration(
                                labelText: 'Address',
                                prefixIcon: Icon(Icons.home_outlined),
                              ),
                              maxLines: 2,
                              validator: (value) =>
                                  _requiredValidator(value, 'Address'),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _contactController,
                              decoration: const InputDecoration(
                                labelText: 'Contact Number',
                                prefixIcon: Icon(Icons.phone_outlined),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: _contactValidator,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: _emailValidator,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: FilledButton.icon(
                                onPressed: _submitForm,
                                icon: const Icon(Icons.check),
                                label: const Text('Submit'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: TextButton.icon(
                                onPressed: _resetForm,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Clear'),
                              ),
                            ),
                          ],
                        ),

                        // Display submitted data
                        if (_submittedData != null) ...[
                          const SizedBox(height: 28),
                          _profileCard(_submittedData!),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
