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
}
