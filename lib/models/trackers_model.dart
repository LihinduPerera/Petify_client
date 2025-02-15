class TrackersModel {
  String trackerId;
  String trackerType;
  List<String> logs;

  TrackersModel({
    required this.trackerId,
    required this.trackerType,
    required this.logs
  });

  //convert firestore data  to model
  factory TrackersModel.fromJson(Map<String, dynamic> json) {
    return TrackersModel(
      trackerId: json['tracker_id'],
       trackerType: json['tracker_type'],
        logs: List<String>.from(json['logs'])
      );
  }

  //convert tracker model to json to save in firestore
  Map<String, dynamic> toJson() {
    return {
      'tracker_id': trackerId,
      'tracker_type': trackerType,
      'logs' : logs
    };
  }
}