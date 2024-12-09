import 'dart:developer';
import '../model/MongoDBModel.dart';
import '../const/constant.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {
  static var db, userCollection;

  static connect() async {
    db = await Db.create(MONGO_CONN_URL);
    await db.open();
    inspect(db);
    userCollection = db.collection(USER_COLLECTION);
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final arrData = await userCollection.find().toList();
    return arrData;
  }

  static Future<String> insert(MongoDBModel data) async {
    try {
      var result = await userCollection.insertOne(data.toJson());
      if (result.isSucces) {
        return "Data Inserted";
      } else {
        return "Something Wrong while Inserting data.";
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }
}
