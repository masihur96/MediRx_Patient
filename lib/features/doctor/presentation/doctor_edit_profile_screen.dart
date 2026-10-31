import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_snackbar.dart';
import '../data/doctor_models.dart';
import 'viewmodels/doctor_profile_viewmodel.dart';

class DoctorEditProfileScreen extends StatefulWidget {
  final DoctorProfile profile;
  final String doctorId;

  const DoctorEditProfileScreen({
    super.key,
    required this.profile,
    required this.doctorId,
  });

  @override
  State<DoctorEditProfileScreen> createState() => _DoctorEditProfileScreenState();
}

class _DoctorEditProfileScreenState extends State<DoctorEditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _phoneController;
  late TextEditingController _specializationController;
  late TextEditingController _instituteController;
  late TextEditingController _designationController;
  late TextEditingController _qualificationController;
  late TextEditingController _regNoController;
  late TextEditingController _expYearsController;
  late TextEditingController _bioController;
  late TextEditingController _facebookController;
  late TextEditingController _linkedinController;
  late TextEditingController _twitterController;

  String _gender = 'male';
  String _dob = '1985-05-15';
  bool _active = true;
  bool _featured = false;

  final Set<String> _selectedSpecialtyIds = {'50', '48'};

  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final p = widget.profile;

    _phoneController = TextEditingController(
      text: p.phone.isNotEmpty ? p.phone : '01714774003',
    );
    _specializationController = TextEditingController(
      text: p.specialization.isNotEmpty ? p.specialization : 'Cardiology',
    );
    _instituteController = TextEditingController(
      text: p.hospital.isNotEmpty ? p.hospital : 'Dhaka Medical College Hospital',
    );
    _designationController = TextEditingController(
      text: p.designation.isNotEmpty ? p.designation : 'Consultant Cardiologist',
    );
    _qualificationController = TextEditingController(
      text: p.qualification.isNotEmpty
          ? p.qualification
          : 'MBBS, FCPS (Medicine), MD (Cardiology)',
    );
    _regNoController = TextEditingController(
      text: p.regNo.isNotEmpty ? p.regNo : 'A-12345',
    );
    _expYearsController = TextEditingController(
      text: (p.experienceYears ?? 10).toString(),
    );
    _bioController = TextEditingController(
      text: p.bio.isNotEmpty
          ? p.bio
          : 'Experienced cardiologist specializing in cardiovascular diseases.',
    );
    _facebookController = TextEditingController(
      text: p.social?.facebook ?? 'https://facebook.com/doctor',
    );
    _linkedinController = TextEditingController(
      text: p.social?.linkedin ?? 'https://linkedin.com/in/doctor',
    );
    _twitterController = TextEditingController(
      text: p.social?.twitter ?? 'https://twitter.com/doctor',
    );

    if (p.gender != null && p.gender!.trim().isNotEmpty) {
      final g = p.gender!.trim().toLowerCase();
      if (['male', 'female', 'other'].contains(g)) {
        _gender = g;
      }
    }

    if (p.dob != null && p.dob!.trim().isNotEmpty) {
      _dob = p.dob!.trim();
    }

    _active = p.isActive ?? true;
    _featured = p.featured ?? false;

    // Fetch specialties from API in background
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DoctorProfileViewModel>().fetchSpecialties();
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _specializationController.dispose();
    _instituteController.dispose();
    _designationController.dispose();
    _qualificationController.dispose();
    _regNoController.dispose();
    _expYearsController.dispose();
    _bioController.dispose();
    _facebookController.dispose();
    _linkedinController.dispose();
    _twitterController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (picked != null) {
        setState(() {
          _selectedImage = File(picked.path);
        });
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.showError(context, message: 'Could not select image: $e');
      }
    }
  }

  void _showImagePickerSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(LucideIcons.camera, color: AppColors.primaryTeal),
              title: const Text('Take Photo from Camera'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.image, color: AppColors.primaryTeal),
              title: const Text('Select from Gallery'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime initial = DateTime.tryParse(_dob) ?? DateTime(1985, 5, 15);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryTeal,
              onPrimary: Colors.white,
              onSurface: AppColors.textDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dob =
            "${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      AppSnackBar.showError(context, message: 'Please fix validation errors');
      return;
    }

    if (_selectedSpecialtyIds.isEmpty) {
      AppSnackBar.showError(
        context,
        message: 'Please select at least one medical specialty',
      );
      return;
    }

    final data = <String, dynamic>{
      'phone': _phoneController.text.trim(),
      'gender': _gender,
      'dob': _dob,
      'specialization': _specializationController.text.trim(),
      'working_institute': _instituteController.text.trim(),
      'designation': _designationController.text.trim(),
      'qualification': _qualificationController.text.trim(),
      'registration_no': _regNoController.text.trim(),
      'experience_years': _expYearsController.text.trim(),
      'bio': _bioController.text.trim(),
      'specialization_ids': _selectedSpecialtyIds.toList(),
      'social': {
        'facebook': _facebookController.text.trim(),
        'linkedin': _linkedinController.text.trim(),
        'twitter': _twitterController.text.trim(),
      },
      'active': _active ? '1' : '0',
      'featured': _featured ? '1' : '0',
      if (_selectedImage != null) 'profile_image': _selectedImage!.path,
    };

    final viewModel = context.read<DoctorProfileViewModel>();
    final success = await viewModel.updateDoctorProfile(
      doctorId: widget.doctorId,
      data: data,
      imagePath: _selectedImage?.path,
    );

    if (!mounted) return;

    if (success) {
      AppSnackBar.showSuccess(
        context,
        message: 'Doctor profile updated successfully!',
      );
      Navigator.pop(context, true);
    } else {
      AppSnackBar.showError(
        context,
        message: viewModel.updateErrorMessage ?? 'Failed to update profile',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DoctorProfileViewModel>();
    final isUpdating = viewModel.isUpdating;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Edit Professional Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            children: [
              // Avatar edit section
              _buildAvatarSection(),
              const SizedBox(height: 24),

              // Basic Personal Info
              _buildSectionCard(
                title: 'Basic Information',
                icon: LucideIcons.user,
                children: [
                  _buildTextField(
                    controller: _phoneController,
                    label: 'Phone Number',
                    hint: '01714774003',
                    icon: LucideIcons.phone,
                    keyboardType: TextInputType.phone,
                    validator: (val) =>
                        val == null || val.trim().isEmpty ? 'Phone is required' : null,
                  ),
                  const SizedBox(height: 14),

                  // Gender Selection
                  const Text(
                    'Gender',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _genderChip('male', 'Male', LucideIcons.user),
                      const SizedBox(width: 8),
                      _genderChip('female', 'Female', LucideIcons.userCheck),
                      const SizedBox(width: 8),
                      _genderChip('other', 'Other', LucideIcons.userPlus),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Date of Birth
                  const Text(
                    'Date of Birth',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  InkWell(
                    onTap: _selectDate,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.withValues(alpha: 0.25)),
                      ),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.calendar,
                              size: 18, color: AppColors.primaryTeal),
                          const SizedBox(width: 10),
                          Text(
                            _dob.isNotEmpty ? _dob : 'Select Date of Birth',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const Spacer(),
                          const Icon(LucideIcons.chevronDown, size: 16, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Professional Credentials
              _buildSectionCard(
                title: 'Professional Qualifications',
                icon: LucideIcons.stethoscope,
                children: [
                  _buildTextField(
                    controller: _regNoController,
                    label: 'BMDC Registration No.',
                    hint: 'A-12345',
                    icon: LucideIcons.fileBadge,
                    validator: (val) =>
                        val == null || val.trim().isEmpty ? 'Registration No. is required' : null,
                  ),
                  const SizedBox(height: 14),
                  _buildTextField(
                    controller: _specializationController,
                    label: 'Primary Specialization',
                    hint: 'Cardiology',
                    icon: LucideIcons.activity,
                    validator: (val) =>
                        val == null || val.trim().isEmpty ? 'Specialization is required' : null,
                  ),
                  const SizedBox(height: 14),
                  _buildTextField(
                    controller: _designationController,
                    label: 'Professional Designation',
                    hint: 'Consultant Cardiologist',
                    icon: LucideIcons.briefcase,
                    validator: (val) =>
                        val == null || val.trim().isEmpty ? 'Designation is required' : null,
                  ),
                  const SizedBox(height: 14),
                  _buildTextField(
                    controller: _instituteController,
                    label: 'Working Institute / Hospital',
                    hint: 'Dhaka Medical College Hospital',
                    icon: LucideIcons.building2,
                    validator: (val) => val == null || val.trim().isEmpty
                        ? 'Working Institute is required'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  _buildTextField(
                    controller: _qualificationController,
                    label: 'Academic Qualifications',
                    hint: 'MBBS, FCPS (Medicine), MD (Cardiology)',
                    icon: LucideIcons.award,
                    validator: (val) =>
                        val == null || val.trim().isEmpty ? 'Qualification is required' : null,
                  ),
                  const SizedBox(height: 14),
                  _buildTextField(
                    controller: _expYearsController,
                    label: 'Clinical Experience (Years)',
                    hint: '10',
                    icon: LucideIcons.clock,
                    keyboardType: TextInputType.number,
                    validator: (val) =>
                        val == null || val.trim().isEmpty ? 'Experience is required' : null,
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Medical Specialties Selection
              _buildSpecialtiesCard(viewModel),
              const SizedBox(height: 18),

              // Professional Biography
              _buildSectionCard(
                title: 'Professional Biography',
                icon: LucideIcons.fileText,
                children: [
                  _buildTextField(
                    controller: _bioController,
                    label: 'About You (Doctor Bio)',
                    hint: 'Detailed summary of your clinical experience and focus areas...',
                    icon: LucideIcons.alignLeft,
                    maxLines: 4,
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Social Profiles
              _buildSectionCard(
                title: 'Social & Public Links',
                icon: LucideIcons.globe,
                children: [
                  _buildTextField(
                    controller: _facebookController,
                    label: 'Facebook Profile URL',
                    hint: 'https://facebook.com/doctor',
                    icon: LucideIcons.globe,
                  ),
                  const SizedBox(height: 14),
                  _buildTextField(
                    controller: _linkedinController,
                    label: 'LinkedIn Profile URL',
                    hint: 'https://linkedin.com/in/doctor',
                    icon: LucideIcons.link,
                  ),
                  const SizedBox(height: 14),
                  _buildTextField(
                    controller: _twitterController,
                    label: 'Twitter / X URL',
                    hint: 'https://twitter.com/doctor',
                    icon: LucideIcons.atSign,
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Status & Visibility
              _buildSectionCard(
                title: 'Account Status & Visibility',
                icon: LucideIcons.settings,
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeThumbColor: AppColors.primaryTeal,
                    title: const Text('Active Practitioner',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: const Text('Allow patients to discover and consult with you',
                        style: TextStyle(fontSize: 12)),
                    value: _active,
                    onChanged: (val) => setState(() => _active = val),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeThumbColor: AppColors.primaryTeal,
                    title: const Text('Featured Profile',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: const Text('Highlight profile on doctor directory',
                        style: TextStyle(fontSize: 12)),
                    value: _featured,
                    onChanged: (val) => setState(() => _featured = val),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isUpdating ? null : _submitForm,
                  icon: isUpdating
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(LucideIcons.save, color: Colors.white, size: 18),
                  label: Text(
                    isUpdating ? 'Saving Profile...' : 'Save & Update Profile',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryTeal,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Avatar Section ────────────────────────────────────────────────────────

  Widget _buildAvatarSection() {
    final hasLocal = _selectedImage != null;
    final rawNetwork = widget.profile.profileImage;
    final hasNetwork = rawNetwork != null && rawNetwork.isNotEmpty;
    final resolvedNetwork = hasNetwork
        ? (rawNetwork.startsWith('http')
            ? rawNetwork
            : (rawNetwork.startsWith('/')
                ? 'https://medirx.unipexel.org$rawNetwork'
                : 'https://medirx.unipexel.org/$rawNetwork'))
        : null;

    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primaryTeal.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 54,
                  backgroundColor: AppColors.primaryTeal.withValues(alpha: 0.1),
                  backgroundImage: hasLocal
                      ? FileImage(_selectedImage!) as ImageProvider
                      : (resolvedNetwork != null
                          ? NetworkImage(resolvedNetwork)
                          : null),
                  child: (!hasLocal && resolvedNetwork == null)
                      ? const Icon(LucideIcons.user, size: 48, color: AppColors.primaryTeal)
                      : null,
                ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: GestureDetector(
                  onTap: _showImagePickerSheet,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTeal,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: const Icon(LucideIcons.camera, color: Colors.white, size: 16),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton.icon(
                onPressed: _showImagePickerSheet,
                icon: const Icon(LucideIcons.image, size: 14),
                label: Text(
                  hasLocal ? 'Change Photo' : 'Upload Profile Photo',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryTeal,
                  side: BorderSide(color: AppColors.primaryTeal.withValues(alpha: 0.4)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
              if (hasLocal) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(LucideIcons.trash2, size: 16, color: AppColors.errorRed),
                  tooltip: 'Remove selected photo',
                  onPressed: () => setState(() => _selectedImage = null),
                ),
              ],
            ],
          ),
          if (hasLocal)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Ready to upload: ${_selectedImage!.path.split(Platform.pathSeparator).last}',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.successGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ─── Gender Chip Helper ────────────────────────────────────────────────────

  Widget _genderChip(String value, String label, IconData icon) {
    final selected = _gender == value;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _gender = value),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primaryTeal.withValues(alpha: 0.12)
                : Colors.grey.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected
                  ? AppColors.primaryTeal
                  : Colors.grey.withValues(alpha: 0.25),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 15,
                color: selected ? AppColors.primaryTeal : Colors.grey[700],
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                  color: selected ? AppColors.primaryTeal : Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Medical Specialties Selector Card ─────────────────────────────────────

  Widget _buildSpecialtiesCard(DoctorProfileViewModel viewModel) {
    // Default fallback specialties if not yet loaded from API
    final fallbackSpecialties = [
      {'value': 16, 'label': 'Cardiology'},
      {'value': 50, 'label': 'Oral & Maxillofacial Surgery'},
      {'value': 48, 'label': 'Otolaryngology (ENT)'},
      {'value': 49, 'label': 'Dentistry (General)'},
      {'value': 15, 'label': 'Internal Medicine'},
      {'value': 17, 'label': 'Neurology'},
      {'value': 26, 'label': 'General Surgery'},
      {'value': 36, 'label': 'Pediatrics (General)'},
    ];

    final List<Map<String, dynamic>> flatOptions = [];

    if (viewModel.specialties.isNotEmpty) {
      for (final cat in viewModel.specialties) {
        if (cat['options'] is List) {
          for (final opt in cat['options']) {
            if (opt is Map<String, dynamic>) {
              flatOptions.add(opt);
            }
          }
        }
      }
    }

    final displayOptions = flatOptions.isNotEmpty ? flatOptions : fallbackSpecialties;

    return _buildSectionCard(
      title: 'Medical Specialties',
      icon: LucideIcons.badgeCheck,
      children: [
        const Text(
          'Select all medical specialties that apply to your practice:',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: displayOptions.map((opt) {
            final idStr = opt['value'].toString();
            final label = opt['label'].toString();
            final isSelected = _selectedSpecialtyIds.contains(idStr);

            return FilterChip(
              label: Text(label),
              selected: isSelected,
              selectedColor: AppColors.primaryTeal.withValues(alpha: 0.15),
              checkmarkColor: AppColors.primaryTeal,
              backgroundColor: Colors.grey.withValues(alpha: 0.08),
              side: BorderSide(
                color: isSelected
                    ? AppColors.primaryTeal
                    : Colors.grey.withValues(alpha: 0.25),
              ),
              labelStyle: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.primaryTeal : Colors.grey[800],
              ),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedSpecialtyIds.add(idStr);
                  } else {
                    _selectedSpecialtyIds.remove(idStr);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  // ─── Helpers: Section Card & TextField ─────────────────────────────────────

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primaryTeal),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.primaryTeal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.18)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
            prefixIcon: Icon(icon, size: 18, color: AppColors.primaryTeal),
            filled: true,
            fillColor: Colors.grey.withValues(alpha: 0.06),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryTeal, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
