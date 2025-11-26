import 'package:aiwriting_collection/api.dart';
import 'package:aiwriting_collection/model/language_provider.dart';
import 'package:aiwriting_collection/model/login_status.dart';
import 'package:aiwriting_collection/model/typeEnum.dart';
import 'package:aiwriting_collection/model/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:aiwriting_collection/generated/app_localizations.dart';
import 'package:provider/provider.dart';

class EditProfileDialog extends StatefulWidget {
  final UserProfile profile;
  final int userId;

  const EditProfileDialog({
    super.key,
    required this.profile,
    required this.userId,
  });

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late final TextEditingController _nicknameController;
  late DateTime _selectedDate;
  late UserType _selectedUserType;
  bool _isUpdating = false;
  final Api _api = Api();

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController(text: widget.profile.nickname);
    _selectedDate = widget.profile.birthdate;
    _selectedUserType = widget.profile.userType;
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  String _getUserTypeName(UserType type, AppLocalizations appLocalizations) {
    switch (type) {
      case UserType.CHILD:
        return appLocalizations.userTypeChild;
      case UserType.ADULT:
        return appLocalizations.userTypeAdult;
      case UserType.FOREIGN:
        return appLocalizations.userTypeForeign;
    }
  }

  Future<void> _handleUpdate() async {
    if (_isUpdating) return;

    setState(() {
      _isUpdating = true;
    });

    final update = UpdateProfile(
      nickname: _nicknameController.text,
      birthdate: _selectedDate,
      userType: _selectedUserType,
    );

    bool success = false;
    try {
      await _api.updateProfile(update, widget.userId);
      success = true;

      context.read<LoginStatus>().updateUserType(_selectedUserType);

      // Language change logic
      final languageProvider = Provider.of<LanguageProvider>(
        context,
        listen: false,
      );
      if (_selectedUserType == UserType.FOREIGN) {
        languageProvider.changeLanguage(const Locale('en'));
      } else {
        languageProvider.changeLanguage(const Locale('ko'));
      }
    } catch (e) {
      print('Profile update failed: $e');
      success = false;
    }

    if (mounted) {
      Navigator.of(context).pop(success);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final dialogWidth =
        isPortrait ? screenSize.width * 0.8 : screenSize.width * 0.5;

    final double basePortrait = 390.0;
    final double baseLandscape = 844.0;
    final double scale =
        isPortrait
            ? screenSize.width / basePortrait
            : screenSize.height / baseLandscape;
    final appLocalizations = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(
        appLocalizations.editProfileTitle,
        style: TextStyle(fontSize: 20 * scale),
      ),
      content: SizedBox(
        width: dialogWidth,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nicknameController,
                style: TextStyle(fontSize: 18 * scale),
                decoration: InputDecoration(
                  labelText: appLocalizations.nickname,
                  labelStyle: TextStyle(fontSize: 20 * scale),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    '${appLocalizations.birthdate}${_selectedDate.toLocal()}'
                        .split(' ')[0],
                    style: TextStyle(fontSize: 20 * scale),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null && picked != _selectedDate) {
                        setState(() {
                          _selectedDate = picked;
                        });
                      }
                    },
                  ),
                ],
              ),
              DropdownButtonFormField<UserType>(
                value: _selectedUserType,
                style: TextStyle(fontSize: 18 * scale, color: Colors.black87),
                decoration: InputDecoration(
                  labelText: appLocalizations.userType,
                  labelStyle: TextStyle(fontSize: 20 * scale),
                ),
                items:
                    UserType.values.map((UserType type) {
                      return DropdownMenuItem<UserType>(
                        value: type,
                        child: Text(
                          _getUserTypeName(type, appLocalizations),
                          style: TextStyle(fontSize: 20 * scale),
                        ),
                      );
                    }).toList(),
                onChanged: (UserType? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedUserType = newValue;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            appLocalizations.cancel,
            style: TextStyle(color: Colors.black87, fontSize: 20 * scale),
          ),
        ),
        TextButton(
          onPressed: _handleUpdate,
          child:
              _isUpdating
                  ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : Text(
                    appLocalizations.save,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20 * scale,
                    ),
                  ),
        ),
      ],
    );
  }
}
