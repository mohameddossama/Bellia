class ItemDetails {
  final String itemName;
  final String itemPrice;
  final String imagePath;
  bool isSelected;

  ItemDetails({
    required this.itemName,
    required this.itemPrice,
    required this.imagePath,
    this.isSelected = false,
  });
}