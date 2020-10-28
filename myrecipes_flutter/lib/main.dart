import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myrecipes_flutter/screens/entry/entry.dart';
import 'package:myrecipes_flutter/screens/home/home.dart';
import 'package:myrecipes_flutter/simple_bloc_observer.dart';

const HOSTNAME = "10.0.2.2:5000";
const PROTOCOL = "http";
final storage = FlutterSecureStorage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  runApp(Entry(authRepository: new AuthRepository(
      "$PROTOCOL://$HOSTNAME/api/auth/login",
      "$PROTOCOL://$HOSTNAME/api/auth/sign_up"
  ),));
}

