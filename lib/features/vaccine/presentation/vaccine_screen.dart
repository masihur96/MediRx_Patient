import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../presentation/viewmodels/vaccine_viewmodel.dart';

class VaccineScreen extends StatefulWidget {
  const VaccineScreen({super.key});

  @override
  State<VaccineScreen> createState() => _VaccineScreenState();
}

class _VaccineScreenState extends State<VaccineScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VaccineViewModel>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vaccine Schedule',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.refreshCw),
            onPressed: () => context.read<VaccineViewModel>().init(),
          ),
        ],
      ),
      body: Consumer<VaccineViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.errorMessage != null && vm.vaccines.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.alertCircle,
                      color: Colors.red, size: 48),
                  const SizedBox(height: 12),
                  Text(vm.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => vm.init(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final vaccines = vm.vaccines;
          final vaccinations = vm.vaccinations;

          // Build a set of received vaccine IDs
          final receivedVaccineIds = <String>{};
          for (final v in vaccinations) {
            final vid = v['vaccine_id']?.toString() ?? v['vaccineId']?.toString() ?? '';
            if (vid.isNotEmpty) receivedVaccineIds.add(vid);
          }

          final upcoming = vaccines.where((v) {
            final id = (v['id'] ?? v['uuid'] ?? '').toString();
            return !receivedVaccineIds.contains(id);
          }).toList();

          final completed = vaccines.where((v) {
            final id = (v['id'] ?? v['uuid'] ?? '').toString();
            return receivedVaccineIds.contains(id);
          }).toList();

          return RefreshIndicator(
            onRefresh: () => vm.init(),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Summary banner
                _buildSummaryBanner(vaccines.length, completed.length),
                const SizedBox(height: 24),

                if (upcoming.isNotEmpty) ...[
                  _buildSectionHeader(
                      context, 'Upcoming (${upcoming.length})'),
                  const SizedBox(height: 12),
                  ...upcoming.map((v) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildVaccineCard(context, v, false),
                      )),
                  const SizedBox(height: 16),
                ],

                if (completed.isNotEmpty) ...[
                  _buildSectionHeader(
                      context, 'Received (${completed.length})'),
                  const SizedBox(height: 12),
                  ...completed.map((v) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildVaccineCard(context, v, true),
                      )),
                ],

                if (vaccines.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          Icon(LucideIcons.syringe,
                              size: 60,
                              color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          Text('No vaccines found',
                              style: TextStyle(
                                  color: Colors.grey[500], fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryBanner(int total, int received) {
    final progress = total > 0 ? received / total : 0.0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryTeal,
            AppColors.primaryTeal.withValues(alpha: 0.7)
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.shieldCheck,
                  color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Vaccination Progress',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    Text('$received of $total vaccines received',
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 6),
          Text('${(progress * 100).toStringAsFixed(0)}% complete',
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildVaccineCard(
      BuildContext context, Map<String, dynamic> vaccine, bool isReceived) {
    final name = vaccine['name']?.toString() ?? 'Unknown Vaccine';
    final code = vaccine['code']?.toString() ?? '';
    final description = vaccine['description']?.toString() ?? '';

    final color = isReceived ? Colors.green : AppColors.primaryTeal;
    final icon = isReceived ? LucideIcons.checkCircle : LucideIcons.syringe;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isReceived
              ? Colors.green.withValues(alpha: 0.2)
              : Colors.grey.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (code.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(code,
                            style: TextStyle(
                                fontSize: 11,
                                color: color,
                                fontWeight: FontWeight.w600)),
                      ),
                  ],
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      isReceived
                          ? LucideIcons.checkCircle2
                          : LucideIcons.clock,
                      size: 14,
                      color: color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isReceived ? 'Received' : 'Pending',
                      style: TextStyle(
                          fontSize: 12,
                          color: color,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
