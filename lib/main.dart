import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:utibu_health_app/pages/home/patient.dart';
import 'package:utibu_health_app/pages/home/pharmacist.dart';
import 'package:utibu_health_app/pages/login_page.dart';

import 'providers/identity/Identityprovider.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => IdentityProvider()),
      ],
      builder: (context, _) {
        return const MyApp();
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Utibu Health',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ).copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: Colors.blue.shade50,
      ),
      debugShowCheckedModeBanner: false,
      home: Consumer<IdentityProvider>(
        builder: (context, identityProvider, child) {
          var isLoggedin = identityProvider.isLoggedIn;
          var role = identityProvider.role;

          return isLoggedin
              ? role == 'pharmacist'
                  ? const PharmacistHomePage()
                  : const PatientHomePage()
              : const LoginPage();
        },
      ),
    );
  }
}

