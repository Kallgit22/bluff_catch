import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../../../core/theme/app_themes.dart';
import '../../../../core/providers/settings_provider.dart';
import '../providers/profile_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late TextEditingController _usernameController;
  late TextEditingController _displayNameController;
  
  bool _isPrivate = false;
  String _currentAvatar = 'avatar_1';
  bool _isSaving = false;
  bool _isUploadingAvatar = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _displayNameController = TextEditingController();
    
    // Initial data load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileAsync = ref.read(profileProvider);
      if (profileAsync.value != null) {
        final profile = profileAsync.value!;
        setState(() {
          _usernameController.text = profile.username;
          _displayNameController.text = profile.displayName;
          _isPrivate = profile.isPrivate;
          _currentAvatar = profile.avatar;
        });
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    setState(() => _isSaving = true);
    
    final repo = ref.read(profileRepositoryProvider);
    final data = {
      'username': _usernameController.text.trim(),
      'displayName': _displayNameController.text.trim(),
      'isPrivate': _isPrivate,
      'avatar': _currentAvatar,
    };

    final result = await repo.updateProfile(user.uid, data);

    if (mounted) {
      setState(() => _isSaving = false);
      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.message)),
          );
        },
        (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
          context.pop();
        },
      );
    }
  }

  Future<void> _pickAndUploadAvatar() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() => _isUploadingAvatar = true);

    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Avatar',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(title: 'Crop Avatar'),
        ],
      );

      if (croppedFile != null) {
        final compressedXFile = await FlutterImageCompress.compressAndGetFile(
          croppedFile.path,
          '${croppedFile.path}_compressed.jpg',
          quality: 70,
          minWidth: 512,
          minHeight: 512,
        );

        if (compressedXFile != null) {
          final storageRepo = ref.read(storageRepositoryProvider);
          final result = await storageRepo.uploadAvatar(
            uid: user.uid,
            imageFile: File(compressedXFile.path),
          );

          result.fold(
            (failure) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Upload failed: ${failure.message}')),
                );
              }
            },
            (url) {
              if (mounted) {
                setState(() => _currentAvatar = url);
              }
            },
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error processing image: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploadingAvatar = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final themeConfig = AppThemes.getThemeById(settings.themeId);
    final colorScheme = themeConfig.themeData.colorScheme;

    ImageProvider? avatarImage;
    if (_currentAvatar.startsWith('http')) {
      avatarImage = NetworkImage(_currentAvatar);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('EDIT PROFILE'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(gradient: themeConfig.backgroundGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              child: Container(
                width: 500,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white24),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Avatar Picker
                    GestureDetector(
                      onTap: _isUploadingAvatar ? null : _pickAndUploadAvatar,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 48,
                            backgroundColor: colorScheme.primary,
                            backgroundImage: avatarImage,
                            child: avatarImage == null
                                ? const Icon(Icons.face, size: 64, color: Colors.white)
                                : null,
                          ),
                          if (_isUploadingAvatar)
                            const CircularProgressIndicator(color: Colors.white),
                          if (!_isUploadingAvatar)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.edit, color: Colors.black, size: 20),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    TextField(
                      controller: _displayNameController,
                      decoration: const InputDecoration(
                        labelText: 'Display Name',
                        prefixIcon: Icon(Icons.badge),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username (Unique)',
                        prefixIcon: Icon(Icons.alternate_email),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 32),

                    Material(
                      color: Colors.transparent,
                      child: SwitchListTile(
                        title: const Text('Private Profile', style: TextStyle(color: Colors.white)),
                        subtitle: const Text(
                          'Hide stats from other players',
                          style: TextStyle(color: Colors.white54),
                        ),
                        value: _isPrivate,
                        activeThumbColor: colorScheme.primary,
                        onChanged: (val) => setState(() => _isPrivate = val),
                      ),
                    ),
                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton(
                        onPressed: _isSaving ? null : _saveProfile,
                        child: _isSaving
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Text('SAVE CHANGES', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
