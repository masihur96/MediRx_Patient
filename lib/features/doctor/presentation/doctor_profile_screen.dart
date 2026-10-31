import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:medirx_patient/configs/custom_size.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_snackbar.dart';
import '../../../shared/widgets/shimmer_loaders.dart';
import '../../auth/presentation/login_screen.dart';
import '../../auth/presentation/viewmodels/auth_viewmodel.dart';
import '../data/doctor_models.dart';
import 'doctor_settings_screen.dart';
import 'viewmodels/doctor_profile_viewmodel.dart';

class DoctorProfileScreen extends StatefulWidget {
  final String? doctorId;

  const DoctorProfileScreen({super.key, this.doctorId});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfile();
    });
  }

  String _resolveDoctorId() {
    if (widget.doctorId != null && widget.doctorId!.trim().isNotEmpty) {
      return widget.doctorId!.trim();
    }
    final authUser = context.read<AuthViewModel>().currentUser;
    if (authUser?.id != null && authUser!.id.trim().isNotEmpty) {
      return authUser.id.trim();
    }
    // Default fallback doctor ID from API
    return '38';
  }

  Future<void> _loadProfile() async {
    final targetId = _resolveDoctorId();
    await context
        .read<DoctorProfileViewModel>()
        .fetchDoctorProfile(doctorId: targetId);
  }

  Future<void> _refreshProfile() async {
    if (_isRefreshing) return;
    setState(() => _isRefreshing = true);

    final targetId = _resolveDoctorId();
    await Future.wait([
      context.read<DoctorProfileViewModel>().fetchDoctorProfile(
            doctorId: targetId,
            showLoading: false,
          ),
      context.read<AuthViewModel>().fetchUserProfile(),
    ]);

    if (mounted) {
      setState(() => _isRefreshing = false);
    }
  }

  String _formatDoctorName(String? rawName, String fallback) {
    if (rawName == null || rawName.trim().isEmpty) return fallback;
    final trimmed = rawName.trim();
    if (trimmed.toLowerCase().startsWith('dr.') ||
        trimmed.toLowerCase().startsWith('dr ')) {
      return trimmed;
    }
    return 'Dr. $trimmed';
  }

  String _getInitials(String? rawName) {
    if (rawName == null || rawName.trim().isEmpty) return 'DR';
    final parts = rawName.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    AppSnackBar.showSuccess(
      context,
      message: '$label copied to clipboard',
    );
  }

  @override
  Widget build(BuildContext context) {
    final doctorViewModel = context.watch<DoctorProfileViewModel>();
    final authViewModel = context.watch<AuthViewModel>();
    final user = authViewModel.currentUser;

    final profile = doctorViewModel.doctorProfile;
    final isLoading = doctorViewModel.isLoading && profile == null;
    final hasError = doctorViewModel.errorMessage != null && profile == null;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: RefreshIndicator(
        onRefresh: _refreshProfile,
        color: AppColors.primaryTeal,
        child: isLoading
            ? _buildShimmerLoading(context)
            : hasError
                ? _buildErrorState(context, doctorViewModel.errorMessage!)
                : _buildProfileContent(context, profile!, user),
      ),
    );
  }

  Widget _buildProfileContent(
    BuildContext context,
    DoctorProfile profile,
    dynamic authUser,
  ) {
    final rawName = profile.name.isNotEmpty
        ? profile.name
        : (authUser?.fullName ?? 'Healthcare Professional');
    final doctorName = _formatDoctorName(rawName, 'Dr. Doctor');
    final initials = _getInitials(rawName);

    final imageUrl =
        (profile.profileImage != null && profile.profileImage!.isNotEmpty)
            ? profile.profileImage
            : authUser?.profileImage;
    final hasImage = imageUrl != null &&
        (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));

    final doctorId = profile.uuid ??
        (profile.id.isNotEmpty
            ? 'DOC-${profile.id}'
            : (authUser?.uuid ?? 'DOC-38'));

    final isActive = profile.isActive == true || profile.status == true;
    final status = isActive ? 'Active' : 'Pending';

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        _buildSliverAppBar(
          context,
          profile,
          doctorName,
          initials,
          hasImage,
          imageUrl,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Doctor ID & Verification Card
                _buildDoctorIdCard(
                    context, profile, doctorId, status, isActive),
                const SizedBox(height: 16),

                // Key Performance / Experience Metrics
                _buildStatsRow(context, profile),
                const SizedBox(height: 16),

                // Incomplete Profile Prompt (e.g. if new registration)
                if (profile.bio.isEmpty || profile.qualification.isEmpty)
                  _buildProfileCompletionCard(context, profile),

                // Professional Clinical Details
                _buildProfessionalDetailsCard(context, profile, authUser),
                const SizedBox(height: 16),

                // About / Bio Section
                _buildAboutCard(context, profile),
                const SizedBox(height: 16),

                // Education & Degrees
                _buildEducationCard(context, profile),
                const SizedBox(height: 16),

                // Clinical Experience & Hospitals
                _buildExperienceCard(context, profile),
                const SizedBox(height: 16),

                // Contact & Account Information
                _buildContactCard(context, profile, authUser),
                const SizedBox(height: 24),

                // Action Buttons (Edit Profile, Settings, Logout)
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── Sliver App Bar ────────────────────────────────────────────────────────

  Widget _buildSliverAppBar(
    BuildContext context,
    DoctorProfile profile,
    String doctorName,
    String initials,
    bool hasImage,
    String? imageUrl,
  ) {
    final designation = profile.designation.isNotEmpty
        ? profile.designation
        : (profile.specialization.isNotEmpty
            ? profile.specialization
            : 'Medical Practitioner');

    final institute = profile.hospital.isNotEmpty ? profile.hospital : null;

    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      elevation: 0,
      backgroundColor: AppColors.primaryTeal,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0F7A7A),
                Color(0xFF005B54),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                // Avatar with Verified Badge
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.6),
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 46,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    backgroundImage: hasImage ? NetworkImage(imageUrl!) : null,
                    child: !hasImage
                        ? Text(
                            initials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 10),

                // Doctor Full Name with Verified Badge
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          doctorName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        LucideIcons.badgeCheck,
                        size: 20,
                        color: Color(0xFF64FFDA),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),

                // Designation / Specialization
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    designation,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                if (institute != null) ...[
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      institute,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Doctor ID & Verification Card ─────────────────────────────────────────

  Widget _buildDoctorIdCard(
    BuildContext context,
    DoctorProfile profile,
    String doctorId,
    String status,
    bool isActive,
  ) {
    final regNo = profile.regNo.isNotEmpty ? profile.regNo : 'BMDC-VERIFIED';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryTeal.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.primaryTeal.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.shieldCheck,
                  color: AppColors.primaryTeal,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  'Reg No: $regNo',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.primaryTeal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                width: screenSize(context, .3),
              ),
              IconButton(
                icon: const Icon(LucideIcons.copy, size: 18),
                color: AppColors.primaryTeal,
                tooltip: 'Copy Reg NO',
                onPressed: () => _copyToClipboard(regNo, 'Reg NO'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Key Stats Metrics Row ────────────────────────────────────────────────

  Widget _buildStatsRow(BuildContext context, DoctorProfile profile) {
    final expDisplay = profile.experienceYears != null
        ? '${profile.experienceYears} Yrs'
        : (profile.experience.isNotEmpty ? profile.experience : 'Clinical');

    final ratingDisplay =
        profile.rating > 0 ? profile.rating.toStringAsFixed(1) : '5.0';

    final reviewsDisplay =
        profile.reviewCount != null && profile.reviewCount! > 0
            ? '${profile.reviewCount} Reviews'
            : 'Top Rated';

    final patientDisplay =
        profile.totalPatients > 0 ? '${profile.totalPatients}+' : 'Active';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem(context, expDisplay, 'Experience', LucideIcons.briefcase),
          _dividerLine(),
          _statItem(context, ratingDisplay, reviewsDisplay, LucideIcons.star,
              isStar: true),
          _dividerLine(),
          _statItem(context, patientDisplay, 'Patients', LucideIcons.users),
        ],
      ),
    );
  }

  Widget _statItem(
    BuildContext context,
    String value,
    String label,
    IconData icon, {
    bool isStar = false,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 18,
          color: isStar ? const Color(0xFFFFB300) : AppColors.primaryTeal,
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(color: Colors.grey[600], fontSize: 11),
        ),
      ],
    );
  }

  Widget _dividerLine() {
    return Container(
      width: 1,
      height: 40,
      color: Colors.grey.withValues(alpha: 0.25),
    );
  }

  // ─── Profile Completion Prompt ─────────────────────────────────────────────

  Widget _buildProfileCompletionCard(
      BuildContext context, DoctorProfile profile) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFE082)),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.sparkles, color: Color(0xFFF57F17), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Complete Your Professional Profile',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFFE65100),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Add degrees, hospital affiliations, and biography to enhance patient trust.',
                  style: TextStyle(fontSize: 11, color: Colors.grey[800]),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Doctor profile editing coming soon')),
              );
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Add Now',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Color(0xFFE65100),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Professional Clinical Details Card ────────────────────────────────────

  Widget _buildProfessionalDetailsCard(
    BuildContext context,
    DoctorProfile profile,
    dynamic authUser,
  ) {
    final fullName = profile.name.isNotEmpty
        ? profile.name
        : (authUser?.fullName ?? 'Not specified');

    final qualification = profile.qualification.isNotEmpty
        ? profile.qualification
        : 'MBBS (Pending Verification)';

    final specialization = profile.specialization.isNotEmpty
        ? profile.specialization
        : 'General Medicine';

    final regNo = profile.regNo.isNotEmpty
        ? profile.regNo
        : 'BMDC Registration In Process';

    final hospital = profile.hospital.isNotEmpty
        ? profile.hospital
        : 'Private Practice / Clinic';

    final designation = profile.designation.isNotEmpty
        ? profile.designation
        : 'Registered Medical Practitioner';

    return _cardContainer(
      context,
      title: 'Professional Details',
      icon: LucideIcons.stethoscope,
      children: [
        _infoRow(context, LucideIcons.user, 'Full Name', fullName),
        _infoRow(context, LucideIcons.award, 'Qualifications', qualification),
        _infoRow(
            context, LucideIcons.activity, 'Specialization', specialization),
        _infoRow(context, LucideIcons.fileBadge, 'BMDC Registration', regNo,
            canCopy: true),
        _infoRow(context, LucideIcons.briefcase, 'Designation', designation),
        _infoRow(
            context, LucideIcons.building2, 'Hospital Affiliation', hospital),
        if (profile.experienceYears != null)
          _infoRow(context, LucideIcons.clock, 'Clinical Experience',
              '${profile.experienceYears} Years'),
      ],
    );
  }

  // ─── About Section ────────────────────────────────────────────────────────

  Widget _buildAboutCard(BuildContext context, DoctorProfile profile) {
    final bioText = profile.bio.isNotEmpty
        ? profile.bio
        : 'Dr. ${profile.name.isNotEmpty ? profile.name : "Practitioner"} is a verified healthcare provider registered with the Bangladesh Medical & Dental Council (BMDC). Dedicated to providing evidence-based patient-centered medical care.';

    return _cardContainer(
      context,
      title: 'About the Doctor',
      icon: LucideIcons.fileText,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            bioText,
            style: TextStyle(
              fontSize: 13,
              height: 1.6,
              color: Colors.grey[750],
            ),
          ),
        ),
      ],
    );
  }

  // ─── Education & Qualifications Section ────────────────────────────────────

  Widget _buildEducationCard(BuildContext context, DoctorProfile profile) {
    final hasEducations = profile.educations.isNotEmpty;

    return _cardContainer(
      context,
      title: 'Education & Qualifications',
      icon: LucideIcons.graduationCap,
      children: [
        if (hasEducations)
          ...profile.educations.map((edu) => _educationItem(edu))
        else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Icon(LucideIcons.info, size: 16, color: Colors.grey[500]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    profile.qualification.isNotEmpty
                        ? 'Degrees: ${profile.qualification}'
                        : 'No detailed institutional records added yet.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _educationItem(DoctorEducation edu) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryTeal.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10),
        border:
            Border.all(color: AppColors.primaryTeal.withValues(alpha: 0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primaryTeal.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.graduationCap,
              size: 16,
              color: AppColors.primaryTeal,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  edu.degree,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  edu.institute,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
                if (edu.year.isNotEmpty || edu.country.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    [
                      if (edu.year.isNotEmpty) 'Year: ${edu.year}',
                      if (edu.country.isNotEmpty) edu.country,
                    ].join(' • '),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Clinical Experience Section ──────────────────────────────────────────

  Widget _buildExperienceCard(BuildContext context, DoctorProfile profile) {
    final hasExperiences = profile.experiences.isNotEmpty;

    return _cardContainer(
      context,
      title: 'Clinical Experience',
      icon: LucideIcons.building,
      children: [
        if (hasExperiences)
          ...profile.experiences.map((exp) => _experienceItem(exp))
        else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Icon(LucideIcons.info, size: 16, color: Colors.grey[500]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    profile.hospital.isNotEmpty
                        ? 'Affiliated with ${profile.hospital}'
                        : 'No past hospital appointment records registered yet.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _experienceItem(DoctorExperience exp) {
    final period = [
      if (exp.fromYear.isNotEmpty) exp.fromYear,
      if (exp.toYear.isNotEmpty) exp.toYear,
    ].join(' – ');

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryTeal.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10),
        border:
            Border.all(color: AppColors.primaryTeal.withValues(alpha: 0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primaryTeal.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.briefcase,
              size: 16,
              color: AppColors.primaryTeal,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        exp.position,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    if (period.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primaryTeal.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          period,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryTeal,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  exp.hospitalName,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
                if (exp.description != null &&
                    exp.description!.trim().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    exp.description!.trim(),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Contact & Account Information ────────────────────────────────────────

  Widget _buildContactCard(
    BuildContext context,
    DoctorProfile profile,
    dynamic authUser,
  ) {
    final email = profile.email.isNotEmpty
        ? profile.email
        : (authUser?.email ?? 'Not available');

    final phone = profile.phone.isNotEmpty
        ? profile.phone
        : (authUser?.phone ?? 'Not available');

    final accountId = profile.id.isNotEmpty
        ? '#${profile.id}'
        : (authUser?.id != null ? '#${authUser.id}' : '#38');

    return _cardContainer(
      context,
      title: 'Contact & Account',
      icon: LucideIcons.contact,
      children: [
        _infoRow(context, LucideIcons.mail, 'Email Address', email,
            canCopy: true),
        _infoRow(context, LucideIcons.phone, 'Phone Number', phone,
            canCopy: true),
        _infoRow(context, LucideIcons.hash, 'Account ID', accountId,
            canCopy: true),
        if (profile.gender != null && profile.gender!.isNotEmpty)
          _infoRow(context, LucideIcons.user, 'Gender',
              profile.gender![0].toUpperCase() + profile.gender!.substring(1)),
        if (profile.dob != null && profile.dob!.isNotEmpty)
          _infoRow(
              context, LucideIcons.calendar, 'Date of Birth', profile.dob!),
      ],
    );
  }

  // ─── Action Buttons ────────────────────────────────────────────────────────

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Edit Profile
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Doctor profile editing coming soon')),
            ),
            icon: const Icon(LucideIcons.edit3, color: Colors.white, size: 18),
            label: const Text(
              'Edit Professional Profile',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryTeal,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Settings Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DoctorSettingsScreen()),
            ),
            icon: const Icon(LucideIcons.settings, size: 18),
            label: const Text(
              'Doctor Panel Settings',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryTeal,
              side: BorderSide(
                  color: AppColors.primaryTeal.withValues(alpha: 0.4)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Logout Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _showLogoutDialog(context),
            icon: const Icon(LucideIcons.logOut, size: 18),
            label: const Text(
              'Logout',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.errorRed,
              side:
                  BorderSide(color: AppColors.errorRed.withValues(alpha: 0.5)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Helpers: Card & Row ───────────────────────────────────────────────────

  Widget _cardContainer(
    BuildContext context, {
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
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    bool canCopy = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.primaryTeal),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.grey[600], fontSize: 11),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          if (canCopy)
            GestureDetector(
              onTap: () => _copyToClipboard(value, label),
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 4),
                child: Icon(
                  LucideIcons.copy,
                  size: 15,
                  color: Colors.grey[500],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ─── Shimmer Loading Skeleton ──────────────────────────────────────────────

  Widget _buildShimmerLoading(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          // Header Skeleton
          Container(
            height: 250,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F7A7A), Color(0xFF005B54)],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(height: 36),
                ShimmerLoadingBox(width: 90, height: 90, borderRadius: 45),
                SizedBox(height: 14),
                ShimmerLoadingBox(width: 180, height: 18, borderRadius: 6),
                SizedBox(height: 8),
                ShimmerLoadingBox(width: 130, height: 14, borderRadius: 6),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: const [
                ShimmerLoadingBox(
                    width: double.infinity, height: 60, borderRadius: 14),
                SizedBox(height: 16),
                ShimmerLoadingBox(
                    width: double.infinity, height: 80, borderRadius: 16),
                SizedBox(height: 16),
                ShimmerLoadingBox(
                    width: double.infinity, height: 160, borderRadius: 16),
                SizedBox(height: 16),
                ShimmerLoadingBox(
                    width: double.infinity, height: 120, borderRadius: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Error State ──────────────────────────────────────────────────────────

  Widget _buildErrorState(BuildContext context, String errorMessage) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.errorRed.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.alertTriangle,
                size: 48,
                color: AppColors.errorRed,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Unable to Load Doctor Profile',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadProfile,
              icon: const Icon(LucideIcons.refreshCw,
                  size: 16, color: Colors.white),
              label: const Text('Retry Fetching',
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryTeal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Logout Confirmation Dialog ────────────────────────────────────────────

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout'),
        content: const Text(
            'Are you sure you want to logout from the Doctor Panel?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await context.read<AuthViewModel>().logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            style:
                ElevatedButton.styleFrom(backgroundColor: AppColors.errorRed),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
