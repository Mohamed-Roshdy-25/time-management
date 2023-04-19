import 'package:flutter/material.dart';
import 'package:time_managing/services/theme_service.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  bool state = ThemeService().switchTheme;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _drawerHeader(),
          _drawerBody(),
        ],
      ),
    );
  }

  _drawerHeader() {
    return DrawerHeader(
      child: Column(
        children: [
          const Expanded(
              child: Image(image: AssetImage('assets/images/todo.png'))),
          Text(
            'App Settings',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }

  _drawerBody() {
    return Column(
      children: [
        const SizedBox(
          height: 30.0,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Dark Mode',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Switch(
                activeColor: Colors.red,
                value: state,
                onChanged: (value) {
                  setState(() {
                    state = value;
                  });
                  ThemeService().changeThemeMode();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
