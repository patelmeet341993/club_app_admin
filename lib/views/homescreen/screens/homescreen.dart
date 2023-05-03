import 'package:flutter/material.dart';

import '../../common/models/home_screen_component_model.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/HomeScreen";

  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ThemeData themeData;

  List<HomeScreenComponentModel> components = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return mainBody();
  }

  Widget mainBody(){
    return const Center(
      child: Text(
        "Home Screen"
      ),
    );
  }
}
