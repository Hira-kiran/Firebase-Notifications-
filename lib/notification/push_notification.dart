class PushNotification {
  PushNotification(
      {required this.title, required this.body, this.dataTitle, this.dataBody});

  String title;
  String body;
  String? dataTitle;
  String? dataBody;
}