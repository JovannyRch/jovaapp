import 'package:flutter/material.dart';
import 'package:jova_app/api/api.dart';
import 'package:jova_app/const/conts.dart';
import 'package:jova_app/models/CollectionCategory.dart';
import 'package:jova_app/screens/details_collection_category.dart';
import 'package:jova_app/screens/new_collection_category_screen.dart';
import 'package:jova_app/widgets/InfoCard.dart';

class CollectionCategoriesScreen extends StatefulWidget {
  @override
  _CollectionCategoriesScreenState createState() =>
      _CollectionCategoriesScreenState();
}

class _CollectionCategoriesScreenState
    extends State<CollectionCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text("Cobros"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewCollectionCategoryScreen()),
              ).then((value) {
                if (value != null) setState(() {});
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<CollectionCategory>>(
        future: Api.fetchCollectionCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return _noResults();
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return _itemCard(
                    snapshot.data![index], index == snapshot.data!.length - 1);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _itemCard(CollectionCategory category, bool isLast) {
    var gestureDetector = GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetailsCollectionCategory(categoryId: category.id!),
          ),
        ).then((value) {
          setState(() {});
        });
      },
      child: InfoCard(
        child: Row(
          children: [
            if (category.image != null)
              Image.network(
                category.image!,
                width: 35.0,
                height: 35.0,
                fit: BoxFit.cover,
              ),
            if (category.image == null)
              const SizedBox(
                width: 35.0,
                height: 35.0,
              ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      category.name!,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ]),
            ),
            const SizedBox(
              width: 50,
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 15.0,
              ),
            ),
          ],
        ),
      ),
    );

    if (!isLast) {
      return Column(
        children: [
          gestureDetector,
          const SizedBox(height: 10.0),
        ],
      );
    }
    return gestureDetector;
  }

  //No results found
  Widget _noResults() {
    return const Center(
      child: Text("No se encontraron resultados"),
    );
  }
}
