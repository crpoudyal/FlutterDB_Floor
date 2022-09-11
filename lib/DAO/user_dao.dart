import 'package:floor/floor.dart';
import 'package:flutterdb/entity/user.dart';

@dao
abstract class UserDao {
  @Query('SELECT * FROM User')
  Stream<List<User>> findAllUser();

  @insert
  Future<void> insertUser(User user);

  @delete
  Future<void> deleteUser(User user);
}
