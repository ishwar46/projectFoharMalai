class PickupRequest {
  String fullName;
  String phoneNumber;
  String address;
  String date;
  String time;
  Map<String, double> coordinates;

  PickupRequest({
    required this.fullName,
    required this.phoneNumber,
    required this.address,
    required this.date,
    required this.time,
    required this.coordinates,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'address': address,
      'date': date,
      'time': time,
      'coordinates': coordinates,
    };
  }

  factory PickupRequest.fromJson(Map<String, dynamic> json) {
    return PickupRequest(
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      date: json['date'],
      time: json['time'],
      coordinates: Map<String, double>.from(json['coordinates']),
    );
  }
}
