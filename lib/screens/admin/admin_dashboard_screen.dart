import 'package:flutter/material.dart';

import '../../data/services/supabase_service.dart';
import 'admin_upload_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await SupabaseService.client.auth.signOut();

    if (!context.mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _openUpload(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const AdminUploadScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F0),
      appBar: AppBar(
        title: const Text(
          'BookWorm • Admin Dashboard',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: const Color(0xFFF7F5F0),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'BOOKWORM',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2D211B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Library Administration',
                    style: TextStyle(fontSize: 17, color: Colors.black54),
                  ),
                  const SizedBox(height: 30),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount:
                        MediaQuery.of(context).size.width >= 800 ? 3 : 2,
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 18,
                    childAspectRatio: 1.25,
                    children: [
                      _AdminCard(
                        icon: Icons.add_box_rounded,
                        title: 'Add Book',
                        subtitle: 'Create a new book listing',
                        onTap: () => _openUpload(context),
                      ),
                      _AdminCard(
                        icon: Icons.picture_as_pdf_outlined,
                        title: 'Upload PDF',
                        subtitle: 'Upload a private digital book',
                        onTap: () => _openUpload(context),
                      ),
                      const _AdminCard(
                        icon: Icons.image_outlined,
                        title: 'Upload Cover',
                        subtitle: 'Cover management comes next',
                      ),
                      const _AdminCard(
                        icon: Icons.edit_outlined,
                        title: 'Edit Book',
                        subtitle: 'Catalogue editing comes next',
                      ),
                      const _AdminCard(
                        icon: Icons.delete_outline_rounded,
                        title: 'Delete Book',
                        subtitle: 'Catalogue deletion comes next',
                      ),
                      const _AdminCard(
                        icon: Icons.point_of_sale_outlined,
                        title: 'Sales / Purchases',
                        subtitle: 'Purchase management comes next',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AdminCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _AdminCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 42,
                color: const Color(0xFF5B3A29),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
