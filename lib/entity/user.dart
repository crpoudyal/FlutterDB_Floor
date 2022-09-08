import 'package:floor/floor.dart';

@Entity(tableName: 'user')
class User {
  @PrimaryKey(autoGenerate: true)
  final int id;

  final String firstName;
  final String lastName;

  User(this.id, this.firstName, this.lastName);
}
