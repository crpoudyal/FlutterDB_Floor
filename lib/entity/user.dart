import 'package:floor/floor.dart';

@Entity(tableName: 'user')
class User {
  @PrimaryKey(autoGenerate: true)
  final int id;

  @ColumnInfo(name: 'firstname')
  final String firstName;

  @ColumnInfo(name: 'lastname')
  final String lastName;

  User(this.id, this.firstName, this.lastName);
}
