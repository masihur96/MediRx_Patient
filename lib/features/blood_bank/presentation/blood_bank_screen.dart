import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../data/blood_bank_models.dart';
import '../data/blood_bank_dummy_data.dart';
import 'widgets/blood_bank_directory_tab.dart';
import 'widgets/donor_hub_tab.dart';
import 'widgets/emergency_tab.dart';

class BloodBankScreen extends StatefulWidget {
  const BloodBankScreen({super.key});

  @override
  State<BloodBankScreen> createState() => _BloodBankScreenState();
}

class _BloodBankScreenState extends State<BloodBankScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Simulated current user donor toggle state
  bool _isDonor = false;
  BloodGroup _myBloodGroup = BloodGroup.bPos;
  bool _isDonorAvailable = true;
  DateTime _lastDonationDate = DateTime.now().subtract(const Duration(days: 120));

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showDonorToggleSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DonorToggleSheet(
        isDonor: _isDonor,
        bloodGroup: _myBloodGroup,
        isAvailable: _isDonorAvailable,
        lastDonation: _lastDonationDate,
        onSave: (isDonor, group, available, lastDonation) {
          setState(() {
            _isDonor = isDonor;
            _myBloodGroup = group;
            _isDonorAvailable = available;
            _lastDonationDate = lastDonation;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 160,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primaryTeal,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              // Donor toggle shortcut
              GestureDetector(
                onTap: _showDonorToggleSheet,
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _isDonor
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.volunteer_activism_rounded,
                        color: _isDonor
                            ? AppColors.primaryTeal
                            : Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _isDonor ? 'Donor ON' : 'Be a Donor',
                        style: TextStyle(
                          color: _isDonor
                              ? AppColors.primaryTeal
                              : Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF0F7A7A),
                      Color(0xFFB71C1C),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 56, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.bloodtype_rounded,
                                color: Colors.white, size: 28),
                            const SizedBox(width: 10),
                            const Text(
                              'Blood Bank',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Find blood banks, connect with donors\n& broadcast emergency requests',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 13),
              tabs: const [
                Tab(text: '🏥 Directory'),
                Tab(text: '🩸 Donors'),
                Tab(text: '🚨 Emergency'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            BloodBankDirectoryTab(
              banks: BloodBankDummyData.bloodBanks,
            ),
            DonorHubTab(
              donors: BloodBankDummyData.donors,
              isDonor: _isDonor,
              myBloodGroup: _myBloodGroup,
              isAvailable: _isDonorAvailable,
              lastDonation: _lastDonationDate,
              onToggleDonor: _showDonorToggleSheet,
            ),
            EmergencyTab(
              requests: BloodBankDummyData.emergencyRequests,
              onBroadcast: () => _showBroadcastDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showBroadcastDialog(BuildContext context) {
    final bloodGroups = BloodGroup.values;
    BloodGroup selectedGroup = BloodGroup.aPos;
    final hospitalController = TextEditingController();
    final noteController = TextEditingController();
    bool isUrgent = true;
    int units = 1;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.campaign_rounded,
                    color: Colors.red, size: 20),
              ),
              const SizedBox(width: 10),
              const Text('Emergency Broadcast',
                  style: TextStyle(fontSize: 17)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Blood Group',
                    style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: bloodGroups.map((g) {
                    final selected = selectedGroup == g;
                    return GestureDetector(
                      onTap: () => setS(() => selectedGroup = g),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: selected ? g.color : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: selected
                                  ? g.color
                                  : Colors.grey.shade300),
                        ),
                        child: Text(
                          g.label,
                          style: TextStyle(
                            color: selected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Units needed: ',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        if (units > 1) setS(() => units--);
                      },
                      icon: const Icon(Icons.remove_circle_outline),
                      color: AppColors.primaryTeal,
                    ),
                    Text('$units',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(
                      onPressed: () => setS(() => units++),
                      icon: const Icon(Icons.add_circle_outline),
                      color: AppColors.primaryTeal,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: hospitalController,
                  decoration: _inputDecor('Hospital name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: noteController,
                  maxLines: 2,
                  decoration: _inputDecor('Additional note (optional)'),
                ),
                const SizedBox(height: 12),
                SwitchListTile.adaptive(
                  dense: true,
                  value: isUrgent,
                  onChanged: (v) => setS(() => isUrgent = v),
                  title: const Text('Mark as Urgent',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  activeThumbColor: Colors.red,
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(ctx).pop();
                HapticFeedback.heavyImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.check_circle_outline,
                            color: Colors.white),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Emergency broadcast sent for ${selectedGroup.label}! Nearby donors will be alerted.',
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.red.shade700,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.all(16),
                    duration: const Duration(seconds: 4),
                  ),
                );
              },
              icon: const Icon(Icons.send_rounded, size: 16),
              label: const Text('Broadcast'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecor(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 13),
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
            const BorderSide(color: AppColors.primaryTeal, width: 1.5),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }
}

// ─── Donor Toggle Bottom Sheet ───────────────────────────────────────────────

class _DonorToggleSheet extends StatefulWidget {
  final bool isDonor;
  final BloodGroup bloodGroup;
  final bool isAvailable;
  final DateTime lastDonation;
  final void Function(bool isDonor, BloodGroup group, bool available,
      DateTime lastDonation) onSave;

  const _DonorToggleSheet({
    required this.isDonor,
    required this.bloodGroup,
    required this.isAvailable,
    required this.lastDonation,
    required this.onSave,
  });

  @override
  State<_DonorToggleSheet> createState() => _DonorToggleSheetState();
}

class _DonorToggleSheetState extends State<_DonorToggleSheet> {
  late bool _isDonor;
  late BloodGroup _bloodGroup;
  late bool _isAvailable;
  late DateTime _lastDonation;

  @override
  void initState() {
    super.initState();
    _isDonor = widget.isDonor;
    _bloodGroup = widget.bloodGroup;
    _isAvailable = widget.isAvailable;
    _lastDonation = widget.lastDonation;
  }

  String get _daysSinceLabel {
    final days = DateTime.now().difference(_lastDonation).inDays;
    if (days == 0) return 'Today';
    if (days == 1) return 'Yesterday';
    return '$days days ago';
  }

  bool get _canDonate =>
      DateTime.now().difference(_lastDonation).inDays >= 90;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.volunteer_activism_rounded,
                    color: Colors.red, size: 22),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Blood Donor Profile',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                    Text('Toggle your donor status anytime',
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textGray)),
                  ],
                ),
              ),
              Switch.adaptive(
                value: _isDonor,
                onChanged: (v) => setState(() => _isDonor = v),
                activeThumbColor: AppColors.primaryTeal,
              ),
            ],
          ),
          const SizedBox(height: 20),

          if (_isDonor) ...[
            const Divider(),
            const SizedBox(height: 12),

            // Blood group picker
            const Text('Your Blood Group',
                style:
                    TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: BloodGroup.values.map((g) {
                final selected = _bloodGroup == g;
                return GestureDetector(
                  onTap: () => setState(() => _bloodGroup = g),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? g.color : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                          color: selected ? g.color : Colors.grey.shade300,
                          width: selected ? 2 : 1),
                    ),
                    child: Text(
                      g.label,
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Last donation
            Row(
              children: [
                const Icon(Icons.calendar_today_rounded,
                    size: 16, color: AppColors.primaryTeal),
                const SizedBox(width: 8),
                const Text('Last Donation:',
                    style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                const Spacer(),
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _lastDonation,
                      firstDate: DateTime(2010),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() => _lastDonation = picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.mint,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _daysSinceLabel,
                      style: const TextStyle(
                        color: AppColors.primaryTeal,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Can donate indicator
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: _canDonate
                    ? Colors.green.shade50
                    : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: _canDonate
                        ? Colors.green.shade200
                        : Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    _canDonate
                        ? Icons.check_circle_rounded
                        : Icons.hourglass_top_rounded,
                    color: _canDonate ? Colors.green : Colors.orange,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _canDonate
                        ? 'You are eligible to donate now!'
                        : 'Next eligible in ${90 - DateTime.now().difference(_lastDonation).inDays} days',
                    style: TextStyle(
                      fontSize: 12,
                      color: _canDonate ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Availability toggle
            SwitchListTile.adaptive(
              dense: true,
              contentPadding: EdgeInsets.zero,
              value: _isAvailable,
              onChanged:
                  _canDonate ? (v) => setState(() => _isAvailable = v) : null,
              title: const Text('Available to donate',
                  style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600)),
              subtitle: Text(
                _canDonate
                    ? 'Donors in need can see and contact you'
                    : 'Not eligible yet — cooldown period',
                style: const TextStyle(fontSize: 11),
              ),
              activeThumbColor: AppColors.primaryTeal,
            ),
          ],

          const SizedBox(height: 20),

          // Save button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                widget.onSave(
                    _isDonor, _bloodGroup, _isAvailable, _lastDonation);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryTeal,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Save Profile',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
