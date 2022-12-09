class bluetoothID {
  const bluetoothID({required this.id, required this.name, required this.type});

  final String id;
  final String name;
  final int type;

  bluetoothID copy({
    String? id,
    String? name,
    int? type,
  }) =>
      bluetoothID(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
      );

  static bluetoothID fromJson(Map<String, dynamic> json) => bluetoothID(
        id: json['id'],
        name: json['name'],
        type: json['type'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
      };
}
