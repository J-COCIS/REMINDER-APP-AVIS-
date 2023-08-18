import 'package:flutter_application_demo/views/WeatherView.dart';
import 'package:flutter_application_demo/views/index.dart';
import 'package:flutter_application_demo/views/undefined_view.dart';
import 'package:flutter/material.dart';
import '../views/LocationReminder.dart';
import '../views/account_view.dart';
import '../views/reminders_search.dart';
import 'routing_constants.dart';

// The MaterialApp provides you with a property called onGenerateRoute where you can pass in a Function that returns a Route<dynamic> and takes in RouteSettings.
Route<dynamic> generateRoute(RouteSettings settings) {
  // The settings contain the route information of the requested route. It provides two key things to us: the name and the arguments.

  switch (settings.name) {
    case kIndexView:
      return MaterialPageRoute(builder: (_) => const IndexView());
    case kSetLocationView:
      return MaterialPageRoute(builder: (_) => SetLocationView());
    case kWeatherView:
      return MaterialPageRoute(builder: (_) => const WeatherPage());
    case kAccountView:
      return MaterialPageRoute(builder: (_) => const AccountView());
    case kSearchView:
      return MaterialPageRoute(builder: (_) => const RemindersSearch());

    default:
      return MaterialPageRoute(
        builder: (_) => UndefinedView(pageName: settings.name!),
      );
  }
}
