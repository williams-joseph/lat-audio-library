// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class UploadSermonScreen extends StatefulWidget {
  const UploadSermonScreen({super.key});

  @override
  State<UploadSermonScreen> createState() => _UploadSermonScreenState();
}

class _UploadSermonScreenState extends State<UploadSermonScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _preacherController = TextEditingController();
  final _dateController = TextEditingController();
  final _durationController = TextEditingController();
  final _fileIdController = TextEditingController();
  
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _dateController.text = _getTodayDate();
  }

  String _getTodayDate() {
    return DateFormat('dd MMM yyyy').format(DateTime.now());
  }

  Future<void> _saveSermon() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isUploading = true);

      try {
        final fileId = _fileIdController.text.trim();
        final downloadUrl = 'https://drive.google.com/uc?export=download&id=$fileId';
        
        await FirebaseFirestore.instance.collection('sermons').add({
          'title': _titleController.text.trim(),
          'preacher': _preacherController.text.trim(),
          'date': _dateController.text.trim(),
          'duration': _durationController.text.trim(),
          'fileId': fileId,
          'downloadUrl': downloadUrl,
          'storageType': 'google_drive',
          'uploadedAt': FieldValue.serverTimestamp(),
          'uploadedBy': FirebaseAuth.instance.currentUser!.email,
        });

        // Reset form
        _formKey.currentState!.reset();
        _dateController.text = _getTodayDate();
        _fileIdController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sermon Saved Successfully!'),
            backgroundColor: Colors.green,
          ),
        );

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error Saving Sermon: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => _isUploading = false);
      }
    }
  }

  void _showGoogleDriveInstructions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Google Drive Setup Instructions'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('To get Google Drive File ID:'),
              const SizedBox(height: 16),
              const Text('1. Upload audio file to Google Drive'),
              const Text('2. Right-click file → "Share"'),
              const Text('3. Set to "Anyone with the link can view"'),
              const Text('4. Copy the File ID from URL:'),
              const SizedBox(height: 8),
              const Text(
                '   https://drive.google.com/file/d/[FILE_ID]/view',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text('Example:'),
              const Text('URL: https://drive.google.com/file/d/abc123xyz/view'),
              const Text('File ID: abc123xyz'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => launchUrl(Uri.parse('https://drive.google.com')),
                child: const Text('Open Google Drive'),
              ),
              const SizedBox(height: 16),
              const Text('Important: Ensure audio files are already compressed', style: TextStyle(fontWeight: FontWeight.bold),),
              const Text('Use this link for best quality - https://www.onlineconverter.com/compress-mp3'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => launchUrl(Uri.parse('https://www.onlineconverter.com/compress-mp3')),
                child: const Text('Visit Site'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  // TODO: Uncomment when Firebase Storage is set up
  /*
  void _showFirebaseStorageInstructions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Firebase Storage Setup'),
        content: const Text('Firebase Storage will be implemented in the next update. This will provide better audio streaming capabilities.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  */

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add New Sermon',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // Storage Info Card
            Card(
              color: Colors.green[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.cloud, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          'Google Drive Storage',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('Audio files are stored in Google Drive for free.'),
                    // TODO: Uncomment when Firebase Storage is ready
                    /*
                    const SizedBox(height: 8),
                    const Text('Coming Soon: Firebase Storage for better streaming',
                      style: TextStyle(fontStyle: FontStyle.italic, color: Colors.blue)),
                    */
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: _showGoogleDriveInstructions,
                      icon: const Icon(Icons.help),
                      label: const Text('How to get File ID'),
                    ),
                    // TODO: Uncomment when Firebase Storage is ready
                    /*
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: _showFirebaseStorageInstructions,
                      icon: const Icon(Icons.storage),
                      label: const Text('Firebase Storage Info'),
                    ),
                    */
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Metadata Form
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Sermon Title *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _preacherController,
              decoration: const InputDecoration(
                labelText: 'Preacher *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Preacher\'s name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: 'Date (DD MMM YYYY) *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a date';
                }
                try {
                  DateFormat('dd MMM yyyy').parse(value);
                  return null;
                } catch (e) {
                  return 'Please use DD MMM YYYY format (e.g., 14 Oct 2025)';
                }
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _durationController,
              decoration: const InputDecoration(
                labelText: 'Duration (HH:MM:SS)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.timer),
                hintText: '00:30:15',
              ),
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _fileIdController,
              decoration: const InputDecoration(
                labelText: 'Google Drive File ID *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.link),
                hintText: 'abc123xyz',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Google Drive File ID';
                }
                return null;
              },
            ),

            // TODO: Uncomment when Firebase Storage is ready
            /*
            const SizedBox(height: 16),
            TextFormField(
              controller: _firebaseUrlController,
              decoration: const InputDecoration(
                labelText: 'Firebase Storage URL (Optional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.storage),
                hintText: 'Coming in next update',
              ),
              enabled: false,
            ),
            */
            
            const SizedBox(height: 30),
            
            Center(
              child: ElevatedButton(
                onPressed: _isUploading ? null : _saveSermon,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isUploading
                    ? const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 12),
                          Text('Saving...'),
                        ],
                      )
                    : const Text('Save Sermon to Database'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}