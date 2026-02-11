import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';

class EditProfileScreen extends StatefulWidget {
  final String name;
  final String dob;
  final String gender;
  final String bloodGroup;
  final String height;
  final String weight;
  final String email;
  final String phone;
  final String address;

  const EditProfileScreen({
    super.key,
    required this.name,
    required this.dob,
    required this.gender,
    required this.bloodGroup,
    required this.height,
    required this.weight,
    required this.email,
    required this.phone,
    required this.address,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _dobController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  String _selectedGender = 'Male';
  String _selectedBloodGroup = 'O+';

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _dobController = TextEditingController(text: widget.dob);
    _heightController = TextEditingController(text: widget.height);
    _weightController = TextEditingController(text: widget.weight);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);
    _addressController = TextEditingController(text: widget.address);
    _selectedGender = widget.gender;
    _selectedBloodGroup = widget.bloodGroup;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTextField('Full Name', _nameController, LucideIcons.user),
            const SizedBox(height: 16),
            _buildTextField(
                'Date of Birth', _dobController, LucideIcons.calendar),
            const SizedBox(height: 16),
            _buildDropdown(
                'Gender', _selectedGender, _genders, LucideIcons.users, (val) {
              setState(() {
                _selectedGender = val!;
              });
            }),
            const SizedBox(height: 16),
            _buildDropdown('Blood Group', _selectedBloodGroup, _bloodGroups,
                LucideIcons.droplet, (val) {
              setState(() {
                _selectedBloodGroup = val!;
              });
            }),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    child: _buildTextField(
                        'Height', _heightController, LucideIcons.ruler)),
                const SizedBox(width: 16),
                Expanded(
                    child: _buildTextField(
                        'Weight', _weightController, LucideIcons.wheat)),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField('Email', _emailController, LucideIcons.mail,
                keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            _buildTextField('Phone', _phoneController, LucideIcons.phone,
                keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            _buildTextField('Address', _addressController, LucideIcons.mapPin),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final updatedData = {
                    'name': _nameController.text,
                    'dob': _dobController.text,
                    'gender': _selectedGender,
                    'bloodGroup': _selectedBloodGroup,
                    'height': _heightController.text,
                    'weight': _weightController.text,
                    'email': _emailController.text,
                    'phone': _phoneController.text,
                    'address': _addressController.text,
                  };
                  Navigator.pop(context, updatedData);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Save Changes',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, IconData icon,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primaryTeal, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.primaryTeal),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items,
      IconData icon, ValueChanged<String?> onChanged) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primaryTeal, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          isExpanded: true,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
