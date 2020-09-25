import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_nav_route/MyTheme.dart';
import 'package:app_nav_route/MyCart.dart';
import 'package:badges/badges.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (context) => MyCart(),
      ),
      ChangeNotifierProvider(
        create: (context) => MyTheme(),
      )
    ], child: AppWithTheme());
  }
}

class AppWithTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MyTheme myTheme = Provider.of<MyTheme>(context);
    return MaterialApp(
      theme: myTheme.themeData,
      home: Store(),
    );
  }
}

class Store extends StatelessWidget {
  final List<String> items = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 6"];
  final List<String> price = ["35", "11", "12", "13", "14"];
  @override
  Widget build(BuildContext context) {
    MyCart myCart = Provider.of<MyCart>(context);
    MyTheme myTheme = Provider.of<MyTheme>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("STORE"),
        leading: IconButton(
          icon: Icon(Icons.lightbulb_outline),
          onPressed: () {
            myTheme.changeTheme();
          },
        ),
        actions: <Widget>[
          Badge(
            shape: BadgeShape.circle,
            borderRadius: 100,
            position: BadgePosition.topEnd(
              top: -4,
              end: 0,
            ),
            animationDuration: Duration(milliseconds: 2500),
            animationType: BadgeAnimationType.scale,
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return ShoppingCart();
                  }),
                );
              },
            ),
            badgeContent: Text(
              myCart.list.length.toString(),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          String item = items[index];

          return ListTile(
            title: Text(item),
            subtitle: Text(price[index] + " " + "USD"),
            trailing: IconButton(
              icon: Icon(myCart.list.contains(item)
                  ? Icons.remove_shopping_cart
                  : Icons.add_shopping_cart),
              onPressed: () {
                if (myCart.list.contains(item)) {
                  myCart.removeItem(item);
                } else {
                  myCart.addItem(item);
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class ShoppingCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MyCart myCart = Provider.of<MyCart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Sepet / ${myCart.price} TRY"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              myCart.clearCart();
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: myCart.list.length,
        itemBuilder: (context, index) {
          String item = myCart.list[index];
          return ListTile(
            title: Text(item),
            trailing: IconButton(
              icon: Icon(Icons.remove_shopping_cart),
              onPressed: () {
                myCart.removeItem(item);
              },
            ),
          );
        },
      ),
    );
  }
}
