import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app.dart';

class AddEditStudentDialog extends StatefulWidget {
  const AddEditStudentDialog({super.key, this.student});

  final Student? student;

  @override
  State<AddEditStudentDialog> createState() => _AddEditStudentDialogState();
}

class _AddEditStudentDialogState extends State<AddEditStudentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _cityNameController = TextEditingController();
  final _avatarUrlController = TextEditingController();
  final _emojiController = TextEditingController(text: '👨‍🎓');

  String _sex = 'male'; // male or female
  DateTime? _selectedBirthdate;

  @override
  void initState() {
    super.initState();
    final student = widget.student;
    if (student != null) {
      _fullNameController.text = student.fullName;
      _firstNameController.text = student.firstName;
      _cityNameController.text = student.cityName ?? '';
      _avatarUrlController.text = student.avatarUrl;
      _emojiController.text = student.emoji ?? '👨‍🎓';
      _sex = student.sex ?? 'male';
      if (student.birthdate != null && student.birthdate!.isNotEmpty) {
        _selectedBirthdate = DateTime.tryParse(student.birthdate!);
      }
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _firstNameController.dispose();
    _cityNameController.dispose();
    _avatarUrlController.dispose();
    _emojiController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthdate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthdate ?? DateTime(2010),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Theme.of(context).primaryColor,
              brightness: Theme.of(context).brightness,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedBirthdate) {
      setState(() {
        _selectedBirthdate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colors;
    final isEdit = widget.student != null;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0.responsive()),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      insetPadding: EdgeInsets.all(16.0.responsive()),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
          maxWidth: 500.0.responsive(),
        ),
        padding: EdgeInsets.all(20.0.responsive()),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEdit ? 'Sửa Thông Tin Học Sinh' : 'Thêm Học Sinh Mới',
                    style: TextStyle(
                      fontSize: 20.0.responsive(),
                      fontWeight: FontWeight.bold,
                      color: colors.primaryTextColor,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              SizedBox(height: Dimens.d8.responsive()),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(
                        controller: _fullNameController,
                        label: 'Họ và tên',
                        hint: 'Nhập họ và tên học sinh',
                        validator: (v) => v == null || v.isEmpty
                            ? 'Vui lòng nhập họ và tên'
                            : null,
                      ),
                      SizedBox(height: Dimens.d12.responsive()),
                      _buildTextField(
                        controller: _firstNameController,
                        label: 'Tên gọi (First Name)',
                        hint: 'Ví dụ: Hưng',
                        validator: (v) => v == null || v.isEmpty
                            ? 'Vui lòng nhập tên gọi'
                            : null,
                      ),
                      SizedBox(height: Dimens.d12.responsive()),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Giới tính',
                                  style: TextStyle(
                                    fontSize: 13.0.responsive(),
                                    fontWeight: FontWeight.w500,
                                    color: colors.secondaryTextColor,
                                  ),
                                ),
                                SizedBox(height: Dimens.d6.responsive()),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Dimens.d12.responsive()),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        12.0.responsive()),
                                    border: Border.all(
                                        color: theme.primaryColor
                                            .withValues(alpha: 0.15)),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _sex,
                                      isExpanded: true,
                                      dropdownColor:
                                          theme.scaffoldBackgroundColor,
                                      style: TextStyle(
                                        color: colors.primaryTextColor,
                                        fontSize: 14.0.responsive(),
                                      ),
                                      items: const [
                                        DropdownMenuItem(
                                            value: 'male', child: Text('Nam')),
                                        DropdownMenuItem(
                                            value: 'female', child: Text('Nữ')),
                                      ],
                                      onChanged: (val) {
                                        if (val != null) {
                                          setState(() => _sex = val);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: Dimens.d12.responsive()),
                          Expanded(
                            child: _buildTextField(
                              controller: _emojiController,
                              label: 'Biểu tượng (Emoji)',
                              hint: 'Ví dụ: 👨‍🎓',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Dimens.d12.responsive()),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _cityNameController,
                              label: 'Thành phố',
                              hint: 'Ví dụ: Hà Nội',
                            ),
                          ),
                          SizedBox(width: Dimens.d12.responsive()),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ngày sinh',
                                  style: TextStyle(
                                    fontSize: 13.0.responsive(),
                                    fontWeight: FontWeight.w500,
                                    color: colors.secondaryTextColor,
                                  ),
                                ),
                                SizedBox(height: Dimens.d6.responsive()),
                                InkWell(
                                  onTap: () => _selectBirthdate(context),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Dimens.d12.responsive(),
                                      vertical: Dimens.d14.responsive(),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          12.0.responsive()),
                                      border: Border.all(
                                          color: theme.primaryColor
                                              .withValues(alpha: 0.15)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _selectedBirthdate == null
                                              ? 'Chọn ngày'
                                              : DateFormat('dd/MM/yyyy')
                                                  .format(_selectedBirthdate!),
                                          style: TextStyle(
                                            color: _selectedBirthdate == null
                                                ? colors.secondaryTextColor
                                                : colors.primaryTextColor,
                                            fontSize: 14.0.responsive(),
                                          ),
                                        ),
                                        Icon(Icons.calendar_today_outlined,
                                            size: 16.0.responsive(),
                                            color: colors.secondaryTextColor),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Dimens.d12.responsive()),
                      _buildTextField(
                        controller: _avatarUrlController,
                        label: 'Ảnh đại diện (Avatar URL)',
                        hint: 'Nhập URL ảnh đại diện',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: Dimens.d16.responsive()),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Hủy'),
                  ),
                  SizedBox(width: Dimens.d12.responsive()),
                  ElevatedButton(
                    onPressed: _onSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Xác nhận'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.0.responsive(),
            fontWeight: FontWeight.w500,
            color: colors.secondaryTextColor,
          ),
        ),
        SizedBox(height: Dimens.d6.responsive()),
        TextFormField(
          controller: controller,
          validator: validator,
          style: TextStyle(
              color: colors.primaryTextColor, fontSize: 14.0.responsive()),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: colors.secondaryTextColor),
            contentPadding: EdgeInsets.symmetric(
              horizontal: Dimens.d12.responsive(),
              vertical: Dimens.d12.responsive(),
            ),
          ),
        ),
      ],
    );
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final rawBirthdate = _selectedBirthdate != null
          ? _selectedBirthdate!.toIso8601String()
          : '';

      final rawMap = {
        if (widget.student?.id != null) 'id': widget.student!.id,
        'full_name': _fullNameController.text,
        'first_name': _firstNameController.text,
        'avatar_url': _avatarUrlController.text,
        'emoji': _emojiController.text,
        'sex': _sex,
        'city_name': _cityNameController.text,
        'birthdate': rawBirthdate,
      };

      final student = Student(
        id: widget.student?.id,
        firstName: _firstNameController.text,
        fullName: _fullNameController.text,
        avatarUrl: _avatarUrlController.text,
        emoji: _emojiController.text,
        sex: _sex,
        cityName: _cityNameController.text,
        birthdate: rawBirthdate,
        rawJson: rawMap,
      );

      Navigator.pop(context, student);
    }
  }
}
