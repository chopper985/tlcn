import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tl_web_admin/helpers/local_navigator.dart';
import 'package:tl_web_admin/helpers/reponsiveness.dart';
import 'package:tl_web_admin/providers/user.dart';
import 'package:tl_web_admin/widgets/large_screen.dart';
import 'package:tl_web_admin/widgets/side_menu.dart';

import 'widgets/top_nav.dart';

class SiteLayout extends StatefulWidget {
  @override
  State<SiteLayout> createState() => _SiteLayoutState();
}

class _SiteLayoutState extends State<SiteLayout> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  bool _isLoading = false;
  bool _isInit = true;
  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      _isLoading = true;
      Provider.of<User>(context, listen: false)
          .getUser()
          .then((_) => _isLoading = false);
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: topNavigationBar(context, scaffoldKey),
      drawer: Drawer(
        child: SideMenu(),
      ),
      body:  ResponsiveWidget(
              largeScreen: LargeScreen(),
              smallScreen: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: localNavigator(),
              )),
    );
  }
}
