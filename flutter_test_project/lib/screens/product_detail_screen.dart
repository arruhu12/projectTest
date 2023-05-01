import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter_test_project/model/product_model.dart';
import 'package:flutter_test_project/services/product_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:numberpicker/numberpicker.dart';

class ProductDetailPage extends StatefulWidget {
  Product product;
  ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with TickerProviderStateMixin {
  late Product product;
  int _current = 0;
  int _currentQty = 0;
  final CarouselController _controller = CarouselController();

  // State For Scrolling
  double spaceBetween = 10.0;
  final _duration = Duration(milliseconds: 200);

  _onStartScroll(ScrollMetrics metrics) {}

  _onUpdateScroll(ScrollMetrics metrics) {
    if (spaceBetween == 30.0) return;
    spaceBetween = 30.0;
    setState(() {});
  }

  _onEndScroll(ScrollMetrics metrics) {
    spaceBetween = 10.0;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    product = widget.product;
    print(product.images[0]);
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollStartNotification) {
          _onStartScroll(scrollNotification.metrics);
        } else if (scrollNotification is ScrollUpdateNotification) {
          _onUpdateScroll(scrollNotification.metrics);
        } else if (scrollNotification is ScrollEndNotification) {
          _onEndScroll(scrollNotification.metrics);
        }
        return true; // see docs
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(children: [
              Stack(
                children: [
                  Container(
                    color: Colors.black,
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                            autoPlay: true,
                            height: 300,
                            viewportFraction: 1,
                            enlargeCenterPage: false,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            },
                          ),
                          carouselController: _controller,
                          items: product.images
                              .map<Widget>(
                                (item) => Stack(
                                  children: [
                                    Container(
                                      child: Center(
                                          child: Image.network(
                                        item,
                                        fit: BoxFit.fill,
                                        width: 1000,
                                        height: 300,
                                      )),
                                    ),
                                    Container(
                                      color: Colors.black.withOpacity(0.4),
                                      width: 1000,
                                      height: 300,
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 30,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: product.images
                                .asMap()
                                .entries
                                .map<Widget>((entry) {
                              return GestureDetector(
                                onTap: () {
                                  _controller.animateToPage(entry.key);
                                },
                                child: Container(
                                  width: 12.0,
                                  height: 12.0,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 4.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withOpacity(
                                          _current == entry.key ? 0.9 : 0.4)),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Positioned(
                            bottom: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(40),
                                      topLeft: Radius.circular(40)),
                                  color: Colors.white),
                              width: MediaQuery.of(context).size.width,
                              height: 30,
                            ))
                      ],
                    ),
                  ),
                ],
              ),

              // Main Body
              Container(
                padding: EdgeInsets.only(right: 20, left: 20, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.brand,
                                style: GoogleFonts.lato(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              ),
                              Text(
                                product.title,
                                style: GoogleFonts.lato(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              )
                            ],
                          ),
                          Text(
                            "\$ ${product.price}",
                            style: GoogleFonts.lato(
                                fontSize: 25,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(Icons.compare),
                        Text("Compare"),
                        const SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.question_mark_outlined),
                        Text("Ask Question"),
                        const SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.share),
                        Text("Share"),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(product.description),
                  ],
                ),
              )
            ]),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Container(
            height: 80,
            margin: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 100,
                  child: NumberInputWithIncrementDecrement(
                    controller: TextEditingController(),
                    min: 1,
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 250, height: 60),
                  child: ElevatedButton(
                    child: Text('ADD TO CART'),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
