class Store {
  final int id;
  final String name;
  final double? longitude;
  final double? latitude;
  final double? distance;
  final int? user_id; 

  Store({
    required this.id,
    required this.name,
    this.longitude,
    this.latitude,
    this.distance,
    this.user_id,
  });

  Store copyWith({
    int? id,
    String? name,
    double? longitude,
    double? latitude,
    double? distance,
    int? user_id,
  }) {
    return Store(
      id: id ?? this.id, 
      name: name ?? this.name, 
      longitude: longitude ?? this.longitude,  
      latitude: latitude ?? this.latitude,  
      distance: distance ?? this.distance,  
      user_id: user_id ?? this.user_id,  
    );
  }

  factory Store.fromMap(Map<String, dynamic> map) {
    return Store(
      id: map['id'],
      name: map['name'],
      longitude: map['longitude'],
      latitude: map['latitude'],
      distance: map['distance'],
      user_id: map['user_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'longitude': longitude,
      'latitude': latitude,
      'distance': distance,
      'user_id': user_id,
    };
  }
}
