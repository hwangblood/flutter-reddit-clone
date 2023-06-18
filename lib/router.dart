import 'package:flutter/material.dart';

import 'package:routemaster/routemaster.dart';

import 'package:reddit_clone/features/auth/screens/login_screen.dart';

// loggedOut
// loggedIn

final loggedOutRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(
          child: LoginScreen(),
        ),
  },
);
