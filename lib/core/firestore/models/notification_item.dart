class NotificationItem {
  final String id;
  final String label;
  final String image;
  final bool isLocalAsset;
  final int order;

  NotificationItem({
    required this.id,
    required this.label,
    required this.image,
    required this.isLocalAsset,
    required this.order,
  });

  factory NotificationItem.fromMap(String id, Map<String, dynamic> data) {
    return NotificationItem(
      id: id,
      label: data['label'] ?? '',
      image: data['image'] ?? '',
      isLocalAsset: data['isLocalAsset'] ?? true,
      order: data['order'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'image': image,
      'isLocalAsset': isLocalAsset,
      'order': order,
    };
  }
}
