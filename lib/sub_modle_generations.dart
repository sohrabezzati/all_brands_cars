import 'package:flutter/material.dart';
import 'car_full_spaces.dart';
import 'getting_all_info.dart';

class SubModleGneration extends StatefulWidget {
  final String title;
  final String brandUrl;
  const SubModleGneration({
    super.key,
    required this.title,
    required this.brandUrl,
  });

  @override
  State<SubModleGneration> createState() => _SubModleGnerationState();
}

class _SubModleGnerationState extends State<SubModleGneration> {
  final gettingData = GettingData();
  List mainTitle = [];
  List subTitle = [];
  List subPower = [];
  List urls = [];

  final String baseUrl = "https://www.auto-data.net";

  @override
  void initState() {
    settingData();
    super.initState();
  }

  void settingData() async {
    await gettingData
        .gettingSubGeneration(baseUrl + widget.brandUrl)
        .whenComplete(() {
      setState(() {
        mainTitle = gettingData.subGenrationMainTitles;
        subTitle = gettingData.subGenrationSubTitles;
        urls = gettingData.subGenrationUrls;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint("mainTitle : \n ${mainTitle.length}\n$mainTitle");
    // debugPrint("urls : \n ${urls.length}\n$urls");
    // debugPrint("brandUrl : ${widget.brandUrl}");
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
      body: mainTitle.isEmpty
          ? const Center(
              child: Text("Coming Soon ..."),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              physics: const BouncingScrollPhysics(),
              itemCount: mainTitle.length,
              itemBuilder: (BuildContext context, int index) {
                return LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  return Card(
                    color: Theme.of(context).colorScheme.onBackground,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16.0),
                      splashColor: Theme.of(context).colorScheme.surface,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FullSpecsesOfCar(
                                    title: subTitle[index],
                                    brandUrl: urls[index],
                                  )),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(mainTitle[index],
                            textScaleFactor: 1,
                            maxLines: 3,
                            style: Theme.of(context).textTheme.headlineLarge),
                      ),
                    ),
                  );
                });
              },
            ),
    );
  }
}
