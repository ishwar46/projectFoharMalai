class PickupRequest {
  String? id; // Make ID nullable
  String fullName;
  String phoneNumber;
  String address;
  String date;
  String time;
  Map<String, double> coordinates;

  PickupRequest({
    this.id, // Now optional
    required this.fullName,
    required this.phoneNumber,
    required this.address,
    required this.date,
    required this.time,
    required this.coordinates,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'address': address,
      'date': date,
      'time': time,
      'coordinates': coordinates,
    };
    if (id != null) {
      data['_id'] = id; // Only include ID if it's not null
    }
    return data;
  }

  factory PickupRequest.fromJson(Map<String, dynamic> json) {
    return PickupRequest(
      id: json['_id'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      date: json['date'],
      time: json['time'],
      coordinates: {
        'lat': (json['coordinates']['lat'] as num).toDouble(),
        'lng': (json['coordinates']['lng'] as num).toDouble(),
      },
    );
  }
}
