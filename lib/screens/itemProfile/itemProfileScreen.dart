
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../cubit/cubit.dart';
import '../../cubit/states.dart';
import '../../db/db.dart';
import '../../shared/custom_calender_widget.dart';

import '../../shared/request_form.dart';
class ItemProfile extends StatefulWidget {

  var id;
  ItemProfile( this.id);

  @override
  State<ItemProfile> createState() => _ItemProfileState();
}

class _ItemProfileState extends State<ItemProfile> {


  @override
  void initState() {
    super.initState();
    cubit.get(context).getProduct(widget.id);
  }



  @override
  Widget build(BuildContext context) {

    CustomCalendarWidget calender= CustomCalendarWidget(busyDates: cubit.get(context).product.occupied,);
    final List<dynamic> imageUrls = cubit.get(context).product.images;

    var imagePageController=PageController();
    return BlocConsumer<cubit,States>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 350, // Adjust the height as needed
                      child: PageView.builder(
                        controller: imagePageController,
                        itemCount: imageUrls.length,
                        itemBuilder: (context, index) {
                          return Image.network(
                            imageUrls[index],
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                    AppBar (
                      backgroundColor: Colors.transparent,
                      actions: [

                      ],
                      leading: BackButton(style: ButtonStyle(backgroundColor: WidgetStateColor.resolveWith((states) => Colors.green.shade300.withOpacity(0.3),)),),
                    ),


                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 30,

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                        ),

                      ),
                    ),
                    Positioned(
                      bottom: 50,
                      left: 10,
                      child: SmoothPageIndicator(
                        count:  imageUrls.length,
                        axisDirection: Axis.horizontal,
                        effect:  ExpandingDotsEffect(
                          activeDotColor: Colors.lightGreenAccent,
                          dotHeight: 10,
                          expansionFactor: 1.3,
                          dotWidth: 25,
                        ),
                        controller: imagePageController,
                      ),
                    ),
                  ],
                ),
                Expanded(

                  child: ListView(
                      shrinkWrap: true,
                      children: [
                        Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(

                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:  [
                            Text(
                              cubit.get(context).product.title??'',
                              style: TextStyle(fontSize: 25,fontWeight:
                              FontWeight.bold,),
                            ),
                            SizedBox(height: 10,),

                            Text('Description',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18

                              ),
                            ),
                            SizedBox(height: 10,),

                            Text(cubit.get(context).product.description??'',
                            ),
                            SizedBox(height: 10,),

                            Text(
                              'Terms and conditions',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18

                              ),
                            ),
                            SizedBox(height: 10,),

                            Text(
                              cubit.get(context).product.terms??'',
                            ),
                            SizedBox(height: 10,),



                          ],
                        ),
                      ),
                        calender   ,
                      ]
                  ),
                ),
                Stack(
                    children: [
                      Container(
                        height: 100,
                        width: double.infinity,// Adjust the height as needed
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25)),
                        ),

                      ),

                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rental Price',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${cubit.get(context).product.price??''} EGP / day',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            ElevatedButton(
                              onPressed: ()  {
                                // Implement deleting logic here
                                // print(calender.dates);
                                if(calender.dates.isNotEmpty) {
                                  showRequestForm(context,calender.dates);
                                }
                              },
                              child: Text('Book',style: TextStyle(color: Colors.white),),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ]
                ),
              ],
            ),
          );

        },
    );
  }
}
