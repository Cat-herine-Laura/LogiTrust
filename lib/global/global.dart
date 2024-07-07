import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';


final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentUser;

UserModel? userModelCurrentInfo;

class UserModel {
  static UserModel? fromSnapshot(DataSnapshot snap) {
    return null;
  }
}
String userDropOffAddress = "";
