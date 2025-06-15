class Item {
  final String id;
  final String name;
  final double price;
  int stock;

  Item({
    required this.id,
    required this.name,
    required this.price,
    this.stock = 0,
  });
}
