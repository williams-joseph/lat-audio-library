import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class VersionBanner extends StatelessWidget {
  final bool showInAppBar;
  
  const VersionBanner({
    super.key,
    this.showInAppBar = false,
  });

  @override
  Widget build(BuildContext context) {
    if (showInAppBar) {
      return const Padding(
        padding: EdgeInsets.only(right: 8.0),
        child: Text(
          'v${AppConstants.appVersion}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      );
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.info_outline, size: 12, color: Colors.blue),
          SizedBox(width: 4),
          Text(
            'v${AppConstants.appVersion}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}