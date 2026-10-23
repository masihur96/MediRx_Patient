import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/blood_bank_models.dart';

class DonorHubTab extends StatefulWidget {
  final List<DonorProfile> donors;
  final bool isDonor;
  final BloodGroup myBloodGroup;
  final bool isAvailable;
  final DateTime lastDonation;
  final VoidCallback onToggleDonor;

  const DonorHubTab({
    super.key,
    required this.donors,
    required this.isDonor,
    required this.myBloodGroup,
    required this.isAvailable,
    required this.lastDonation,
    required this.onToggleDonor,
  });

  @override
  State<DonorHubTab> createState() => _DonorHubTabState();
}

class _DonorHubTabState extends State<DonorHubTab> {
  BloodGroup? _filterGroup;

  List<DonorProfile> get _filtered {
    return widget.donors.where((d) {
      return _filterGroup == null || d.bloodGroup == _filterGroup;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // My donor profile card (if donor)
        SliverToBoxAdapter(
          child: _MyDonorCard(
            isDonor: widget.isDonor,
            bloodGroup: widget.myBloodGroup,
            isAvailable: widget.isAvailable,
            lastDonation: widget.lastDonation,
            onToggle: widget.onToggleDonor,
          ),
        ),

        // Filter row
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Find a Donor',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _GroupChip(
                        label: 'All',
                        color: AppColors.primaryTeal,
                        selected: _filterGroup == null,
                        onTap: () => setState(() => _filterGroup = null),
                      ),
                      const SizedBox(width: 8),
                      ...BloodGroup.values.map((g) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _GroupChip(
                              label: g.label,
                              color: g.color,
                              selected: _filterGroup == g,
                              onTap: () =>
                                  setState(() => _filterGroup = g),
                            ),
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${_filtered.length} donor${_filtered.length == 1 ? '' : 's'} nearby',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textGray),
                ),
              ],
            ),
          ),
        ),

        // Donor list
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) => _DonorCard(donor: _filtered[i]),
              childCount: _filtered.length,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── My Donor Card ───────────────────────────────────────────────────────────

class _MyDonorCard extends StatelessWidget {
  final bool isDonor;
  final BloodGroup bloodGroup;
  final bool isAvailable;
  final DateTime lastDonation;
  final VoidCallback onToggle;

  const _MyDonorCard({
    required this.isDonor,
    required this.bloodGroup,
    required this.isAvailable,
    required this.lastDonation,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDonor
                ? [
                    AppColors.primaryTeal,
                    AppColors.lightTeal,
                  ]
                : [
                    Colors.grey.shade700,
                    Colors.grey.shade500,
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: isDonor
                  ? Center(
                      child: Text(
                        bloodGroup.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    )
                  : const Icon(Icons.volunteer_activism_outlined,
                      color: Colors.white, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isDonor ? 'You are a Donor ❤️' : 'Become a Blood Donor',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isDonor
                        ? '${bloodGroup.label} • ${isAvailable ? 'Available' : 'Unavailable'} • Last donated ${_daysSince(lastDonation)}'
                        : 'Tap to enable your donor profile',
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white70),
          ],
        ),
      ),
    );
  }

  String _daysSince(DateTime date) {
    final days = DateTime.now().difference(date).inDays;
    if (days < 30) return '$days days ago';
    return '${(days / 30).floor()}mo ago';
  }
}

// ─── Group Chip ──────────────────────────────────────────────────────────────

class _GroupChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _GroupChip({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected ? color : Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

// ─── Donor Card ──────────────────────────────────────────────────────────────

class _DonorCard extends StatelessWidget {
  final DonorProfile donor;

  const _DonorCard({required this.donor});

  @override
  Widget build(BuildContext context) {
    final groupColor = donor.bloodGroup.color;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Avatar with blood group
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: groupColor.withValues(alpha: 0.15),
                  child: Text(
                    donor.name.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      color: groupColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: groupColor,
                      borderRadius: BorderRadius.circular(6),
                      border:
                          Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Text(
                      donor.bloodGroup.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        donor.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (donor.isAvailable && donor.canDonateNow)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Ready',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${donor.city} • ${donor.totalDonations} donations',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textGray),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Last donation: ${donor.lastDonationLabel}',
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),

            // Call button
            if (donor.isAvailable && donor.canDonateNow)
              GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  _showCallConfirm(context, donor);
                },
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: const Icon(Icons.call_rounded,
                      color: Colors.green, size: 20),
                ),
              )
            else
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  donor.isAvailable
                      ? Icons.hourglass_top_rounded
                      : Icons.do_not_disturb_on_rounded,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showCallConfirm(BuildContext context, DonorProfile donor) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Call Donor?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor:
                  donor.bloodGroup.color.withValues(alpha: 0.15),
              child: Text(
                donor.bloodGroup.label,
                style: TextStyle(
                  color: donor.bloodGroup.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              donor.name,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              donor.phone,
              style: const TextStyle(
                  color: AppColors.textGray, fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Calling ${donor.name}…'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.all(16),
                ),
              );
            },
            icon: const Icon(Icons.call_rounded, size: 16),
            label: const Text('Call Now'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }
}
