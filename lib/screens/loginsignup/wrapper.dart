import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nourish_me/constants/Constants.dart';
import 'package:nourish_me/database/databaseuser.dart';
import 'package:nourish_me/screens/home/home_screen.dart';
import 'package:nourish_me/screens/loginsignup/login_page.dart';
import 'package:nourish_me/screens/onboarding/onboarding_screen.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Show loading indicator while waiting for auth state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Primary_green),
            );
          }
          
          // Check if user is logged in
          if (snapshot.hasData) {
            // User is logged in, check if onboarding is complete
            return FutureBuilder<bool>(
              future: UserDB().isOnboardingComplete(),
              builder: (context, onboardingSnapshot) {
                // Show loading indicator while fetching onboarding status
                if (onboardingSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: Primary_green),
                  );
                }
                
                // Check if onboarding is complete
                final bool isComplete = onboardingSnapshot.data ?? false;
                
                if (isComplete) {
                  // If onboarding is complete, refresh user data and go to home screen
                  UserDB().RefreshData();
                  return HomeScreen();
                } else {
                  // Check if user has existing data (as a fallback)
                  return FutureBuilder<List<String>>(
                    future: UserDB().getUserDetails(),
                    builder: (context, userDataSnapshot) {
                      if (userDataSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(color: Primary_green),
                        );
                      }
                      
                      // If user has data and it's not empty, consider onboarding complete
                      final hasData = userDataSnapshot.hasData && 
                                     userDataSnapshot.data!.isNotEmpty &&
                                     userDataSnapshot.data![0].isNotEmpty;
                      
                      if (hasData) {
                        // User has data but onboarding flag wasn't set
                        // Set it now and go to home screen
                        UserDB().setOnboardingComplete(true);
                        return HomeScreen();
                      } else {
                        // No data, go to onboarding
                        return OnboardingScreen();
                      }
                    },
                  );
                }
              },
            );
          } else {
            // User is not logged in, show login screen
            return LoginScreen();
          }
        },
      ),
    );
  }
}