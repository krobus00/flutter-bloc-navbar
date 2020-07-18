import 'package:navbar/bloc/navbar/navbar.dart';
import 'package:navbar/pages/pages.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Belajar Navbar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainView(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainView extends StatefulWidget {
  MainView({Key key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  // icon, name, page
  List pages = [
    [Icons.home, "Home", Home()],
    [Icons.pie_chart, "Chart", Sample()]
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: (MediaQuery.of(context).size.width <= 500)
          ? Drawer(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView(
                  children: pages.map((menu) {
                    return buildMobileMenu(context, menu[0], menu[1]);
                  }).toList(),
                ),
              ),
            )
          : null,
      appBar: AppBar(
        title: Text("Web Title"),
        centerTitle: false,
        actions: (MediaQuery.of(context).size.width > 500)
            ? pages.map((menu) {
                return buildWebMenu(menu[1]);
              }).toList()
            : [],
      ),
      body: StreamBuilder<String>(
        stream: bloc.getNavigation,
        // ignore: missing_return
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            for (var menu in pages) {
              if (snapshot.data == menu[1]) {
                return menu[2];
              }
            }
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Container buildMobileMenu(BuildContext context, IconData icon, String menu) {
    return Container(
      child: StreamBuilder<String>(
        stream: bloc.getNavigation,
        // ignore: missing_return
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return ListTile(
            tileColor: snapshot.data == menu ? Colors.blueAccent : Colors.white,
            title: Text(
              menu,
              style: TextStyle(
                color: snapshot.data == menu ? Colors.white : Colors.blueAccent,
              ),
            ),
            trailing: Icon(icon),
            onTap: () {
              Navigator.of(context).pop();
              bloc.setNavigation(menu);
            },
          );
        },
      ),
    );
  }

  FlatButton buildWebMenu(String menu) {
    return FlatButton(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            menu,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          StreamBuilder<String>(
            stream: bloc.getNavigation,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  height: 4,
                  width: 70,
                  color:
                      snapshot.data == menu ? Colors.white : Colors.transparent,
                ),
              );
            },
          ),
        ],
      ),
      onPressed: () {
        setState(() {
          bloc.setNavigation(menu);
        });
      },
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
