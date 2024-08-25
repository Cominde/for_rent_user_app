
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liliijar/generated/assets.dart';
import 'package:liliijar/layout/bottom_navbar_custom.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../cubit/cubit.dart';
import '../../cubit/states.dart';
import '../itemProfile/item_builder.dart';

class CategoryScreen extends StatefulWidget {
  String id;
  String title;
  CategoryScreen({super.key, required this.id, required this.title});
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  @override
  void initState() {
    cubit.get(context).getProducts(id: widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<cubit,States>(
      listener: (context, state) {
      },
      builder:(context, state) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,

              title: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  widget.title,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                    ),

                    child: TextFormField(

                      onFieldSubmitted: (value) {
                        cubit.get(context).searchProducts(searchQuery: value, categoryID: widget.id);
                      },
                      decoration: InputDecoration(
                        prefix: Icon(Icons.search_rounded),
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        hintText: "Search...",
                      ),


                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 50,);
                      },
                      itemCount: cubit.get(context).products.length,
                      itemBuilder: (context, index) {
                        return ItemBuilder(

                          id:cubit.get(context).products[index].id,
                          imageUrl: cubit.get(context).products[index].coverImage,
                          price: cubit.get(context).products[index].price,
                          title: cubit.get(context).products[index].title,

                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
        );
      },
    );
  }
}
