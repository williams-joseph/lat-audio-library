class Sermon {
  final String id;
  final String title;
  final String preacher;
  final String date;
  final String duration;
  final String fileId;
  final String downloadUrl;
  final String storageType;
  final DateTime uploadedAt;
  final String uploadedBy;

  Sermon({
    required this.id,
    required this.title,
    required this.preacher,
    required this.date,
    required this.duration,
    required this.fileId,
    required this.downloadUrl,
    required this.storageType,
    required this.uploadedAt,
    required this.uploadedBy,
  });

  // Factory method to create Sermon from Firestore data
  factory Sermon.fromFirestore(Map<String, dynamic> data, String id) {
    return Sermon(
      id: id,
      title: data['title'] ?? '',
      preacher: data['preacher'] ?? '',
      date: data['date'] ?? '',
      duration: data['duration'] ?? '',
      fileId: data['fileId'] ?? '',
      downloadUrl: data['downloadUrl'] ?? '',
      storageType: data['storageType'] ?? 'google_drive',
      uploadedAt: (data['uploadedAt']).toDate(),
      uploadedBy: data['uploadedBy'] ?? '',
    );
  }
}