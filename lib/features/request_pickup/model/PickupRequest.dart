class PickupRequest {
  String? id;
  String fullName;
  String phoneNumber;
  String address;
  String date;
  String time;
  Map<String, double> coordinates;
  String? userId;
  String? sessionId;

  PickupRequest({
    this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.address,
    required this.date,
    required this.time,
    required this.coordinates,
    this.userId,
    this.sessionId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'address': address,
      'date': date,
      'time': time,
      'coordinates': coordinates,
      'userId': userId,
      'sessionId': sessionId,
    };
    if (id != null) {
      data['_id'] = id;
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
      userId: json['userId'],
      sessionId: json['sessionId'],
    );
  }
}
