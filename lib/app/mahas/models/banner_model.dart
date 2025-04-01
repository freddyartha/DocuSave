class BannerModel {
  final int id;
  final String text;
  final String image;
  bool selected;

  BannerModel({
    required this.id,
    required this.text,
    required this.image,
    this.selected = false,
  });

  // Factory method untuk membuat instance dari Map (JSON)
  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      text: json['text'],
      image: json['image'],
      selected: json['selected'] ?? false,
    );
  }

  // Method untuk mengonversi objek BannerModel ke Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'image': image,
      'selected': selected,
    };
  }
}
