import 'dart:async';
import 'dart:core';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'app_them.dart';
import 'drawer_menu.dart';
import 'getting_all_info.dart';
import 'submodels_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  final customInstance = InternetConnectionChecker.createInstance(
    checkTimeout: const Duration(seconds: 1), // Custom check timeout
    checkInterval: const Duration(milliseconds: 500), // Custom check interval
  );

  GetIt.instance.registerSingleton<InternetConnectionChecker>(
    customInstance,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme(context),
      debugShowCheckedModeBanner: false,
      home: const AllBrandsPage(),
    );
  }
}

class AllBrandsPage extends StatefulWidget {
  const AllBrandsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AllBrandsPageState createState() => _AllBrandsPageState();
}

class _AllBrandsPageState extends State<AllBrandsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool isSearching = false;
  String baseUrl = "https://www.auto-data.net";
  TextEditingController searchController = TextEditingController();
  final gettingData = GettingData();
  List<dynamic> searchResultTitles = [];
  List<dynamic> searchResultUrls = [];
  List<dynamic> searchResultLogoAddres = [];
  List<dynamic> brandTitle = [];
  List<dynamic> logoAddres = [];
  List<dynamic> brandUrl = [];

  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  bool errorAcourd = false;

  @override
  void initState() {
    requestPermission();
    getConnectivity();
    super.initState();
  }

  Future<void> requestPermission() async {
    var status = await Permission.camera.request();

    if (status == PermissionStatus.granted) {
      // Permission granted
    } else if (status == PermissionStatus.denied) {
      // Permission denied
    } else if (status == PermissionStatus.permanentlyDenied) {
      // Permission permanently denied
    }
  }

  getConnectivity() => subscription =
          GetIt.instance<InternetConnectionChecker>().onStatusChange.listen(
        (event) async {
          debugPrint("Checking $event");
          isDeviceConnected = await GetIt.instance
              .get<InternetConnectionChecker>()
              .hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
          } else {
            if (brandTitle.isEmpty && logoAddres.isEmpty && brandUrl.isEmpty) {
              await gettingData.settingAllLogoAndTitle().whenComplete(() {
                setState(() {
                  brandTitle = gettingData.firstTitles;
                  logoAddres = gettingData.logoImageSources;
                  brandUrl = gettingData.brandUrl;
                });
              });
            }
            // .catchError((error) {
            //   setState(() {
            //     errorAcourd = true;
            //   });
            // })
            // .whenComplete(() {
            //   if (errorAcourd && isAlertSet == false) {
            //     showDialogBox();
            //     setState(() {
            //       isAlertSet = true;
            //       errorAcourd = false;
            //     });
            //   }
            // })
            // .onError((error, stackTrace) {
            //   const SnackBar(
            //     content: Text("Unknown Error accord please restart the app!"),
            //     duration: Duration(seconds: 15),
            //   );
            // })
            // .timeout(const Duration(seconds: 5), onTimeout: () {
            //   const SnackBar(
            //     content: Text("Time out error!"),
            //     duration: Duration(seconds: 15),
            //   );
            // });
          }
        },
      );

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  showDialogBox() => showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Center(
            child: Text('No Connection'),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          content: const Text(
            'Please check your internet connectivity',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            const Divider(thickness: 1),
            Center(
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).colorScheme.primary),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                ),
                onPressed: () async {
                  Navigator.pop(context, 'Cancel');
                  setState(() => isAlertSet = false);
                  if (!isDeviceConnected && isAlertSet == false) {
                    showDialogBox();
                    setState(() => isAlertSet = true);
                  }
                },
                child: Text(
                  'OK',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const MyDrawer(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: isSearching
          ? appBarWhenSearching(context)
          : appBarWhenNotSearching(context),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: ItemBulderAllBrands(
            brandTitle: brandTitle,
            brandUrl: brandUrl,
            baseUrl: baseUrl,
            logoAddres: logoAddres,
            isSearching: isSearching,
            searchResultTitles: searchResultTitles,
            searchResultUrls: searchResultUrls,
            searchResultLogoAddres: searchResultLogoAddres),
      ),
    );
  }

  AppBar appBarWhenNotSearching(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      leading: IconButton(
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        icon: Icon(
          Icons.menu,
          color: Theme.of(context).textTheme.headlineLarge!.color,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              isSearching = true;
              searchResultTitles = [];
            });
          },
          icon: Icon(
            Icons.search,
            color: Theme.of(context).textTheme.headlineLarge!.color,
          ),
        ),
      ],
      centerTitle: true,
      titleTextStyle: Theme.of(context).textTheme.titleLarge,
      title: const Text(
        "AllBrands",
      ),
    );
  }

  AppBar appBarWhenSearching(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      title: TextField(
        autofocus: true,
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search,
              color: Theme.of(context).textTheme.labelMedium!.color),
          hintText: 'Search on all brands',
          hintStyle:
              TextStyle(color: Theme.of(context).textTheme.labelMedium!.color),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.onPrimary,
        ),
        onChanged: (value) {
          if (value.isEmpty) {
            // if the search field is empty, show all items
            setState(() {
              searchResultTitles = brandTitle;
              searchResultUrls = brandUrl;
              searchResultLogoAddres = logoAddres;
            });
          } else {
            // filter items that match the search query
            List<dynamic> tempListTitle = brandTitle
                .where(
                    (item) => item.toLowerCase().contains(value.toLowerCase()))
                .toList();
            debugPrint(brandUrl.first.toString());
            List<dynamic> tempListUrls = brandUrl
                .where((item) => item
                    .substring(4, item.length - 9)
                    .toLowerCase()
                    .contains(value.toLowerCase()))
                .toList();

            List<dynamic> tempListLogos = logoAddres
                .where((item) => item
                    .substring(11, item.length - 4)
                    .toLowerCase()
                    .contains(value.toLowerCase()))
                .toList();

            setState(() {
              searchResultTitles = tempListTitle;
              searchResultUrls = tempListUrls;
              searchResultLogoAddres = tempListLogos;
              // debugPrint(searchResults.toString());
            });
          }
        },
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,

          color: Theme.of(context).textTheme.headlineLarge!.color,
        ),
        onPressed: () {
          setState(() {
            searchController.text = "";
            isSearching = false;
            debugPrint("arrow_back");
          });
        },
      ),
    );
  }
}

