import 'package:mongo_dart/mongo_dart.dart';
import 'dart:convert';

List<MongoDBModel> mongoDBModelFromJson(String str) => List<MongoDBModel>.from(
    json.decode(str).map((x) => MongoDBModel.fromJson(x)));

String mongoDBModelToJson(List<MongoDBModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MongoDBModel {
  ObjectId id;
  String type;
  DateTime timestamp;
  String dayOfWeek;

  MongoDBModel({
    required this.id,
    required this.type,
    required this.timestamp,
    required this.dayOfWeek,
  });

  factory MongoDBModel.fromJson(Map<String, dynamic> json) => MongoDBModel(
        id: json["_id"],
        type: json["type"],
        timestamp: json["timestamp"] is DateTime
            ? json["timestamp"] // If it's already a DateTime, use it directly
            : DateTime.parse(json["timestamp"]), // Otherwise, parse it
        dayOfWeek: json["day_of_week"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "type": type,
        "timestamp": timestamp, // Just keep DateTime as it is
        "day_of_week": dayOfWeek,
      };
}
