import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/sermon_provider.dart';
import '../../services/pwa_service.dart';

class InstallPrompt extends StatelessWidget {
  const InstallPrompt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.download, color: Colors.blue),
          SizedBox(width: 10),
          Text('Install App'),
        ],
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Install LAT Audio Library for better experience:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text('• Launch like a native app'),
          Text('• Works offline'),
          Text('• Faster loading'),
          Text('• No browser address bar'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Provider.of<SermonProvider>(context, listen: false).hideInstallPrompt();
          },
          child: const Text('Not Now'),
        ),
        ElevatedButton(
          onPressed: () async {
            final success = await PwaService.showInstallPrompt();
            if (success) {
              // ignore: use_build_context_synchronously
              Provider.of<SermonProvider>(context, listen: false).hideInstallPrompt();
            }
          },
          child: const Text('Install'),
        ),
      ],
    );
  }
}