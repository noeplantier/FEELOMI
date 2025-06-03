import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'dart:async';

import '../../providers/auth_provider.dart';
import '../../models/user_profile.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/feelomi_button.dart';
import '../../widgets/profile/settings_section.dart';
import '../../widgets/profile/subscription_card.dart';
import '../../widgets/profile/profile_menu_item.dart';
import '../../services/analytics_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _picker = ImagePicker();
  File? _imageFile;
  bool _hasChanges = false;
  late Future<void> _profileLoadFuture;
  late FocusNode _nameFocusNode;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _profileLoadFuture = _loadUserProfile();
    _nameFocusNode = FocusNode();
    
    // Analytics
    AnalyticsService().logScreenView('profile_screen');
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.loadUserProfile();
    
    if (mounted) {
      _nameController.text = authProvider.currentUser?.displayName ?? '';
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      
      if (pickedFile != null && mounted) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _hasChanges = true;
        });
        HapticFeedback.mediumImpact();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la sélection de l\'image: $e')),
        );
      }
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (!_hasChanges) {
      // No changes to save
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.updateProfile(
        displayName: _nameController.text,
        profileImage: _imageFile,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil mis à jour avec succès')),
        );
        setState(() => _hasChanges = false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la mise à jour du profil: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );
    
    if (confirm == true) {
      setState(() => _isLoading = true);
      
      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.signOut();
        
        if (mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(Routes.login, (route) => false);
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur lors de la déconnexion: $e')),
          );
        }
      }
    }
  }
  
  Future<void> _deleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le compte'),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer définitivement votre compte ? Cette action est irréversible et toutes vos données seront perdues.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    
    if (confirm == true) {
      // Double confirmation for account deletion
      final secondConfirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirmation de suppression'),
          content: const Text(
            'Veuillez confirmer à nouveau que vous souhaitez supprimer votre compte et toutes vos données associées.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Annuler'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Je confirme la suppression'),
            ),
          ],
        ),
      );
      
      if (secondConfirm == true) {
        setState(() => _isLoading = true);
        
        try {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          await authProvider.deleteAccount();
          
          if (mounted) {
            Navigator.of(context).pushNamedAndRemoveUntil(Routes.login, (route) => false);
          }
        } catch (e) {
          if (mounted) {
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erreur lors de la suppression du compte: $e')),
            );
          }
        }
      }
    }
  }
  
  void _shareApp() {
    Share.share(
      'Découvrez Feelomi, une application pour suivre et améliorer votre bien-être émotionnel! Téléchargez-la ici: https://feelomi.app',
      subject: 'Feelomi - Bien-être émotionnel',
    );
  }
  
  Future<void> _contactSupport() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@feelomi.com',
      query: 'subject=Support Feelomi&body=',
    );
    
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible d\'ouvrir l\'application email')),
        );
      }
    }
  }

  Widget _buildProfileTab(UserProfile? userProfile) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Form(
          key: _formKey,
          onChanged: () {
            if (!_hasChanges) {
              setState(() => _hasChanges = true);
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile picture
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      backgroundImage: _getProfileImage(userProfile),
                      child: _getProfileImagePlaceholder(userProfile),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Profile name
              TextFormField(
                controller: _nameController,
                focusNode: _nameFocusNode,
                decoration: InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Veuillez entrer votre nom';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Email (non-editable)
              TextFormField(
                initialValue: userProfile?.email ?? '',
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.email_outlined),
                  filled: true,
                ),
                enabled: false,
              ),
              
              const SizedBox(height: 32),
              
              // Premium subscription status
              SubscriptionCard(
                isPremium: userProfile?.isPremium ?? false,
                expiryDate: userProfile?.premiumExpiry,
                onSubscribe: () {
                  Navigator.of(context).pushNamed(Routes.subscription);
                },
              ),
              
              const SizedBox(height: 32),
              
              // Update profile button
              AnimatedOpacity(
                opacity: _hasChanges ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: FeelomiButton(
                  onPressed: _hasChanges ? _updateProfile : null,
                  text: 'Enregistrer les modifications',
                  isLoading: _isLoading,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTab() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        SettingsSection(
          title: 'Préférences',
          children: [
            ProfileMenuItem(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              onTap: () {
                Navigator.of(context).pushNamed(Routes.notifications);
              },
            ),
            ProfileMenuItem(
              icon: Icons.color_lens_outlined,
              title: 'Thème',
              onTap: () {
                _showThemeSelector();
              },
            ),
            ProfileMenuItem(
              icon: Icons.language_outlined,
              title: 'Langue',
              onTap: () {
                _showLanguageSelector();
              },
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        SettingsSection(
          title: 'Sécurité et données',
          children: [
            ProfileMenuItem(
              icon: Icons.lock_outline,
              title: 'Changer le mot de passe',
              onTap: () {
                Navigator.of(context).pushNamed(Routes.changePassword);
              },
            ),
            ProfileMenuItem(
              icon: Icons.privacy_tip_outlined,
              title: 'Confidentialité',
              onTap: () {
                Navigator.of(context).pushNamed(Routes.privacy);
              },
            ),
            ProfileMenuItem(
              icon: Icons.download_outlined,
              title: 'Exporter mes données',
              onTap: () {
                _exportUserData();
              },
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        SettingsSection(
          title: 'Aide et information',
          children: [
            ProfileMenuItem(
              icon: Icons.help_outline,
              title: 'Centre d\'aide',
              onTap: () {
                Navigator.of(context).pushNamed(Routes.help);
              },
            ),
            ProfileMenuItem(
              icon: Icons.support_agent_outlined,
              title: 'Contacter le support',
              onTap: _contactSupport,
            ),
            ProfileMenuItem(
              icon: Icons.share_outlined,
              title: 'Partager l\'application',
              onTap: _shareApp,
            ),
            ProfileMenuItem(
              icon: Icons.info_outline,
              title: 'À propos',
              onTap: () {
                Navigator.of(context).pushNamed(Routes.about);
              },
            ),
          ],
        ),
        
        const SizedBox(height: 32),
        
        // Logout button
        FeelomiButton(
          onPressed: _logout,
          text: 'Déconnexion',
          color: Colors.grey.shade200,
          textColor: Colors.black87,
          icon: Icons.logout,
        ),
        
        const SizedBox(height: 16),
        
        // Delete account button
        TextButton(
          onPressed: _deleteAccount,
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          child: const Text('Supprimer mon compte'),
        ),
        
        const SizedBox(height: 32),
      ],
    );
  }

  void _showThemeSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Choisir un thème',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.brightness_auto),
              title: const Text('Système'),
              onTap: () {
                // Set theme to system
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.light_mode),
              title: const Text('Clair'),
              onTap: () {
                // Set theme to light
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Sombre'),
              onTap: () {
                // Set theme to dark
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Choisir une langue',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              title: const Text('Français'),
              leading: const Text('🇫🇷'),
              onTap: () {
                // Set language to French
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('English'),
              leading: const Text('🇬🇧'),
              onTap: () {
                // Set language to English
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Español'),
              leading: const Text('🇪🇸'),
              onTap: () {
                // Set language to Spanish
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportUserData() async {
    // This would connect to your actual data export functionality
    setState(() => _isLoading = true);
    
    try {
      // Simulate export delay
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vos données ont été exportées avec succès')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'export: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  ImageProvider? _getProfileImage(UserProfile? userProfile) {
    if (_imageFile != null) {
      return FileImage(_imageFile!);
    } else if (userProfile?.photoUrl != null && userProfile!.photoUrl!.isNotEmpty) {
      return CachedNetworkImageProvider(userProfile.photoUrl!);
    }
    return null;
  }

  Widget? _getProfileImagePlaceholder(UserProfile? userProfile) {
    if (_imageFile != null || (userProfile?.photoUrl != null && userProfile!.photoUrl!.isNotEmpty)) {
      return null;
    }
    
    final initials = userProfile?.displayName?.isNotEmpty == true 
        ? userProfile!.displayName!.split(' ').map((e) => e.isNotEmpty ? e[0] : '').join().toUpperCase()
        : '?';
    
    return Text(
      initials,
      style: const TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('Profil'),
        centerTitle: true,
      ),
      body: FutureBuilder<void>(
        future: _profileLoadFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final userProfile = Provider.of<AuthProvider>(context).currentUser;
          
          return Column(
            children: [
              TabBar(
                controller: _tabController,
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                indicatorColor: Theme.of(context).colorScheme.primary,
                tabs: const [
                  Tab(text: 'Profile'),
                  Tab(text: 'Paramètres'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildProfileTab(userProfile),
                    _buildSettingsTab(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}