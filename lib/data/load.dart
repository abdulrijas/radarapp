// load.dart
import '../dbHelper/mongodb.dart';
import '../model/MongoDBModel.dart';

class DataLoader {
  // Singleton instance
  static final DataLoader _instance = DataLoader._internal();

  factory DataLoader() => _instance;

  DataLoader._internal();

  bool isLoading = true;
  List<MongoDBModel> mongoData = [];

  Future<void> initializeData() async {
    if (mongoData.isEmpty) {
      await _loadMongoData();
    }
  }

  Future<void> _loadMongoData() async {
    try {
      final dbData = await MongoDatabase.getData();
      mongoData = dbData.map((e) => MongoDBModel.fromJson(e)).toList();
      isLoading = false;
    } catch (e) {
      isLoading = false;
      print("Error loading MongoDB data: $e");
    }
  }
}
