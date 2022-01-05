import 'package:flutter/material.dart';
import 'package:flutter_shop_application/providers/local.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatelessWidget {
  static const routeName = '/setting';
  @override
  Widget build(BuildContext context) {
    final local = Provider.of<Local>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Languages',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        actions: [
          IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                  'You are choosen ${local.isEnglish ? 'English' : 'Vietnamese'} !',
                  style: TextStyle(color: Colors.white),
                )));
              },
              icon: Icon(Icons.check, color: Colors.red))
        ],
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              local.changeLanguage();
            },
            leading: Icon(Icons.check,
                color: local.isEnglish ? Colors.white : Colors.red),
            title: Text('VietNamese'),
          ),
          ListTile(
            onTap: () {
              local.changeLanguage();
            },
            leading: Icon(Icons.check,
                color: !local.isEnglish ? Colors.white : Colors.red),
            title: Text('English'),
          ),
        ],
      ),
    );
  }
}
