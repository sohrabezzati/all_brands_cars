import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'getting_all_info.dart';

class FullSpecsesOfCar extends StatefulWidget {
  final String title;
  final String brandUrl;

  const FullSpecsesOfCar({
    super.key,
    required this.title,
    required this.brandUrl,
  });

  @override
  State<FullSpecsesOfCar> createState() => _FullSpecsesOfCarState();
}

class _FullSpecsesOfCarState extends State<FullSpecsesOfCar> {
  final gettingData = GettingData();
  List fullSpacsesByKeyKey = [];
  List fullSpacsesByKeyValue = [];
  List fullSpacsesCredaintionalKay = [];
  List fullSpacsesCredaintionalValue = [];
  List images = [];

  List mainTitles = [];

  // List subPower = [];
  // List urls = [];

  final String baseUrl = "https://www.auto-data.net";

  @override
  void initState() {
    settingData();
    super.initState();
  }

  void settingData() async {
    await gettingData
        .getSixImageOfEachBrand(baseUrl + widget.brandUrl)
        .whenComplete(() {
      if (mounted) {
        setState(() {
          images = gettingData.finalImageSursces;
        });
      }
    });
    await gettingData
        .gettingFullSpecses(baseUrl + widget.brandUrl)
        .whenComplete(() {
      if (mounted) {
        setState(() {
          fullSpacsesByKeyKey = gettingData.fullSpascesKeykeyspecs;
          fullSpacsesByKeyValue = gettingData.fullSpascesValuekeyspecs;
          fullSpacsesCredaintionalKay = gettingData.fullSpascesKeycardetailsout;
          fullSpacsesCredaintionalValue =
              gettingData.fullSpascesValuecardetailsout;
          mainTitles = gettingData.carSpascesTitle;

          // subPower = gettingData.genrationPower;
          // urls = gettingData.genrationUrlS;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("mainTitle : \n ${mainTitles.length}\n$mainTitles");
    debugPrint("Imge src : \n ${images.length}\n$images");
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).textTheme.titleLarge!.color,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(textAlign: TextAlign.center, widget.title),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          centerTitle: true,
          elevation: 0,
          titleTextStyle: Theme.of(context).textTheme.titleLarge),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            if (images.isEmpty)
              const Text('No Images Found For This Car!')
            else
              CarouselSlider.builder(
                options: CarouselOptions(
                  autoPlay: true,
                  animateToClosest: true,
                  autoPlayInterval: const Duration(seconds: 5),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  scrollDirection: Axis.horizontal,
                  enlargeCenterPage: true,
                ),
                itemCount: images.length,
                itemBuilder: (context, index, realIndex) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: InteractiveViewer(
                      minScale: 0.1,
                      maxScale: 5.0,
                      child: CachedNetworkImage(
                        placeholder: (context, url) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            ),
                          );
                        },
                        imageUrl: images[index],
                        fit: BoxFit.fill,
                        fadeOutCurve: Curves.easeIn,
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(
              height: 8,
            ),
            ListView.builder(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: mainTitles.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.all(4),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    collapsedShape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    title: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(mainTitles[index]),
                    ),
                    children: [
                      ListView.builder(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: index == 0
                            ? fullSpacsesByKeyKey.length
                            : fullSpacsesCredaintionalKay.length,
                        itemBuilder: (BuildContext context, int innerIndex) {
                          return Table(
                            border: TableBorder.all(
                                color: const Color.fromARGB(255, 209, 163, 163),
                                width: 0.3),
                            children: [
                              TableRow(
                                decoration:
                                    BoxDecoration(color: Colors.grey[200]),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          index == 0
                                              ? fullSpacsesByKeyKey[innerIndex]
                                              : fullSpacsesCredaintionalKay[
                                                  innerIndex],
                                          maxLines: 3,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 166, 98, 93)),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          index == 0
                                              ? fullSpacsesByKeyValue[
                                                  innerIndex]
                                              : fullSpacsesCredaintionalValue[
                                                  innerIndex],
                                          textScaleFactor: 1,
                                          textAlign: TextAlign.center,
                                          maxLines: 20,
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayLarge,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
