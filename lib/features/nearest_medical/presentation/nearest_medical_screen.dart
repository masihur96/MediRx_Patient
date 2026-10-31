import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../presentation/viewmodels/hospital_viewmodel.dart';

class NearestMedicalScreen extends StatefulWidget {
  const NearestMedicalScreen({super.key});

  @override
  State<NearestMedicalScreen> createState() => _NearestMedicalScreenState();
}

class _NearestMedicalScreenState extends State<NearestMedicalScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HospitalViewModel>().fetchHospitals();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearest Medical',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.refreshCw),
            onPressed: () =>
                context.read<HospitalViewModel>().fetchHospitals(),
          ),
        ],
      ),
      body: Consumer<HospitalViewModel>(
        builder: (context, vm, _) {
          return Column(
            children: [
              // Search bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: TextField(
                  controller: _searchController,
                  onChanged: vm.search,
                  decoration: InputDecoration(
                    hintText: 'Search hospitals, clinics...',
                    prefixIcon:
                        const Icon(LucideIcons.search, size: 20),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(LucideIcons.x, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              vm.search('');
                            },
                          )
                        : null,
                  ),
                ),
              ),

              // Body
              Expanded(
                child: vm.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : vm.errorMessage != null && vm.hospitals.isEmpty
                        ? _buildError(vm)
                        : _buildList(vm),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildError(HospitalViewModel vm) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(LucideIcons.alertCircle, color: Colors.red, size: 48),
          const SizedBox(height: 12),
          Text(vm.errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => vm.fetchHospitals(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildList(HospitalViewModel vm) {
    final list = vm.filteredHospitals;

    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.building2, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text('No hospitals found',
                style: TextStyle(color: Colors.grey[500], fontSize: 16)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => vm.fetchHospitals(),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final hospital = list[index] as Map<String, dynamic>;
          return _HospitalCard(hospital: hospital);
        },
      ),
    );
  }
}

class _HospitalCard extends StatelessWidget {
  final Map<String, dynamic> hospital;

  const _HospitalCard({required this.hospital});

  @override
  Widget build(BuildContext context) {
    final name = hospital['hospital_name']?.toString() ?? 'Unknown Hospital';
    final typeName =
        (hospital['hospital_type'] as Map?)?['name']?.toString() ?? '';
    final address = hospital['address']?.toString() ?? '';
    final phone = hospital['phone_number']?.toString() ??
        hospital['mobile_number']?.toString() ??
        '';
    final logoUrl = hospital['logo_image_url']?.toString() ?? '';
    final serviceTime = hospital['service_time']?.toString() ?? '';
    final isApproved =
        hospital['verification_status']?.toString() == 'Approved';

    Color typeColor;
    IconData typeIcon;
    switch (typeName.toLowerCase()) {
      case 'private hospital':
        typeColor = Colors.blue;
        typeIcon = LucideIcons.building2;
        break;
      case 'specialized hospital':
        typeColor = Colors.purple;
        typeIcon = LucideIcons.stethoscope;
        break;
      case 'government hospital':
        typeColor = Colors.green;
        typeIcon = LucideIcons.landmark;
        break;
      default:
        typeColor = AppColors.primaryTeal;
        typeIcon = LucideIcons.hospital;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo/icon
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: logoUrl.isNotEmpty
                ? Image.network(
                    logoUrl,
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        _buildIconFallback(typeColor, typeIcon),
                  )
                : _buildIconFallback(typeColor, typeIcon),
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
                    if (isApproved)
                      const Icon(LucideIcons.badgeCheck,
                          color: Colors.green, size: 18),
                  ],
                ),
                const SizedBox(height: 4),
                if (typeName.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: typeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(typeName,
                        style: TextStyle(
                            fontSize: 11,
                            color: typeColor,
                            fontWeight: FontWeight.w600)),
                  ),
                if (address.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(LucideIcons.mapPin,
                          size: 13, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ],
                if (phone.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(LucideIcons.phone,
                          size: 13, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(phone,
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                ],
                if (serviceTime.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(LucideIcons.clock,
                          size: 13, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          serviceTime,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconFallback(Color color, IconData icon) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 26),
    );
  }
}
