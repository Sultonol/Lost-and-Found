class Category {
  final int id;
  final String name;
  // (Tambahkan field lain jika ada, misal: icon_url)

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'], name: json['name']);
  }

  // Helper untuk mengubah list JSON menjadi List<Category>
  static List<Category> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Category.fromJson(json)).toList();
  }
}
