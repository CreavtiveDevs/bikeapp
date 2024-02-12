import 'package:bikeapp/models/bike.dart';
import 'package:bikeapp/screens/accident_waver_screen.dart';
import 'package:bikeapp/screens/add_bike_screen.dart';
import 'package:bikeapp/screens/create_account_screen.dart';
import 'package:bikeapp/screens/end_ride_screen.dart';
import 'package:bikeapp/screens/forgot_password.dart';
import 'package:bikeapp/screens/map_screen.dart';
import 'package:bikeapp/screens/sign_in_screen.dart';
import 'package:bikeapp/screens/privacy_policy_screen.dart';
import 'package:bikeapp/screens/terms_of_service_screen.dart';
import 'package:bikeapp/screens/timer_screen.dart';
import 'package:bikeapp/services/authentication_service.dart';
import 'package:bikeapp/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bikeapp/widgets/check_out_form.dart';
import 'package:bikeapp/widgets/map_view.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

Bike userBike;
DatabaseService databaseService;

class _AppState extends State<App> {
  final routes = {
    SignInScreen.routeName: (context) => SignInScreen(),
    ForgotPassword.routeName: (context) => ForgotPassword(),
    CreateAccountScreen.routeName: (context) => CreateAccountScreen(),
    MapScreen.routeName: (context) => MapScreen(),
    AccidentWaverScreen.routeName: (context) => AccidentWaverScreen(),
    AddBikeScreen.routeName: (context) => AddBikeScreen(),
    MapView.routeName: (context) => MapView(),
    EndRideScreen.routeName: (context) => EndRideScreen(),
    PrivacyPolicyScreen.routeName: (context) => PrivacyPolicyScreen(),
    TermsOfServiceScreen.routeName: (context) => TermsOfServiceScreen(),
    TimerScreen.routeName: (context) => TimerScreen(),
    CheckoutForm.routeName: (context) => CheckoutForm(),
  };

  @override
  void initState() {
    super.initState();
    databaseService = new DatabaseService();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
            create: (context) =>
                context.read<AuthenticationService>().authStateChanges,
            initialData: AuthenticationService(FirebaseAuth.instance).getUser())
      ],
      child: MaterialApp(
        title: 'Super Mean Biker Gang',
        theme: ThemeData(
          primaryColor: Colors.purple[600],
        ),
        debugShowCheckedModeBanner: false,
        routes: routes,
        home: AuthenticationWrapper(),
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    final user = AuthenticationService(FirebaseAuth.instance).getUser();

    if (firebaseUser != null && user.emailVerified) {
      Bike userBike;
      checkIfBike(userBike, firebaseUser);
      if (userBike == null) {
        return MapScreen();
      } else {
        return TimerScreen();
      }
    }
    return SignInScreen();
  }
}

Future<Bike> getUserBike(String userEmail) async {
  return await databaseService.getUsersBike(userEmail);
}

void checkIfBike(Bike checkoutBike, User user) async {
  checkoutBike = await databaseService.getUsersBike(user.email);
}
