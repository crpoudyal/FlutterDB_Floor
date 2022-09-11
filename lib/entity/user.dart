import 'package:floor/floor.dart';

@Entity(tableName: 'user')
class User {
  @PrimaryKey(autoGenerate: true)
  final int id = 0;

  @ColumnInfo(name: 'firstname')
  final String? firstName;

  @ColumnInfo(name: 'lastname')
  final String? lastName;

  User(this.firstName, this.lastName);
}
