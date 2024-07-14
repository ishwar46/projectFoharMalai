class SpecialRequest {
  final String id;
  final String user;
  final String category;
  final String estimatedWaste;
  final String preferredTime;
  final String preferredDate;
  final String additionalInstructions;
  final String location;

  SpecialRequest({
    required this.id,
    required this.user,
    required this.category,
    required this.estimatedWaste,
    required this.preferredTime,
    required this.preferredDate,
    required this.additionalInstructions,
    required this.location,
  });

  factory SpecialRequest.fromJson(Map<String, dynamic> json) {
    return SpecialRequest(
      id: json['_id'],
      user: json['user'],
      category: json['category'],
      estimatedWaste: json['estimatedWaste'],
      preferredTime: json['preferredTime'],
      preferredDate: json['preferredDate'],
      additionalInstructions: json['additionalInstructions'] ?? '',
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'category': category,
      'estimatedWaste': estimatedWaste,
      'preferredTime': preferredTime,
      'preferredDate': preferredDate,
      'additionalInstructions': additionalInstructions,
      'location': location,
    };
  }
}
