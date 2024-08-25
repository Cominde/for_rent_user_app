import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liliijar/models/category_model.dart';

import '../../cubit/cubit.dart';
import '../../cubit/states.dart';
import '../../db/db.dart';
import '../../models/product_model.dart';

class AddNewItem extends StatefulWidget {
  @override
  _AddNewItemState createState() => _AddNewItemState();


}

class _AddNewItemState extends State<AddNewItem> {

  @override
  void initState() {
    super.initState();
    cubit.get(context).images.clear();
    cubit.get(context).getCategories();




  }

  final _formKey = GlobalKey<FormState>();

  var productTitleController = TextEditingController();
  var productDescriptionController = TextEditingController();
  var productPriceController = TextEditingController();
  var productTermsController = TextEditingController();
  var productCategoryIDController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<cubit, States>(
      listener: (context, state) {},
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: productTitleController,
                        decoration: InputDecoration(
                          labelText: 'Product Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter product name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: productDescriptionController,
                        decoration: InputDecoration(
                          labelText: 'Product Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 5,

                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: productPriceController,
                        decoration: InputDecoration(
                          labelText: 'Product Price',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter product price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid price';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: productTermsController,
                        decoration: InputDecoration(
                          labelText: 'Product Terms',
                          border: OutlineInputBorder(),
                        ),

                      ),
                      SizedBox(height: 20),

                      DropdownButtonFormField<CategoryModel>(
                        items: cubit.get(context).categories.map<DropdownMenuItem<CategoryModel>>(
                                (value) {
                              return DropdownMenuItem<CategoryModel>(
                                value: value,
                                child: Text(value.title??''),
                              );
                            }).toList(),
                       // decoration:,
                       // style: ,
                        validator: (value) {
                          if (value == null) {
                            return 'please choose the category';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          productCategoryIDController.text = '${value?.id??''}';
                        },
                        autofocus: false,
                      ),

                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: cubit.get(context).pickImages,
                child: Text(
                  'Pick Imaged',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ConditionalBuilder(
                condition:
                    state is ImagePickLoading || state is ImagePickFailed,
                builder: (context) {
                  return Center(child: CircularProgressIndicator());
                },
                fallback: (context) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: cubit.get(context).images.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(cubit.get(context).images[index]),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Add product to database or API call


                    cubit.get(context).addProduct(ProductModel(
                        title: productTitleController.text,
                        coverImage: cubit.get(context).images.first,
                        description: productDescriptionController.text,
                        images: cubit.get(context).images,
                        price: int.parse(productPriceController.text),
                        occupied: [],
                        terms: productTermsController.text,
                        categoryID: productCategoryIDController.text

                    ));

                  }
                },
                child: Text(
                  'Add Product',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
