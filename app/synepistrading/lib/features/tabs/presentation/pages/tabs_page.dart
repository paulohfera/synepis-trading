import 'package:flutter/material.dart';

import '../../../ajuestes/presentation/ajustes_page.dart';
import '../../../dolar/presentation/dolar_page.dart';
import '../../../forex/presentation/forex_page.dart';
import '../../../indice/presentation/indice_page.dart';

class TabsPage extends StatefulWidget {
  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  List<Widget> _pages;
  int _selectedPage = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _pages = [
      ForexPage(),
      IndicePage(),
      DolarPage(),
      AjustesPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.euro_symbol),
            title: Text("Forex"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.equalizer),
            title: Text("Índice"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            title: Text("Dólar"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text("Ajustes"),
          ),
        ],
        showUnselectedLabels: true,
        currentIndex: _selectedPage,
        unselectedItemColor: Theme.of(context).primaryTextTheme.headline6.color,
        selectedItemColor: Colors.blueAccent,
        onTap: _selectPage,
      ),
    );
  }
}
