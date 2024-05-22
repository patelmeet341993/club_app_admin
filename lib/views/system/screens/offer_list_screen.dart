

import 'package:club_app_admin/views/common/components/header_widget.dart';
import 'package:flutter/material.dart';

class OfferListScreen extends StatefulWidget {
  static const String routeName = "/OfferListScreen";
  const OfferListScreen({Key? key}) : super(key: key);

  @override
  State<OfferListScreen> createState() => _OfferListScreenState();
}

class _OfferListScreenState extends State<OfferListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderWidget(title: 'Offers',isBackArrow: true,),
        ],
      ),
    );
  }
}
