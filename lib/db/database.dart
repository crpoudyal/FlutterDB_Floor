import 'package:floor/floor.dart';
import 'package:flutterdb/DAO/user_dao.dart';
import 'package:flutterdb/entity/user.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';
part 'database.g.dart';

@Database(version: 1, entities: [User])
abstract class FlutterDatabase extends FloorDatabase {
  UserDao get userDao;
}
