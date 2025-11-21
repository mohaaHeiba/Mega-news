class TopicSubscription {
  final String id; // عشان نعرف نحذفها (ممكن يكون نفس اسم الموضوع)
  final String topic; // كلمة البحث (مثلاً: Bitcoin)
  final String interval; // التكرار (2h, 6h, daily)
  final DateTime createdAt;

  TopicSubscription({
    required this.id,
    required this.topic,
    required this.interval,
    required this.createdAt,
  });

  // يفضل إضافة toJson و fromJson عشان التخزين المحلي (GetStorage)
}
