import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_dinner/providers/auth.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: ListView(
          children: ListTile.divideTiles(context: context, tiles: [
            ListTile(
              leading: Text(
                'Account',
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(fontWeight: FontWeight.normal),
              ),
              trailing: Text('${Provider.of<Auth>(context).email}',
                  style: Theme.of(context).textTheme.bodyText2),
            ),
            // SwitchListTile(
            //   title: Text(
            //     'Dark Theme',
            //     style: Theme.of(context)
            //         .textTheme
            //         .headline4
            //         .copyWith(fontWeight: FontWeight.normal),
            //   ),
            //   value: _isSwitched,
            //   onChanged: (value) {
            //     setState(() {
            //       _isSwitched = !_isSwitched;
            //     });
            //   },
            //   activeTrackColor: Colors.green,
            // ),
            ListTile(
                leading: Text('Log out',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .copyWith(fontWeight: FontWeight.normal)),
                onTap: () {
                  Provider.of<Auth>(context, listen: false).logout();
                  Navigator.of(context).pop();
                }),
          ]).toList(),
        ),
      ),
    );
  }
}
