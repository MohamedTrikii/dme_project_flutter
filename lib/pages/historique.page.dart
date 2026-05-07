import 'package:flutter/material.dart';

import '../services/historique.service.dart';
import '../services/translation.service.dart';

class HistoriquePage extends StatefulWidget {
  const HistoriquePage({Key? key}) : super(key: key);

  @override
  State<HistoriquePage> createState() => _HistoriquePageState();
}

class _HistoriquePageState extends State<HistoriquePage> {
  List<String> historique = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    await HistoriqueService.resetUnreadCount();
    final history = await HistoriqueService.getHistorique();
    setState(() {
      historique = history;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TranslationService.getString('history')),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await HistoriqueService.clearHistorique();
              _loadHistory();
            },
          )
        ],
      ),
      body: historique.isEmpty
          ? Center(child: Text(TranslationService.getString('history_empty')))
          : ListView.builder(
              itemCount: historique.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(title: Text(historique[index])),
                );
              },
            ),
    );
  }
}
