import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AdminUploadScreen extends StatefulWidget {
  const AdminUploadScreen({super.key});

  @override
  State<AdminUploadScreen> createState() => _AdminUploadScreenState();
}

class _AdminUploadScreenState extends State<AdminUploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  final List<String> _categories = const [
    'Fiction',
    'Science',
    'Philosophy',
    'History',
    'Business',
    'Spirituality',
  ];

  String _category = 'Fiction';
  PlatformFile? _pdfFile;
  PlatformFile? _coverFile;
  Uint8List? _coverBytes;
  bool _publishing = false;

  Future<void> _pickPdf() async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (file != null) {
      setState(() => _pdfFile = file);
    }
  }

  Future<void> _pickCover() async {
    final file = await FilePicker.pickFile(type: FileType.image);

    if (file != null) {
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      setState(() {
        _coverFile = file;
        _coverBytes = bytes;
      });
    }
  }

  Future<void> _publishBook() async {
    if (!_formKey.currentState!.validate()) return;

    if (_pdfFile == null || _coverFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both the PDF book and cover image.'),
        ),
      );
      return;
    }

    setState(() => _publishing = true);
    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;
    setState(() => _publishing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Book details validated. Cloud publishing will be connected next.',
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin • Upload Book'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Add a new book',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Prepare the book for the private cloud catalogue.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              _field(
                controller: _titleController,
                label: 'Book title',
                icon: Icons.menu_book_outlined,
              ),
              const SizedBox(height: 14),
              _field(
                controller: _authorController,
                label: 'Author',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category_outlined),
                  border: OutlineInputBorder(),
                ),
                items: _categories
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _category = value);
                },
              ),
              const SizedBox(height: 14),
              _field(
                controller: _priceController,
                label: 'Price (ZAR)',
                icon: Icons.payments_outlined,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: 14),
              _field(
                controller: _descriptionController,
                label: 'Description',
                icon: Icons.description_outlined,
                maxLines: 5,
              ),
              const SizedBox(height: 22),
              _uploadTile(
                title: 'Digital book (PDF)',
                subtitle: _pdfFile?.name ?? 'Choose the customer PDF',
                icon: Icons.picture_as_pdf_outlined,
                onPressed: _pickPdf,
              ),
              const SizedBox(height: 12),
              _uploadTile(
                title: 'Cover image',
                subtitle: _coverFile?.name ?? 'Choose the book cover',
                icon: Icons.image_outlined,
                onPressed: _pickCover,
              ),
              if (_coverBytes != null) ...[
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.memory(
                    _coverBytes!,
                    height: 240,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
              const SizedBox(height: 26),
              SizedBox(
                height: 52,
                child: FilledButton.icon(
                  onPressed: _publishing ? null : _publishBook,
                  icon: _publishing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.cloud_upload_outlined),
                  label: Text(_publishing ? 'Preparing…' : 'Publish Book'),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Security note: paid PDFs will be stored privately. GitHub is only for the application code.',
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Required';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _uploadTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title),
        subtitle: Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: OutlinedButton(
          onPressed: onPressed,
          child: const Text('Choose'),
        ),
      ),
    );
  }
}
