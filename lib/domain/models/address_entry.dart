class AddressEntry {
  final String name;
  final List<AddressEntry>? children;

  AddressEntry({required this.name, this.children});

  AddressEntry.fromJson(Map<String, dynamic> json) :
      name = json['name'],
      children = (json['children'] as List<dynamic>?)?.map((e) => AddressEntry.fromJson(e as Map<String, dynamic>)).toList();
}