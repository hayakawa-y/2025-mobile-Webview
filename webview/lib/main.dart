import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'favorites_model.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => FavoritesModel(),
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Favorite List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const FavoritesPage(),
    );
  }
}


class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite List'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          return ItemTile(itemNo: index);
        },
      ),
    );
  }
}


class ItemTile extends StatelessWidget {
  final int itemNo;

  const ItemTile({super.key, required this.itemNo});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Item #$itemNo'),
      trailing: Consumer<FavoritesModel>(
        builder: (context, favorites, child) {
          final isFavorite = favorites.isFavorite(itemNo);
          return IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              favorites.toggleFavorite(itemNo);
            },
          );
        },
      ),
    );
  }
}
