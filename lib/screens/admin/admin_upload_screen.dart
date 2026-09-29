import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../data/services/book_service.dart';
import '../../data/services/storage_service.dart';

class AdminUploadScreen extends StatefulWidget {
  const AdminUploadScreen({super.key});

  @override
  State<AdminUploadScreen> createState() => _AdminUploadScreenState();
}

class _AdminUploadScreenState extends State<AdminUploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _priceController = TextEditingController(text: '0');
  final _descriptionController = TextEditingController();

  final _bookService = BookService();

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
  Uint8List? _pdfBytes;
  bool _publishing = false;

  Future<void> _pickPdf() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.single;
    final bytes = file.bytes ?? await file.readAsBytes();

    if (!mounted) return;

    setState(() {
      _pdfFile = file;
      _pdfBytes = bytes;
    });
  }

  Future<void> _publishBook() async {
    if (!_formKey.currentState!.validate()) return;

    if (_pdfFile == null || _pdfBytes == null) {
      _showMessage('Please choose the PDF book before publishing.');
      return;
    }

    final price = double.tryParse(_priceController.text.trim());
    if (price == null || price < 0) {
      _showMessage('Enter a valid price in ZAR.');
      return;
    }

    setState(() => _publishing = true);

    String? uploadedPath;

    try {
      uploadedPath = await StorageService.uploadBookPdf(
        bytes: _pdfBytes!,
        fileName: _pdfFile!.name,
      );

      await _bookService.createBook(
        title: _titleController.text,
        author: _authorController.text,
        category: _category,
        description: _descriptionController.text,
        priceZar: price,
        pdfPath: uploadedPath,
      );

      if (!mounted) return;

      _showMessage('Book uploaded and published successfully.');

      setState(() {
        _pdfFile = null;
        _pdfBytes = null;
        _titleController.clear();
        _authorController.clear();
        _priceController.text = '0';
        _descriptionController.clear();
        _category = _categories.first;
      });
    } catch (error) {
      if (uploadedPath != null) {
        try {
          await StorageService.deleteBookPdf(uploadedPath);
        } catch (_) {}
      }

      if (mounted) {
        _showMessage('Upload failed: ' + error.toString());
      }
    } finally {
      if (mounted) setState(() => _publishing = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
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
        title: const Text('BookWorm • Library Admin'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Add book to library',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Upload the PDF and create its catalogue record in Supabase.',
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
                onChanged: _publishing
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() => _category = value);
                        }
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
                subtitle: _pdfFile?.name ?? 'Choose the PDF to upload',
                icon: Icons.picture_as_pdf_outlined,
                onPressed: _publishing ? () {} : _pickPdf,
              ),
              if (_pdfFile != null) ...[
                const SizedBox(height: 10),
                Text(
                  _pdfFile!.name + ' • ' + _formatBytes(
                    _pdfBytes?.length ?? _pdfFile!.size,
                  ),
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
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
                  label: Text(
                    _publishing ? 'Uploading PDF…' : 'Upload & Publish Book',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'PDF files are stored in the private Supabase “books” bucket. Do not put paid books in GitHub.',
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
      enabled: !_publishing,
      validator: (value) {
        if (value == null || value.trim().isEmpty) return 'Required';
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
          child: const Text('Choose PDF'),
        ),
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return bytes.toString() + ' B';
    if (bytes < 1024 * 1024) {
      return (bytes / 1024).toStringAsFixed(1) + ' KB';
    }
    return (bytes / (1024 * 1024)).toStringAsFixed(1) + ' MB';
  }
}
