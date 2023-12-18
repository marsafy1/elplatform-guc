import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/services/route_observer_service.dart';

class LostAndFoundsPage extends StatefulWidget {
  const LostAndFoundsPage({super.key});

  @override
  State<LostAndFoundsPage> createState() => _LostAndFoundsPageState();
}

class _LostAndFoundsPageState extends State<LostAndFoundsPage> {
  @override
  void initState() {
    RouteObserverService().logUserActivity('/lost_and_founds');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Text("Lost And Founds Page");
  }
}
