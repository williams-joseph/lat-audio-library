import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_constants.dart';

void showUpdateModal(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.update, color: Colors.blue),
            SizedBox(width: 8),
            Text('App Information'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // App Version Info
              _buildInfoItem('App Version', 'v${AppConstants.appVersion}'),
              _buildInfoItem('Build Number', AppConstants.buildNumber),
              _buildInfoItem('Release Date', AppConstants.releaseDate),
              
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              
              const Text(
                'Features In Upcoming Updates',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 12),
              
              _buildFeatureItem('Audio Streaming', 'Listen to sermons directly in the app'),
              _buildFeatureItem('Push Notifications', 'Get notified when new sermons are available'),
              _buildFeatureItem('Offline Listening', 'Download and listen without internet'),
              _buildFeatureItem('Playback Controls', 'Play, pause, and seek through sermons'),
              
              const SizedBox(height: 16),
              const Text('Visit https://www.7thbasket.org for more content', style: TextStyle(fontWeight: FontWeight.bold),),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => launchUrl(Uri.parse('https://www.7thbasket.org')),
                child: const Text('Our Site'),
              ),
              const SizedBox(height: 16),

              const Text(
                'For now, you can only download sermons and listen using your preferred audio player.',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 16),
              
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Got It!'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
      );
    },
  );
}

Widget _buildFeatureItem(String title, String description) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          AppConstants.enableAudioStreaming ? Icons.check_circle : Icons.schedule,
          color: AppConstants.enableAudioStreaming ? Colors.green : Colors.orange,
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildInfoItem(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.blue,
          ),
        ),
      ],
    ),
  );
}