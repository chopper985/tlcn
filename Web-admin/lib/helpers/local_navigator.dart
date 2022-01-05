import 'package:flutter/cupertino.dart';
import 'package:tl_web_admin/constants/controllers.dart';
import 'package:tl_web_admin/routing/router.dart';
import 'package:tl_web_admin/routing/routes.dart';

Navigator localNavigator() =>   Navigator(
      key: navigationController.navigatorKey,
      onGenerateRoute: generateRoute,
      initialRoute: overviewPageRoute,
    );



