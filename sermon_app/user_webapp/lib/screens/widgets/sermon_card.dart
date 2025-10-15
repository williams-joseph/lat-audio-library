import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../../constants/app_constants.dart';

class SermonCard extends StatelessWidget {
  final Map<String, dynamic> sermon;

  const SermonCard({super.key, required this.sermon});

  void _downloadAudio() async {
    final downloadUrl = sermon['downloadUrl'] ?? '';
    if (downloadUrl.isEmpty) return;

    try {
      String directUrl = downloadUrl;
      if (downloadUrl.contains('drive.google.com')) {
        final fileId = _extractFileId(downloadUrl);
        if (fileId.isNotEmpty) {
          directUrl = 'https://drive.google.com/uc?export=download&id=$fileId';
        }
      }

      if (await canLaunchUrl(Uri.parse(directUrl))) {
        await launchUrl(
          Uri.parse(directUrl),
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      // Download error handled silently for now
    }
  }

  String _extractFileId(String url) {
    try {
      final uri = Uri.parse(url);
      final match = RegExp(r'/d/([a-zA-Z0-9_-]+)').firstMatch(url);
      if (match != null) return match.group(1)!;
      
      final idParam = uri.queryParameters['id'];
      if (idParam != null) return idParam;
      
      return '';
    } catch (e) {
      return '';
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateFormat('dd MMM yyyy').parse(dateString);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      try {
        final date = DateFormat('MMM dd yyyy').parse(dateString);
        return DateFormat('dd MMM yyyy').format(date);
      } catch (e) {
        try {
          final date = DateTime.parse(dateString);
          return DateFormat('dd MMM yyyy').format(date);
        } catch (e) {
          return dateString;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'images/listening-removebg-preview.png',
                  width: 60,
                  height: 60,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.audiotrack, size: 40, color: Colors.blue);
                  },
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sermon['title'] ?? 'No Title',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'By: ${sermon['preacher'] ?? 'Unknown Preacher'}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Date: ${_formatDate(sermon['date'] ?? '')}',
                        style: const TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 12,
                        ),
                      ),
                      if (sermon['duration']?.isNotEmpty ?? false) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Duration: ${sermon['duration']}',
                          style: const TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // Disabled Play button with tooltip
                Tooltip(
                  message: 'Audio streaming coming in v${AppConstants.upcomingUpdate}',
                  child: Opacity(
                    opacity: 0.5,
                    child: ElevatedButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Play'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: _downloadAudio,
                  icon: const Icon(Icons.download),
                  label: const Text('Download'),
                ),
                const Spacer(),
                if (sermon['storageType'] == 'google_drive')
                  const Row(
                    children: [
                      Icon(Icons.cloud, size: 16, color: Colors.green),
                      SizedBox(width: 4),
                      Text(
                        'Google Drive',
                        style: TextStyle(fontSize: 12, color: Colors.green),
                      ),
                    ],
                  ),
              ],
            ),
            
          ],
        ),
      ),
    );
  }
}