class ItemBulderAllBrands extends StatelessWidget {
  const ItemBulderAllBrands({
    super.key,
    required this.brandTitle,
    required this.baseUrl,
    required this.logoAddres,
    required this.isSearching,
    required this.searchResultTitles,
    required this.brandUrl,
    required this.searchResultUrls,
    required this.searchResultLogoAddres,
  });

  final List searchResultLogoAddres;
  final List searchResultUrls;
  final List brandTitle;
  final String baseUrl;
  final List brandUrl;
  final List logoAddres;
  final bool isSearching;
  final List searchResultTitles;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 200,
        // childAspectRatio: (MediaQuery.of(context).size.height /
        //         MediaQuery.of(context).size.width) *
        //     0.5,
      ),
      itemBuilder: (BuildContext context, int index) {
        return CardOfEachBrand(
            brandTitle: brandTitle,
            baseUrl: baseUrl,
            brandUrl: brandUrl,
            logoAddres: logoAddres,
            index: index,
            searchResultTitles: searchResultTitles,
            searchResultLogoAddres: searchResultLogoAddres,
            searchResultUrls: searchResultUrls,
            isSearching: isSearching);
      },
      itemCount: isSearching ? searchResultTitles.length : brandTitle.length,
    );
  }
}

class CardOfEachBrand extends StatelessWidget {
  const CardOfEachBrand(
      {super.key,
      required this.brandTitle,
      required this.baseUrl,
      required this.logoAddres,
      required this.index,
      required this.brandUrl,
      required this.isSearching,
      required this.searchResultUrls,
      required this.searchResultTitles,
      required this.searchResultLogoAddres});

  final List searchResultLogoAddres;
  final List searchResultUrls;
  final List brandTitle;
  final String baseUrl;
  final List brandUrl;
  final List logoAddres;
  final int index;
  final bool isSearching;
  final List searchResultTitles;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: InkWell(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        splashColor: Theme.of(context).colorScheme.surface,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ListOfSubModels(
                      title: isSearching
                          ? searchResultTitles[index]
                          : brandTitle[index],
                      brandUrl: isSearching
                          ? searchResultUrls[index]
                          : brandUrl[index],
                    )),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 4,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                  ),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CachedNetworkImage(
                    placeholderFadeInDuration:
                        const Duration(milliseconds: 1),
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    imageUrl: isSearching
                        ? baseUrl + searchResultLogoAddres[index]
                        : baseUrl + logoAddres[index],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              flex: 1,
              child: Text(
                  isSearching ? searchResultTitles[index] : brandTitle[index],
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                  textScaleFactor: 1),
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
